import 'package:expandable/expandable.dart';
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
        return bookPanel(context, idx == results.length - 1, e);
      }).toList(),
    );
  }
}

Widget starSideGreyBox(QueryResultEntry e) {
  return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 1, offset: Offset(0, 5), spreadRadius: -2, color: Color(0x77000000))],
          color: Color(0xffeeeeee),
          borderRadius: BorderRadius.all(Radius.circular(10))),
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

Widget bookPanel(BuildContext context, bool isLast, QueryResultEntry e) {
  return bookPanelContainer(
      isLast,
      e.searchResultNum,
      Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
          child: ExpandablePanel(
              expanded: bookPanelContents(
                  e,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text1, style: quoteStyle),
                      Text(text1, style: quoteStyle),
                      Text(text1, style: quoteStyle),
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("Collapse", style: expandStyle),
                    SizedBox(width: 5),
                    Icon(Icons.remove_circle_outline_outlined, color: primaryColor)
                  ])),
              collapsed: bookPanelContents(
                  e,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("...knock your socks off, couldn't put it down...", style: quoteStyle),
                      Text("...you’ll absolutely laugh your socks off...", style: quoteStyle),
                      Text("...blew my socks off. Best thing I’ve read in years...", style: quoteStyle)
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("Expand", style: expandStyle),
                    SizedBox(width: 5),
                    Icon(Icons.add_circle_outline_outlined, color: primaryColor)
                  ])))));
}

Widget bookPanelContents(QueryResultEntry e, Widget child, Widget expandyWidget) {
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(e.title, style: bookTitleStyle),
          Text(e.author, style: authorStyle),
          //Expanded(child: Container()),
          child,
        ],
      ),
    ),
    Expanded(
      flex: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          starSideGreyBox(e),
          //Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 5.0),
            child: ExpandableButton(
              child: expandyWidget,
            ),
          ),
        ],
      ),
    ),
  ]);
}
