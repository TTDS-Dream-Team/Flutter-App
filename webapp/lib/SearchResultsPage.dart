import 'dart:async';
import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              color: Color(0xff1b4a81),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: EdgeInsets.all(10),
                            decoration:
                                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                            child: Logo(fontSize: 60.0)),
                        Row(
                          children: [
                            Text(
                              "Sort by: ",
                              style: TextStyle(fontSize: 22.0, color: Colors.white),
                            ),
                            SizedBox(width: 200, height: 40, child: SearchSortDropdown()),
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
                          color: Colors.white,
                          hoverColor: Colors.grey[100],
                          splashColor: Colors.grey[200],
                          padding: EdgeInsets.all(12.0),
                          child: Icon(Icons.arrow_back, color: textColor),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                            child: Searchbar((String string) {
                          setState(() {});
                          widget.controller.search(string);
                        }, widget.controller.txt)),
                      ],
                    ),
                  ],
                ),
              )),
          Expanded(
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: SearchFilters()),
                    SizedBox(width: 40),
                    Expanded(
                      flex: 2,
                      child: FutureBuilder(
                          key: Key(widget.controller.searchString),
                          future: http
                              .get(Uri.http('34.71.136.188:8000', 'search/${widget.controller.searchString}'))
                              .timeout(Duration(seconds: 15)),
                          builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
                            if (snapshot.hasData) {
                              return SearchResultsList(getQueries(snapshot.data.body));
                            } else if (snapshot.hasError) {
                              String errorText = snapshot.error.toString();
                              if (snapshot.error is TimeoutException) {
                                errorText = "Server timed out";
                              }
                              return Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
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
                                    backgroundColor: Colors.white,
                                  ),
                                  width: 60,
                                  height: 60,
                                ),
                              );
                            }
                          }),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}

class SearchFilters extends StatefulWidget {
  @override
  _SearchFiltersState createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  double _lowerStars = 0;
  double _upperStars = 10;
  double _lowerYear = 1950;
  double _upperYear = 2021;

  @override
  Widget build(BuildContext context) {
    var handleDecor = BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black54,
          blurRadius: 3,
          spreadRadius: 0.2,
          offset: Offset(0, 1),
        )
      ],
      color: Colors.white,
      shape: BoxShape.circle,
    );
    return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpandablePanel(
              header: Column(
                children: [
                  Divider(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rating", style: bookTitleStyle),
                      Text("${_lowerStars / 2} - ${_upperStars / 2}", style: authorStyle)
                    ],
                  ),
                ],
              ),
              collapsed: Container(),
              expanded: FlutterSlider(
                tooltip: FlutterSliderTooltip(disabled: true),
                values: [_lowerStars, _upperStars],
                rangeSlider: true,
                max: 10.0,
                min: 0.0,
                handler: FlutterSliderHandler(
                  child: Text("${_lowerStars / 2}", style: bookTitleStyle.copyWith(fontSize: 18)),
                  decoration: handleDecor,
                ),
                rightHandler: FlutterSliderHandler(
                  child: Text("${_upperStars / 2}", style: bookTitleStyle.copyWith(fontSize: 18)),
                  decoration: handleDecor,
                ),
                hatchMark: FlutterSliderHatchMark(
                  density: 0.5,
                  displayLines: true,
                  smallLine: FlutterSliderSizedBox(width: 1, height: 1),
                ),
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  _lowerStars = lowerValue;
                  _upperStars = upperValue;
                  setState(() {});
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
                      Text("${_lowerYear.toInt()} - ${_upperYear.toInt()}", style: authorStyle)
                    ],
                  ),
                ],
              ),
              collapsed: Container(),
              expanded: Column(
                children: [
                  FlutterSlider(
                    tooltip: FlutterSliderTooltip(disabled: true),
                    values: [_lowerYear, _upperYear],
                    rangeSlider: true,
                    max: 2021,
                    min: 1950,
                    handler: FlutterSliderHandler(
                      child: Text("'${"$_lowerYear".substring(2, 4)}", style: bookTitleStyle.copyWith(fontSize: 18)),
                      decoration: handleDecor,
                    ),
                    rightHandler: FlutterSliderHandler(
                      child: Text("'${"$_upperYear".substring(2, 4)}", style: bookTitleStyle.copyWith(fontSize: 18)),
                      decoration: handleDecor,
                    ),
                    hatchMark: FlutterSliderHatchMark(
                      density: 0.5,
                      displayLines: true,
                      smallLine: FlutterSliderSizedBox(width: 1, height: 1),
                    ),
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      _lowerYear = lowerValue;
                      _upperYear = upperValue;
                      setState(() {});
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
                      Text("Genre", style: bookTitleStyle),
                    ],
                  ),
                ],
              ),
              collapsed: Container(),
              expanded: GenreGrid(),
            ),
            Divider(color: Colors.black54),
            Center(child: Logo(fontSize: 40.0)),
          ],
        ));
  }
}

