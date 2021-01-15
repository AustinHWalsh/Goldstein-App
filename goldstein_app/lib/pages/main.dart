import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goldstein_app/pages/weekly_events.dart';
import 'package:goldstein_app/ui/leftmenu.dart';
import 'package:goldstein_app/pages/add_event.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homepage(),
      drawer: LeftMenu(),
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
            padding: EdgeInsets.all(5),
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
            padding: EdgeInsets.all(5),
            child: Container(
              height: (MediaQuery.of(context).size.height / 3),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    title: Text("Test"),
                  ),
                  ListTile(
                    title: Text("Test"),
                  ),
                  ListTile(
                    title: Text("Test"),
                  ),
                  ListTile(
                    title: Text("Test"),
                  ),
                  ListTile(
                    title: Text("Test"),
                  ),
                ],
              ),
            ),
          )
        ])),
        navigatorButtons(),
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
        text = Text("Website");
        pressed = () {};
        break;
      case 1:
        text = Text("Facebook");
        pressed = () async {
          const url = "https://www.facebook.com/groups/121650729274806/";
          if (await canLaunch(url))
            await launch(url);
          else
            throw "Could not launch $url";
        };
        break;
      case 2:
        text = Text("Dino");
        pressed = () {};
        break;
      case 3:
        text = Text("Calendar");
        pressed = () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => WeeklyEvent()));
        };
        break;
      default:
        throw ("5 boxes elements created");
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
}
