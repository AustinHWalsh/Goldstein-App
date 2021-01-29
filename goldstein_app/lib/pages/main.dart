import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goldstein_app/assets/constants.dart';
import 'package:goldstein_app/assets/error.dart';
import 'package:goldstein_app/pages/add_announcement.dart';
import 'package:goldstein_app/ui/menu_open.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goldstein_app/announcements/announce_firestore_service.dart';
import 'package:goldstein_app/announcements/announcement.dart';
import 'package:goldstein_app/pages/weekly_events.dart';
import 'package:goldstein_app/ui/leftmenu.dart';
import 'package:goldstein_app/pages/add_event.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:goldstein_app/ui/misc_popups.dart';

Future<void> main() async {
  await SentryFlutter.init((options) {
    options.dsn = DSN;
  });
  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
    if (kReleaseMode) exit(1);
  };
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Root
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    FirebaseAuth.instance.signInAnonymously().catchError((e) {
      errorReporter.captureException(e);
    });
    return MaterialApp(
      title: 'Goldstein App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Goldstein College'),
      routes: {
        "add_event": (_) => AddEventPage(),
      },
    );
  }
}

// Home Page
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<dynamic> _announcements;
  String formatDate(DateTime date) => new DateFormat("MMMM d").format(date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homepage(),
      drawer: LeftMenu(),
      floatingActionButton: Visibility(
          visible: MenuOpen.userLogged,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              MenuOpen.adding = true;
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddAnnouncePage()));
              MenuOpen.adding = false;
            },
          )),
    );
  }

  Widget homepage() {
    return CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text("Goldstein College"),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
            padding: EdgeInsets.only(top: 5, left: 5, right: 5),
            child: Container(
              child: Text(
                "Announcements",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              height: (MediaQuery.of(context).size.height / 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.8, color: Colors.red),
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(5), bottom: Radius.circular(5)),
              ),
              height: (MediaQuery.of(context).size.height / (2.5)),
              child: createAnnouncements(),
            ),
          )
        ])),
        navigatorButtons(),
        SliverGrid(
          delegate: SliverChildListDelegate.fixed([
            Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 4),
                      borderRadius: BorderRadius.circular(12)),
                  child: SizedBox.expand(
                    child: OutlinedButton(
                      child: Text("Credits"),
                      onPressed: () {
                        CreditPopup().openCreditPop(context);
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white)),
                    ),
                  )),
            ),
          ]),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 12)),
        )
      ],
    );
  }

  // SliverGrid that holds the buttons and their style
  Widget navigatorButtons() {
    return SliverGrid(
        delegate:
            SliverChildListDelegate.fixed(List<Widget>.generate(4, (index) {
          return createButton(index);
        })),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 4),
        ));
  }

  // Function to create a styled button depending on the index passed
  // Also creates the text and on pressed function
  Widget createButton(int index) {
    Widget text;
    Function pressed;
    switch (index) {
      case 0:
        text = ListTile(
          leading: Icon(
            Icons.launch_rounded,
            color: Colors.red,
            size: 35,
          ),
          title: Text(
            "Website",
            style: TextStyle(inherit: false, color: Colors.red),
          ),
        );
        pressed = () {};
        break;
      case 1:
        text = ListTile(
          leading: Image.asset(
            "assets/facebook.png",
            height: 35,
            width: 35,
          ),
          title: Text(
            "Facebook",
            style: TextStyle(inherit: false, color: Colors.red),
          ),
        );
        pressed = () async {
          const url = "https://www.facebook.com/groups/121650729274806/";
          if (await canLaunch(url))
            await launch(url);
          else
            errorReporter.captureMessage("Could not launch $url");
        };
        break;
      case 2:
        text = ListTile(
          leading: Icon(
            Icons.phone,
            color: Colors.red,
            size: 35,
          ),
          title: Text(
            "Contacts",
            style: TextStyle(inherit: false, color: Colors.red),
          ),
        );
        pressed = () {
          ContactPopup().openContactPop(context);
        };
        break;
      case 3:
        text = ListTile(
          leading: Icon(
            Icons.calendar_today_rounded,
            color: Colors.red,
            size: 35,
          ),
          title: Text(
            "Calendar",
            style: TextStyle(inherit: false, color: Colors.red),
          ),
        );
        pressed = () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => WeeklyEvent()));
        };
        break;
      default:
        errorReporter.captureMessage("More than 4 tiles created");
    }
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 4),
              borderRadius: BorderRadius.circular(12)),
          child: SizedBox.expand(
            child: OutlinedButton(
              child: text,
              onPressed: pressed,
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
            ),
          )),
    );
  }

  // Get the snapshot of announcements and create a list if it has data
  Widget createAnnouncements() {
    return StreamBuilder<List<AnnouncementModel>>(
      stream: announcementDBS.streamList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) _announcements = snapshot.data;
        return _createAnnouncementList();
      },
    );
  }

  // Create a list of listtiles containing the contents of each announcement
  Widget _createAnnouncementList() {
    if (_announcements != null && _announcements.isNotEmpty) {
      _announcements.sort((a, b) {
        return b.announcementDate
            .toString()
            .compareTo(a.announcementDate.toString());
      });
      return MediaQuery.removePadding(
        context: context,
        child: ListView(
          shrinkWrap: true,
          children: _announcements
              .map((announcement) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.8),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 2.0),
                    child: ListTile(
                      dense: true,
                      title: Text(announcement.details.toString()),
                      subtitle: Text(((announcement.author.toString()) +
                          " - " +
                          formatDate(announcement.announcementDate))),
                      trailing: Visibility(
                        visible: (announcement.url.toString() != ""),
                        child: Icon(Icons.launch_rounded),
                      ),
                      onTap: () async {
                        String _url = announcement.url.toString();
                        if (_url != "") {
                          if (await canLaunch(_url))
                            await launch(_url);
                          else {
                            await _openInvalidUrl();
                          }
                        }
                      },
                      onLongPress: () async {
                        if (MenuOpen.userLogged) {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddAnnouncePage(
                                  key: widget.key,
                                  note: announcement,
                                ),
                              ));
                        }
                      },
                    ),
                  ))
              .toList(),
        ),
        removeTop: true,
      );
    }
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          child: Text("No Announcements"),
          alignment: Alignment.center,
        )
      ],
    );
  }

  // If the provided url cannot be opened, display a popup to alert the user
  Future<void> _openInvalidUrl() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Url"),
            content: Text(
                "The provided url is invalid, please contact the author of the announcement"),
          );
        });
  }
}
