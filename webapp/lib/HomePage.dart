import 'package:flutter/material.dart';

import 'Utils.dart';
import 'custom_dropdown.dart';
import 'main.dart';

class SearchSortDropdown extends StatefulWidget {
  @override
  _SearchSortDropdownState createState() => _SearchSortDropdownState();
}

class _SearchSortDropdownState extends State<SearchSortDropdown> {
  int _checkboxValue = 0;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      borderRadius: 5.0,
      valueIndex: _checkboxValue,
      hint: "Hint",
      items: [
        CustomDropdownItem(text: "Popularity"),
        CustomDropdownItem(text: "Rating (Asc)"),
        CustomDropdownItem(text: "Rating (Desc)"),
      ],
      onChanged: (newValue) {
        setState(() => _checkboxValue = newValue);
      },
    );
  }
}

class Searchbar extends StatelessWidget {
  Searchbar(this.onSubmitted);
  Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(fontSize: 22.0, color: textColor),
      decoration: InputDecoration(
        hintText: 'Search by review...',
        hintStyle: TextStyle(fontSize: 22.0, color: textColor),
        prefixIcon: Icon(Icons.search, color: textFadedColor),
        fillColor: Colors.white,
        border: InputBorder.none,
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.only(left: 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
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
            Logo(),
          ],
        ),
        SizedBox(height: 50),
        FractionallySizedBox(
            widthFactor: 0.5,
            child: Searchbar((String string) {
              controller.goToPage(1);
            })),
        SizedBox(height: 50),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomepageButton(
                controller,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: starWidget(5)),
                    Text(
                      "View highest rated all time",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                )),
            SizedBox(width: 50),
            HomepageButton(
                controller,
                Text(
                  "Find popular phrases by genre",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                )),
            SizedBox(width: 50),
            HomepageButton(
                controller,
                Text(
                  "Any other features we might want to add",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ))
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
          controller.goToPage(1);
        },
        color: Colors.white,
        hoverColor: Colors.grey[100],
        splashColor: Colors.grey[200],
        padding: EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
