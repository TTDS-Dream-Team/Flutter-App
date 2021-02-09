import 'dart:convert';

import 'package:flutter/material.dart';

import 'main.dart';

class Logo extends StatelessWidget {
  Logo({this.fontSize = 120.0});
  double fontSize;
  @override
  Widget build(BuildContext context) {
    return Text(
      'BetterReads',
      style: Theme.of(context).textTheme.headline1.copyWith(fontSize: fontSize),
    );
  }
}

Widget starWidget(double rating) {
  List<Widget> stars = [];
  for (int i = 0; i < 5; i++) {
    stars.add(Icon(
        rating <= i + 0.25
            ? Icons.star_border
            : (rating < i + 0.75 && rating > i + 0.25 ? Icons.star_half : Icons.star),
        color: primaryColor));
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: stars,
  );
}

List<QueryResultEntry> getQueries(String response) {
  Map<String, dynamic> responses = jsonDecode(response);
  List<QueryResultEntry> toRet = [];
  for (var r in responses.keys.toList()..sort()) {
    var res = responses[r];
    List<ReviewResult> reviews = [];
    reviews.add(ReviewResult(res["text"], res["relevant_text"], res["relevant_range"][0], res["relevant_range"][1]));
    toRet.add(QueryResultEntry(
        int.parse(r) + 1, res["title"], "No Author", 2020, 5.0, 0, "No Genre", 1, res["image"], reviews));
  }
  return toRet;
}

class ReviewResult {
  ReviewResult(this.text, this.foundText, this.start, this.end);
  String foundText;
  String text;
  int start;
  int end;
}

class QueryResultEntry {
  QueryResultEntry(this.searchResultNum, this.title, this.author, this.year, this.avgRating, this.numReviews,
      this.genre, this.genreRanking, this.imageURL, this.reviews);
  int searchResultNum;
  String title;
  String author;
  int year;
  double avgRating;
  int numReviews;
  String genre;
  int genreRanking;
  String imageURL;
  List<ReviewResult> reviews;
}
