import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'HomePage.dart';
import 'SearchResultsPage.dart';

// Testing
void main() {
  runApp(MyApp());
}

Color primaryColor = Color(0xff458ce0);
Color primaryColorLight = Color(0xff6ab1ec);
Color backgroundColor = Color(0xff2f2f3d);
Color textColor = Color(0xFF64748B);
Color textFadedColor = Color(0xFF7484bB);
Color offWhite = Color(0xFFfbfbfb);
double cornerRadius = 25;

final numberStyle = TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, color: textColor, height: 1.1)
    .copyWith(fontSize: 30, fontStyle: FontStyle.normal);
final bookTitleStyle = numberStyle.copyWith(fontSize: 22, fontStyle: FontStyle.normal, color: Colors.black);
final authorStyle = numberStyle.copyWith(fontSize: 17, fontStyle: FontStyle.normal);
final reviewsStyle = numberStyle.copyWith(fontSize: 12, fontStyle: FontStyle.normal);
final genreStyle = numberStyle.copyWith(fontSize: 14, fontStyle: FontStyle.normal, color: Colors.grey[800]);
final boldGenreStyle = genreStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[800]);
final quoteStyle = numberStyle.copyWith(fontSize: 16, fontStyle: FontStyle.normal, color: Colors.grey[800]);
final expandStyle = numberStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor);
final oCcy = NumberFormat("#,##0", "en_US");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      title: 'BetterReads',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,
        accentColor: primaryColor,
        unselectedWidgetColor: Colors.grey[300],
        textTheme: TextTheme(
          headline1: GoogleFonts.patuaOne(color: primaryColor),
          headline6: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, color: textColor),
        ),
      ),
      home: BasePage(),
    );
  }
}

class PageContrContr {
  PageContrContr(this.controller);
  PageController controller;
  String searchString;
  var ratingMin = 0.0;
  var ratingMax = 10.0;
  var yearMin = 1950.0;
  var yearMax = 2021.0;
  var semWeight = 4.0;
  var exactWeight = 10.0;
  var senWeight = 2.0;
  var sentiment = -1.0;
  var confidence = -1.0;
  var sort = 0;
  var txt = TextEditingController();
  var totalTime = 0.0;

  Function() resetSwitch;

  void search(String string) {
    _goToPage(1);
    searchString = string;
    txt.text = string;
    if (resetSwitch != null) resetSwitch();
  }

  void reSearch() {
    _goToPage(1);
    if (resetSwitch != null) resetSwitch();
  }

  void back() {
    _goToPage(0);
  }

  void _goToPage(int page) {
    controller.animateToPage(page, curve: Curves.easeIn, duration: Duration(milliseconds: 300));
  }
}

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final contrcontr = PageContrContr(PageController(initialPage: 0));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This is really stupid but it works and I've spent long enough on it as it is.
      // Essentially, the issue is that the contrcontr.controller can't be added to the AnimatedBuilder
      // until it's been attached to a PageView. Unfortunately, attaching to a PageView involves returning
      // the widget in the build method.
      // This just rebuilds the whole widget tree twice on startup, avoiding the problem by
      // making two passes.
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (contrcontr.controller.hasClients)
            AnimatedBuilder(
                animation: contrcontr.controller,
                builder: (context, widget) {
                  return Image(
                    image: AssetImage('assets/Background.png'),
                    alignment: Alignment(0, contrcontr.controller.page),
                    repeat: ImageRepeat.repeat,
                    fit: BoxFit.cover,
                  );
                }),
          PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: contrcontr.controller,
            scrollDirection: Axis.vertical,
            children: [HomePage(contrcontr), SearchResults(contrcontr)],
          ),
        ],
      ),
    );
  }
}
