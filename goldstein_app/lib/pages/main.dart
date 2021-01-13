import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goldstein_app/pages/weekly_events.dart';
import 'package:goldstein_app/ui/leftmenu.dart';
import 'package:goldstein_app/pages/add_event.dart';

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
        navigatorButtons(),
      ],
    );
  }

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
        text = Text("Calendar");
        pressed = () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => WeeklyEvent()));
        };
        break;
      case 2:
        text = Text("Dino");
        pressed = () {};
        break;
      case 3:
        text = Text("Test");
        pressed = () {};
        break;
      default:
        throw ("5 List elements created");
    }
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 4),
              borderRadius: BorderRadius.circular(12)),
          child: SizedBox.expand(
            child: ElevatedButton(
              child: text,
              onPressed: pressed,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
            ),
          )),
    );
  }
}
