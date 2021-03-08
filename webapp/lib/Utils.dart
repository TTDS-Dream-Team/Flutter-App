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
    if (r == "sentiment") continue; // Simple fix
    try {
      var res = responses[r];
      String yearPublished = res["publication_year"];
      if (yearPublished.length != 0) yearPublished = yearPublished + ", ";
      List<ReviewResult> reviews = [];
      String text = res["review_text"];
      String relevantText = res["relevant_text"];
      reviews.add(ReviewResult(
          text, relevantText, text.indexOf(relevantText), text.indexOf(relevantText) + relevantText.length));
      toRet.add(QueryResultEntry(
        int.parse(r) + 1,
        res["title"],
        (res["authors"] ?? ["No author"])[0],
        yearPublished,
        double.parse(res["average_rating"]),
        int.parse(res["text_reviews_count"]),
        "No Genre",
        1,
        res["image_url"],
        reviews,
      ));
    } catch (e) {
      print("Error occurred on response " + r + ": " + responses[r].toString());
      print(e);
    }
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
  String year;
  double avgRating;
  int numReviews;
  String genre;
  int genreRanking;
  String imageURL;
  List<ReviewResult> reviews;
}
