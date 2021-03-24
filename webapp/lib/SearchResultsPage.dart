import 'dart:async';
import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import 'HomePage.dart';
import 'Utils.dart';
import 'main.dart';

class SearchResults extends StatefulWidget {
  SearchResults(this.controller);
  PageContrContr controller;

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    widget.controller.resetSwitch = () {
      this.setState(() {});
    };
    var sort = "relevance";
    switch (widget.controller.sort) {
      case 1:
        sort = "popularity";
        break;
      case 2:
        sort = "rating_asc";
        break;
      case 3:
        sort = "rating_desc";
        break;
      default:
        break;
    }
    var searchString = 'search/${widget.controller.searchString}?'
        'measure_time=true'
        '&semantic_weight=${widget.controller.semWeight / 10}'
        '&exact_weight=${widget.controller.exactWeight / 10}'
        '&sentiment_weight=${widget.controller.senWeight / 10}'
        '&weight_combination=sum'
        '&rating_min=${widget.controller.ratingMin / 2}'
        '&rating_max=${widget.controller.ratingMax / 2}'
        '&year_min=${widget.controller.yearMin}'
        '&year_max=${widget.controller.yearMax}'
        '&result_number=100'
        '&sort=$sort';

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              color: Color(0xff2561a7),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Logo(fontSize: 60.0),
                        Row(
                          children: [
                            Container(width: 40),
                            Text(
                              "Sort by: ",
                              style: TextStyle(fontSize: 22.0, color: offWhite),
                            ),
                            SizedBox(width: 200, height: 40, child: SearchSortDropdown(widget.controller)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        FlatButton(
                          minWidth: 0,
                          shape: CircleBorder(),
                          onPressed: () {
                            widget.controller.back();
                          },
                          color: offWhite,
                          hoverColor: Colors.grey[100],
                          splashColor: Colors.grey[200],
                          padding: EdgeInsets.all(12.0),
                          child: Icon(Icons.arrow_back, color: textColor),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                            child: Searchbar((String string) {
                          widget.controller.search(string);
                        }, widget.controller.txt)),
                      ],
                    ),
                  ],
                ),
              )),
          Expanded(
            child: Listener(
                onPointerSignal: (ps) {
                  if (ps is PointerScrollEvent) {
                    var speed = 1.0 * ps.scrollDelta.dy;

                    final newOffset = _controller.offset + speed;
                    if (ps.scrollDelta.dy.isNegative) {
                      _controller.jumpTo(max(0, newOffset));
                    } else {
                      _controller.jumpTo(min(_controller.position.maxScrollExtent, newOffset));
                    }
                  }
                },
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SearchFilters(widget.controller),
                          ],
                        ),
                      )),
                  SizedBox(width: 40),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      controller: _controller,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      child: FutureBuilder(
                          key: Key(searchString),
                          future: http
                              .get('https://api.better-reads.xyz:8000/$searchString')
                              .timeout(Duration(seconds: 15)),
                          builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
                            if (snapshot.hasData) {
                              return SearchResultsList(
                                  getQueries(snapshot.data.body, widget.controller), widget.controller);
                            } else if (snapshot.hasError) {
                              String errorText = snapshot.error.toString();
                              if (snapshot.error is TimeoutException) {
                                errorText = "Server timed out";
                              }
                              return Container(
                                padding: EdgeInsets.all(20),
                                decoration:
                                    BoxDecoration(color: offWhite, borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 60,
                                    ),
                                    Text(
                                      "Sorry, something broke.",
                                      style: bookTitleStyle,
                                    ),
                                    Text(
                                      "$errorText",
                                      style: quoteStyle,
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return Center(
                                child: SizedBox(
                                  child: CircularProgressIndicator(
                                    backgroundColor: offWhite,
                                  ),
                                  width: 60,
                                  height: 60,
                                ),
                              );
                            }
                          }),
                    ),
                  )
                ])),
          )
        ],
      ),
    );
  }
}

class SearchFilters extends StatefulWidget {
  SearchFilters(this.controller);
  PageContrContr controller;

  @override
  _SearchFiltersState createState() => _SearchFiltersState();
}

var handleDecor = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.black54,
      blurRadius: 3,
      spreadRadius: 0.2,
      offset: Offset(0, 1),
    )
  ],
  color: offWhite,
  shape: BoxShape.circle,
);

