import 'package:flutter/material.dart';

import 'main.dart';

var text1 =
    "Lorem ipsum blew my socks off. Lorem ipsum dolor sit amet, consectetur adipiscing elit. In non sapien nulla. Curabitur facilisis placerat lacus, vel porttitor mi molestie id. Donec dignissim condimentum leo, at varius nisl malesuada et. Sed ligula ante, rhoncus eu tristique sed, viverra vitae urna. Nullam nec commodo nunc, vitae hendrerit urna. Pellentesque id ullamcorper nibh. Nulla at urna in nunc cursus elementum.";

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
    children: stars,
  );
}

List<QueryResultEntry> getQueries() {
  List<QueryResultEntry> basis = [
    QueryResultEntry(
        1, "The Thursday Murder Club", "Richard Osman", 2020, 4.68, 24000, "Detective", 1, "ThursdayMurderClub.jpeg"),
    QueryResultEntry(1, "Harry Potter and the Chamber of Secrets", "J.K. Rowling", 1998, 4.43, 2843096, "Fantasy", 4,
        "ChamberOfSecrets.jpeg")
  ];
  List<QueryResultEntry> toRet = [];
  for (int i = 0; i < 10; i++) {
    toRet.add(basis[0]);
    toRet.add(basis[1]);
  }
  return toRet;
}

class QueryResultEntry {
  QueryResultEntry(this.searchResultNum, this.title, this.author, this.year, this.avgRating, this.numReviews,
      this.genre, this.genreRanking, this.imageString);
  int searchResultNum;
  String title;
  String author;
  int year;
  double avgRating;
  int numReviews;
  String genre;
  int genreRanking;
  String imageString;
}
