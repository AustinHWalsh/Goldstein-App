import 'package:flutter/material.dart';

import 'main.dart';
import 'calendarpage.dart';

// Drawer Menu located on left side of screen
class LeftMenu extends StatefulWidget {
  @override
  _LeftMenuState createState() => _LeftMenuState();
}

class _LeftMenuState extends State<LeftMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: menu(context),
    );
  }

  // Holds the values of the menu in a list tile
  Widget menu(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 100.0,
          child: DrawerHeader(
            child: Text(
              "Menu",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              textAlign: TextAlign.left,
            ),
            decoration: BoxDecoration(
              color: Colors.red,
            ),
          ),
        ),
        ListTile(
          title: Text("Home"),
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage(title: 'Goldstein College')));
          },
        ),
        ListTile(
          title: Text("\u{1F4C5} Calendar"),
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => CalendarPage()));
          },
        ),
      ],
    );
  }
}