class _SearchFiltersState extends State<SearchFilters> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: offWhite, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Filters",
                style: bookTitleStyle,
              ),
            ),
            Center(
              child: Text(
                "Change the filters to refine your search.",
                style: authorStyle,
              ),
            ),
            Divider(color: Colors.black54),
            ExpandablePanel(
              header: Column(
                children: [
                  Divider(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rating", style: bookTitleStyle),
                      Text("${widget.controller.ratingMin / 2} - ${widget.controller.ratingMax / 2}",
                          style: authorStyle)
                    ],
                  ),
                ],
              ),
              collapsed: Container(),
              expanded: FlutterSlider(
                tooltip: FlutterSliderTooltip(disabled: true),
                values: [widget.controller.ratingMin, widget.controller.ratingMax],
                rangeSlider: true,
                max: 10.0,
                min: 0.0,
                handler: FlutterSliderHandler(
                  child: Text("${widget.controller.ratingMin / 2}", style: bookTitleStyle.copyWith(fontSize: 18)),
                  decoration: handleDecor,
                ),
                rightHandler: FlutterSliderHandler(
                  child: Text("${widget.controller.ratingMax / 2}", style: bookTitleStyle.copyWith(fontSize: 18)),
                  decoration: handleDecor,
                ),
                hatchMark: FlutterSliderHatchMark(
                  density: 0.5,
                  displayLines: true,
                  smallLine: FlutterSliderSizedBox(width: 1, height: 1),
                ),
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  widget.controller.ratingMin = lowerValue;
                  widget.controller.ratingMax = upperValue;
                  setState(() {});
                },
                onDragCompleted: (a, b, c) {
                  widget.controller.reSearch();
                },
              ),
            ),
            Divider(color: Colors.black54),
            ExpandablePanel(
              header: Column(
                children: [
                  Divider(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Year of Release", style: bookTitleStyle),
                      Text("${widget.controller.yearMin.toInt()} - ${widget.controller.yearMax.toInt()}",
                          style: authorStyle)
                    ],
                  ),
                ],
              ),
              collapsed: Container(),
              expanded: Column(
                children: [
                  FlutterSlider(
                    tooltip: FlutterSliderTooltip(disabled: true),
                    values: [widget.controller.yearMin, widget.controller.yearMax],
                    rangeSlider: true,
                    max: 2021,
                    min: 1950,
                    handler: FlutterSliderHandler(
                      child: Text("'${"${widget.controller.yearMin}".substring(2, 4)}",
                          style: bookTitleStyle.copyWith(fontSize: 18)),
                      decoration: handleDecor,
                    ),
                    rightHandler: FlutterSliderHandler(
                      child: Text("'${"${widget.controller.yearMax}".substring(2, 4)}",
                          style: bookTitleStyle.copyWith(fontSize: 18)),
                      decoration: handleDecor,
                    ),
                    hatchMark: FlutterSliderHatchMark(
                      density: 0.5,
                      displayLines: true,
                      smallLine: FlutterSliderSizedBox(width: 1, height: 1),
                    ),
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      widget.controller.yearMin = lowerValue;
                      widget.controller.yearMax = upperValue;
                      setState(() {});
                    },
                    onDragCompleted: (a, b, c) {
                      widget.controller.reSearch();
                    },
                  ),
                ],
              ),
            ),
            Divider(color: Colors.black54),
            ExpandablePanel(
              header: Column(
                children: [
                  Divider(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Weighting", style: bookTitleStyle),
                    ],
                  ),
                ],
              ),
              collapsed: Container(),
              expanded: GenreGrid(widget.controller),
            ),
            Divider(color: Colors.black54),
            Center(
                child: Column(
              children: [
                Logo(
                  fontSize: 40.0,
                  color: primaryColor,
                ),
                Text("Version 1.0.2", style: authorStyle)
              ],
            )),
          ],
        ));
  }
}

class GenreGrid extends StatefulWidget {
  GenreGrid(this.controller);
  PageContrContr controller;

  @override
  _GenreGridState createState() => _GenreGridState();
}

