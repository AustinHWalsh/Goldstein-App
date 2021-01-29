import 'package:flutter/material.dart';
import 'package:goldstein_app/pages/dino.dart';
import 'package:goldstein_app/ui/menu_open.dart' show MenuOpen;
import 'package:goldstein_app/pages/main.dart';
import 'package:goldstein_app/pages/calendarpage.dart';
import 'package:goldstein_app/pages/weekly_events.dart';
import 'package:goldstein_app/pages/login_page.dart';

// Drawer Menu located on left side of screen
class LeftMenu extends StatefulWidget {
  @override
  _LeftMenuState createState() => _LeftMenuState();
}

class _LeftMenuState extends State<LeftMenu> {
  final loginMenu = new LoginMenu();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: menu(context),
    );
  }

  // Holds the values of the menu in a list tile
  Widget menu(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          height: (MediaQuery.of(context).size.height / 6),
          child: UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: new Color(0xFFF44336),
            ),
            accountName: Text(
              "Menu",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            accountEmail: null,
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
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
          leading: Icon(Icons.calendar_today_rounded),
          title: Text("Calendar"),
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => WeeklyEvent()));
          },
        ),
        ListTile(
          leading: Icon(Icons.restaurant_rounded),
          title: Text("Dino"),
          onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => DinoMeals()));
          },
        ),
        Visibility(
          child: ListTile(
            leading: Icon(Icons.event_available),
            title: Text("Events"),
            onTap: () {
              MenuOpen.menuCalendar = true;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => CalendarPage()));
            },
          ),
          visible: MenuOpen.userLogged,
        ),
        Visibility(
          child: Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                leading: Icon(Icons.login_rounded),
                title: Text("Login"),
                onTap: () {
                  loginMenu.openPopup(context);
                },
              ),
            ),
          ),
          visible: !MenuOpen.userLogged,
        )
      ],
    );
  }
}
