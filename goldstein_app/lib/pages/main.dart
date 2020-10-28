import 'package:flutter/material.dart';
//import 'package:intl/date_symbol_data_local.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:goldstein_app/ui/leftmenu.dart';
import 'package:goldstein_app/ui/add_event.dart';
//import 'package:goldstein_app/ui/view_event.dart';
//import 'package:goldstein_app/events/event_firestore_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Root
  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '	\u{1F984}',
              style: TextStyle(fontSize: 100),
            ),
          ],
        ),
      ),
      drawer: LeftMenu(),
    );
  }
}
