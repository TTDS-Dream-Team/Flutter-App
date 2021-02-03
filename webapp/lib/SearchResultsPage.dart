import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'Utils.dart';
import 'main.dart';

class SearchResults extends StatelessWidget {
  SearchResults(this.controller);
  PageContrContr controller;

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
                            controller.goToPage(0);
                          },
                          color: Colors.white,
                          hoverColor: Colors.grey[100],
                          splashColor: Colors.grey[200],
                          padding: EdgeInsets.all(12.0),
                          child: Icon(Icons.arrow_back, color: textColor),
                        ),
                        SizedBox(width: 10),
                        Expanded(child: Searchbar((String string) {})),
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
                    Expanded(flex: 2, child: SearchResultsList(getQueries()))
                  ],
                )),
          )
        ],
      ),
    );
  }
}

class SearchFilters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Logo(fontSize: 60.0));
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
      padding: EdgeInsets.symmetric(vertical: isExpanded ? 30 : 10, horizontal: 10),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
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

Widget bookPanelContainer(bool isLast, int idx, Widget child) {
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

class _BookPanelState extends State<BookPanel> with TickerProviderStateMixin {
  bool isExpanded = false;
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return bookPanelContainer(
        widget.isLast,
        widget.e.searchResultNum,
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: isExpanded ? 480 : 180,
              child: bookPanelContents(
                  widget.e,
                  isExpanded,
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.grey[100]),
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedCrossFade(
                          firstChild: Text("...knock your socks off, super-scorcher, couldn’t put it down...",
                              overflow: TextOverflow.ellipsis, maxLines: 1, style: quoteStyle),
                          secondChild: Text(
                            text1,
                            style: quoteStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 6,
                          ),
                          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          duration: Duration(milliseconds: 200),
                        ),
                        Center(
                            child: AnimatedContainer(
                          padding: EdgeInsets.symmetric(vertical: isExpanded ? 10 : 2),
                          duration: Duration(milliseconds: 200),
                          child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: 200,
                              height: isExpanded ? 2 : 1,
                              color: textColor),
                        )),
                        AnimatedCrossFade(
                          firstChild:
                              Text("...you’ll absolutely laugh your socks off...", style: quoteStyle, maxLines: 1),
                          secondChild: Text(
                            text1,
                            style: quoteStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 6,
                          ),
                          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          duration: Duration(milliseconds: 200),
                        ),
                        Center(
                            child: AnimatedContainer(
                          padding: EdgeInsets.symmetric(vertical: isExpanded ? 10 : 2),
                          duration: Duration(milliseconds: 200),
                          child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: 200,
                              height: isExpanded ? 2 : 1,
                              color: textColor),
                        )),
                        AnimatedCrossFade(
                          firstChild: Text("...blew my socks off. Best thing I’ve read in years...",
                              style: quoteStyle, maxLines: 1),
                          secondChild: Text(
                            text1,
                            style: quoteStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 6,
                          ),
                          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          duration: Duration(milliseconds: 200),
                        )
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(isExpanded ? "Collapse" : "Expand", style: expandStyle),
                      SizedBox(width: 5),
                      Icon(isExpanded ? Icons.remove_circle_outline_outlined : Icons.add_circle_outline_outlined,
                          color: primaryColor)
                    ]),
                  )),
            )));
  }
}

Widget bookPanelContents(QueryResultEntry e, bool isExpanded, Widget child, Widget expandyWidget) {
  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Image(
      height: 180,
      image: AssetImage('assets/${e.imageString}'),
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
            e.title,
            style: bookTitleStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(e.author, style: authorStyle),
          child,
        ],
      ),
    ),
    SizedBox(width: 10),
    Expanded(
      flex: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          starSideGreyBox(e, isExpanded),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 5.0),
            child: expandyWidget,
          ),
        ],
      ),
    ),
  ]);
}