class GenreGrid extends StatefulWidget {
  @override
  _GenreGridState createState() => _GenreGridState();
}

class _GenreGridState extends State<GenreGrid> {
  var allValues = {
    "Action": false,
    "Adventure": false,
    "Biography": false,
    "Children": false,
    "Classic": false,
    "Comedy/Humour": true,
    "Detective": false,
    "Drama": false,
    "Education": true,
    "Fantasy": false,
    "Fiction": false,
    "History": false,
    "Horror": false,
    "Mystery": false,
    "Non-fiction": false,
    "Politics": false,
    "Romance": false,
    "Scientific": false,
    "Sci-fi": false,
    "Young Adult": false,
  };

  @override
  Widget build(BuildContext context) {
    var numRows = allValues.keys.length ~/ 2;
    List<Widget> columns = [];
    for (int j = 0; j < 2; j++) {
      List<Widget> rows = [];
      for (int i = 0; i < numRows; i++) {
        var key = allValues.keys.toList()[i + numRows * j];
        rows.add(Row(children: [
          Checkbox(
              checkColor: Colors.white,
              activeColor: primaryColor,
              value: allValues[key],
              onChanged: (newV) {
                allValues[key] = newV;
                setState(() {});
              }),
          Text(key, style: authorStyle),
        ]));
      }
      columns.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows,
      ));
    }

    return Row(
      children: columns,
    );
  }
}

class SearchResultsList extends StatelessWidget {
  SearchResultsList(this.results);
  List<QueryResultEntry> results;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: results.asMap().entries.map((entry) {
        int idx = entry.key;
        var e = entry.value;
        return BookPanel(idx == results.length - 1, e);
      }).toList(),
    );
  }
}

Widget starSideGreyBox(QueryResultEntry e, bool isExpanded) {
  return AnimatedContainer(
      padding: EdgeInsets.symmetric(vertical: isExpanded ? 10 : 10, horizontal: 10),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 1, offset: Offset(0, 5), spreadRadius: -2, color: Color(0x77000000))],
          color: Color(0xffeeeeee),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      duration: Duration(milliseconds: 200),
      child: Column(
        children: [
          starWidget(e.avgRating),
          Text("${e.avgRating}/5", style: quoteStyle),
          Text("(${oCcy.format(e.numReviews)} reviews)", style: reviewsStyle),
          Wrap(
            children: [
              Text("Ranked ", style: genreStyle),
              Text("#${e.genreRanking} ", style: boldGenreStyle),
              Text("in ", style: genreStyle),
              Text("${e.genre}", style: boldGenreStyle),
            ],
          ),
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
                      color: Colors.white,
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
      bool canExpand = true;
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
        double widthGuess = constraint.minWidth / 2 - 20; // Fragile and horrible, but heyo
        double textSize = _textSize(newText, quoteStyle, widthGuess).height;
        if (textSize < 100 && widget.e.reviews.length == 1) {
          canExpand = false;
        }
        children.add(AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: isExpanded ? textSize : 100,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: newText.substring(0, newStart)),
                TextSpan(text: r.foundText, style: quoteStyle.copyWith(fontWeight: FontWeight.bold)),
                TextSpan(text: newText.substring(newEnd))
              ],
              style: quoteStyle,
            ),
            maxLines: absolute_max_review_length,
            overflow: TextOverflow.ellipsis,
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
              color: Colors.white,
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
                    Text(
                      widget.e.title,
                      style: bookTitleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(widget.e.author, style: authorStyle),
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
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    starSideGreyBox(widget.e, isExpanded),
                    Expanded(child: Container()),
                    if (canExpand)
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 5.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(isExpanded ? "Collapse" : "Expand", style: expandStyle),
                              SizedBox(width: 5),
                              Icon(
                                  isExpanded ? Icons.remove_circle_outline_outlined : Icons.add_circle_outline_outlined,
                                  color: primaryColor)
                            ]),
                          )),
                  ])),
            ],
          ),
        ),
      );
    });
  }
}
