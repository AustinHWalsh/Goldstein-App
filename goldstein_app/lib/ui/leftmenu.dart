import 'package:flutter/material.dart';
import 'package:goldstein_app/ui/menu_open.dart' show MenuOpen;
import 'package:goldstein_app/pages/main.dart';
import 'package:goldstein_app/pages/calendarpage.dart';
import 'package:goldstein_app/pages/weekly_events.dart';

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
        // ListTile(
        //   title: Text("Calendar"),
        //   onTap: () {
        //     MenuOpen.menuCalendar = true;
        //     Navigator.pushReplacement(context,
        //         MaterialPageRoute(builder: (context) => CalendarPage()));
        //   },
        // ),
        ListTile(
          title: Text("Calendar"),
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => WeeklyEvent()));
          },
        )
      ],
    );
  }
}