class _GenreGridState extends State<GenreGrid> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Semantic Weight",
          style: authorStyle,
        ),
        FlutterSlider(
          tooltip: FlutterSliderTooltip(disabled: true),
          values: [widget.controller.semWeight],
          max: 10.0,
          min: 0.0,
          handler: FlutterSliderHandler(
            child: Text("${widget.controller.semWeight / 10}", style: bookTitleStyle.copyWith(fontSize: 18)),
            decoration: handleDecor,
          ),
          hatchMark: FlutterSliderHatchMark(
            density: 0.5,
            displayLines: true,
            smallLine: FlutterSliderSizedBox(width: 1, height: 1),
          ),
          onDragging: (handlerIndex, lowerValue, upperValue) {
            widget.controller.semWeight = lowerValue;
            setState(() {});
          },
          onDragCompleted: (a, b, c) {
            widget.controller.reSearch();
          },
        ),
        Text(
          "Exact Weight",
          style: authorStyle,
        ),
        FlutterSlider(
          tooltip: FlutterSliderTooltip(disabled: true),
          values: [widget.controller.exactWeight],
          max: 10.0,
          min: 0.0,
          handler: FlutterSliderHandler(
            child: Text("${widget.controller.exactWeight / 10}", style: bookTitleStyle.copyWith(fontSize: 18)),
            decoration: handleDecor,
          ),
          hatchMark: FlutterSliderHatchMark(
            density: 0.5,
            displayLines: true,
            smallLine: FlutterSliderSizedBox(width: 1, height: 1),
          ),
          onDragging: (handlerIndex, lowerValue, upperValue) {
            widget.controller.exactWeight = lowerValue;
            setState(() {});
          },
          onDragCompleted: (a, b, c) {
            widget.controller.reSearch();
          },
        ),
        Text(
          "Sentiment Weight",
          style: authorStyle,
        ),
        FlutterSlider(
          tooltip: FlutterSliderTooltip(disabled: true),
          values: [widget.controller.senWeight],
          max: 10.0,
          min: 0.0,
          handler: FlutterSliderHandler(
            child: Text("${widget.controller.senWeight / 10}", style: bookTitleStyle.copyWith(fontSize: 18)),
            decoration: handleDecor,
          ),
          hatchMark: FlutterSliderHatchMark(
            density: 0.5,
            displayLines: true,
            smallLine: FlutterSliderSizedBox(width: 1, height: 1),
          ),
          onDragging: (handlerIndex, lowerValue, upperValue) {
            widget.controller.senWeight = lowerValue;
            setState(() {});
          },
          onDragCompleted: (a, b, c) {
            widget.controller.reSearch();
          },
        ),
      ],
    );
  }
}

class SearchResultsList extends StatefulWidget {
  SearchResultsList(this.results, this.controller);
  List<QueryResultEntry> results;
  PageContrContr controller;

  @override
  _SearchResultsListState createState() => _SearchResultsListState();
}

class _SearchResultsListState extends State<SearchResultsList> {
  var numberShown = 10;

  @override
  Widget build(BuildContext context) {
    print("${widget.controller.sentiment} ${widget.controller.confidence}");
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: offWhite, borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
              child: Column(
            children: [
              Text(
                "Searched 69,604,548 reviews in ${(widget.controller.totalTime / 1000.0).toStringAsPrecision(3)} seconds",
                style: authorStyle,
              ),
              if (widget.controller.confidence > 0.6)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "BetterReads detected ",
                      style: authorStyle,
                    ),
                    Text(
                      "${widget.controller.sentiment > 2.5 ? "positive" : "negative"}",
                      style: authorStyle.copyWith(color: widget.controller.sentiment > 2.5 ? Colors.green : Colors.red),
                    ),
                    Text(
                      " sentiment in your search.",
                      style: authorStyle,
                    )
                  ],
                ),
            ],
          )),
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.results
              .asMap()
              .entries
              .map((entry) {
                int idx = entry.key;
                var e = entry.value;
                return BookPanel(idx == widget.results.length - 1, e);
              })
              .toList()
              .getRange(0, min(numberShown, 100))
              .toList(),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: offWhite, borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
              child: Column(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    numberShown += 10;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Show More", style: expandStyle),
                    SizedBox(width: 5),
                    Icon(Icons.add_circle_outline_outlined, color: primaryColor)
                  ],
                ),
              ),
            ],
          )),
        ),
      ],
    );
  }
}

