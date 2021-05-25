import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goldstein_app/assets/constants.dart';
import 'package:goldstein_app/assets/error.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goldstein_app/pages/add_event.dart';
import 'package:goldstein_app/pages/root.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'home.dart';

Future<void> main() async {
  // setup sentry error reporting
  await SentryFlutter.init((options) {
    options.dsn = DSN;
  });
  WidgetsFlutterBinding.ensureInitialized();
  // setup firebase app and flutter error reporting
  await Firebase.initializeApp();
  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
    if (kReleaseMode) exit(1);
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // lock to up and down only
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
      home: MyRoot(),
      routes: {
        "add_event": (_) => AddEventPage(),
      },
    );
  }
}
