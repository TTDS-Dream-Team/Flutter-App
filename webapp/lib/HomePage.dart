import 'package:flutter/material.dart';

import 'Utils.dart';
import 'custom_dropdown.dart';
import 'main.dart';

class SearchSortDropdown extends StatefulWidget {
  SearchSortDropdown(this.controller);
  PageContrContr controller;

  @override
  _SearchSortDropdownState createState() => _SearchSortDropdownState();
}

class _SearchSortDropdownState extends State<SearchSortDropdown> {
  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
        borderRadius: 5.0,
        valueIndex: widget.controller.sort,
        hint: "Hint",
        items: [
          CustomDropdownItem(text: "Relevance"),
          CustomDropdownItem(text: "Popularity"),
          CustomDropdownItem(text: "Rating (Asc)"),
          CustomDropdownItem(text: "Rating (Desc)"),
        ],
        onChanged: (newValue) {
          setState(() {
            widget.controller.sort = newValue;
            widget.controller.reSearch();
          });
        });
  }
}

class Searchbar extends StatelessWidget {
  Searchbar(this.onSubmitted, this.txt);
  Function(String) onSubmitted;
  TextEditingController txt;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted,
      controller: txt,
      textInputAction: TextInputAction.search,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(fontSize: 22.0, color: textColor),
      decoration: InputDecoration(
        hintText: 'Search by review...',
        hintStyle: TextStyle(fontSize: 22.0, color: textColor),
        prefixIcon: Icon(Icons.search, color: textFadedColor),
        fillColor: offWhite,
        border: InputBorder.none,
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.only(left: 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: offWhite),
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: offWhite),
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
        filled: true,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage(this.controller);
  PageContrContr controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Logo(
              color: primaryColor,
            ),
          ],
        ),
        SizedBox(height: 50),
        FractionallySizedBox(
            widthFactor: 0.5,
            child: Searchbar((String string) {
              controller.search(string);
            }, controller.txt)),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Search for books by how people reviewed them. For example '",
              style: Theme.of(context).textTheme.headline6.copyWith(color: offWhite, fontSize: 18),
            ),
            TextButton(
              onPressed: () {
                controller.search("a waste of time");
              },
              child: Text(
                "a waste of time",
                style: Theme.of(context).textTheme.headline6.copyWith(color: primaryColorLight, fontSize: 18),
              ),
            ),
            Text(
              "' or '",
              style: Theme.of(context).textTheme.headline6.copyWith(color: offWhite, fontSize: 18),
            ),
            TextButton(
              onPressed: () {
                controller.search("extremely good");
              },
              child: Text(
                "extremely good",
                style: Theme.of(context).textTheme.headline6.copyWith(color: primaryColorLight, fontSize: 18),
              ),
            ),
            Text(
              "'",
              style: Theme.of(context).textTheme.headline6.copyWith(color: offWhite, fontSize: 18),
            ),
          ],
        )
      ],
    );
  }
}

class HomepageButton extends StatelessWidget {
  HomepageButton(this.controller, this.child);
  PageContrContr controller;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: 250,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius), side: BorderSide(width: 0)),
        onPressed: () {
          controller.search("Not Implemented");
        },
        color: offWhite,
        hoverColor: Colors.grey[100],
        splashColor: Colors.grey[200],
        padding: EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