Widget starSideGreyBox(QueryResultEntry e, bool isExpanded) {
  return AnimatedContainer(
      padding: EdgeInsets.symmetric(vertical: isExpanded ? 10 : 10, horizontal: 10),
      decoration: BoxDecoration(
          // boxShadow: [BoxShadow(blurRadius: 1, offset: Offset(0, 5), spreadRadius: -2, color: Color(0x77000000))],
          color: Color(0xffeeeeee),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      duration: Duration(milliseconds: 200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Review Rating", style: quoteStyle),
          starWidget(e.reviews[0].reviewRating.toDouble(), textColor),
          Text("Book Rating", style: quoteStyle),
          starWidget(e.avgRating, primaryColor),
          Text("${e.avgRating}/5", style: quoteStyle),
          Text("(${oCcy.format(e.numReviews)} reviews)", style: reviewsStyle),
        ],
      ));
}

Widget bookPanelContainer(TickerProvider vsync, bool isLast, int idx, Widget child) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 60,
              child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: offWhite,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
                  child: Text(
                    "$idx",
                    style: numberStyle,
                  )),
            ),
            SizedBox(width: 10),
            Expanded(child: child),
          ],
        ),
      ),
      if (!isLast) SizedBox(height: 20)
    ],
  );
}

class BookPanel extends StatefulWidget {
  BookPanel(this.isLast, this.e);
  final bool isLast;
  final QueryResultEntry e;
  @override
  _BookPanelState createState() => _BookPanelState();
}

int absolute_max_review_length = 60;

class _BookPanelState extends State<BookPanel> with TickerProviderStateMixin {
  bool isExpanded = false;
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    controller.forward();
  }

  Size _textSize(String text, TextStyle style, double width) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: absolute_max_review_length,
    )..layout(minWidth: 0, maxWidth: width);
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      List<Widget> children = [];
      int i = 0;
      for (var r in widget.e.reviews) {
        int offset = max(r.start - 100, 0);
        String newText = r.text.substring(offset);
        int newStart = r.start - offset;
        int newEnd = r.end - offset;
        if (offset > 0) {
          newText = "..." + newText;
          // For ellipsis
          newStart += 3;
          newEnd += 3;
        }
        // newText = newText.substring(0, newStart) + "<bold>" + r.foundText + "</bold>" + newText.substring(newEnd);
        children.add(ConstrainedBox(
          constraints: BoxConstraints(minHeight: 100, minWidth: 1000),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: SelectableText.rich(
              TextSpan(children: [
                TextSpan(text: newText.substring(0, newStart)),
                TextSpan(text: r.foundText, style: quoteStyle.copyWith(fontWeight: FontWeight.bold)),
                TextSpan(text: newText.substring(newEnd))
              ]),
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              scrollPhysics: NeverScrollableScrollPhysics(),
              style: quoteStyle,
              minLines: 5,
              maxLines: isExpanded ? absolute_max_review_length : 5,
            ),
          ),
        ));
        if (i != children.length - 1) {
          children.add(Center(
              child: AnimatedContainer(
            padding: EdgeInsets.symmetric(vertical: isExpanded ? 10 : 2),
            duration: Duration(milliseconds: 200),
            child: AnimatedContainer(
                duration: Duration(milliseconds: 200), width: 200, height: isExpanded ? 2 : 1, color: textColor),
          )));
        }
        i++;
      }
      return bookPanelContainer(
        this,
        widget.isLast,
        widget.e.searchResultNum,
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: offWhite,
              borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.e.imageURL,
                height: 180,
                width: 120,
                repeat: ImageRepeat.repeat,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        widget.e.title,
                        style: bookTitleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text("${widget.e.year}${widget.e.author}", style: authorStyle),
                    Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.grey[100]),
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: children,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                  flex: 3,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                starSideGreyBox(widget.e, isExpanded),
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 25),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isExpanded = !isExpanded;
                                    });
                                  },
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Text(isExpanded ? "Collapse" : "Expand  ", style: expandStyle),
                                    SizedBox(width: 5),
                                    Icon(
                                        isExpanded
                                            ? Icons.remove_circle_outline_outlined
                                            : Icons.add_circle_outline_outlined,
                                        color: primaryColor),
                                  ]),
                                ),
                                FlatButton(
                                    padding: EdgeInsets.all(0.0),
                                    onPressed: () {
                                      launch(widget.e.URL);
                                    },
                                    child: Image(height: 30, width: 30, image: AssetImage('assets/logo.png')))
                              ],
                            )),
                      ])),
            ],
          ),
        ),
      );
    });
  }
}
