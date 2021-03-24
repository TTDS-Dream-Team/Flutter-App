import 'dart:convert';

import 'package:flutter/material.dart';

import 'main.dart';

class Logo extends StatelessWidget {
  Logo({this.fontSize = 120.0, this.color});
  double fontSize;
  Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      'BetterReads',
      style: Theme.of(context).textTheme.headline1.copyWith(fontSize: fontSize, color: color ?? offWhite),
    );
  }
}

Widget starWidget(double rating, Color colour) {
  List<Widget> stars = [];
  for (int i = 0; i < 5; i++) {
    stars.add(Icon(
        rating <= i + 0.25
            ? Icons.star_border
            : (rating < i + 0.75 && rating > i + 0.25 ? Icons.star_half : Icons.star),
        color: colour));
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: stars,
  );
}

List<QueryResultEntry> getQueries(String response, PageContrContr controller) {
  Map<String, dynamic> responses = jsonDecode(response);
  List<QueryResultEntry> toRet = [];
  for (var r in responses.keys.toList()) {
    if (r == "sentiment") {
      controller.sentiment = responses[r][0];
      controller.confidence = responses[r][1];
      continue;
    }
    if (r == "timings") {
      controller.totalTime = responses[r]["total"];
      continue;
    }
    try {
      var res = responses[r];
      String yearPublished = res["publication_year"];
      if (yearPublished.length != 0) yearPublished = yearPublished + ", ";
      List<ReviewResult> reviews = [];
      String text = res["review_text"];
      String relevantText = res["relevant_text"];
      reviews.add(ReviewResult(text, relevantText, text.indexOf(relevantText),
          text.indexOf(relevantText) + relevantText.length, res["rating"]));
      toRet.add(QueryResultEntry(
        int.parse(r) + 1,
        res["title"],
        (res["authors"] ?? ["No author"])[0],
        yearPublished,
        res["average_rating"],
        int.parse(res["text_reviews_count"]),
        "No Genre",
        1,
        res["image_url"],
        res["url"],
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
  ReviewResult(this.text, this.foundText, this.start, this.end, this.reviewRating);
  String foundText;
  String text;
  int start;
  int end;
  int reviewRating;
}

class QueryResultEntry {
  QueryResultEntry(this.searchResultNum, this.title, this.author, this.year, this.avgRating, this.numReviews,
      this.genre, this.genreRanking, this.imageURL, this.URL, this.reviews);
  int searchResultNum;
  String title;
  String author;
  String year;
  double avgRating;
  int numReviews;
  String genre;
  int genreRanking;
  String imageURL;
  String URL;
  List<ReviewResult> reviews;
}
