import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:goldstein_app/userIDs/userIDs_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goldstein_app/assets/error.dart';
import 'package:goldstein_app/assets/password.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'home.dart';

enum LoggedProperty { loading, noLogin, loggedIn }

class MyRoot extends StatefulWidget {
  @override
  _MyRootState createState() => _MyRootState();
}

class _MyRootState extends State<MyRoot> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _hasher = PasswordHash();
  String _deviceId = "";
  LoggedProperty _loginState = LoggedProperty.loading;

  @override
  void initState() {
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    await _getUniqId();
    await _userLogged();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginState) {
      case LoggedProperty.loading:
        return Container(
          child: Center(child: CircularProgressIndicator()),
          color: Colors.white,
        );
      case LoggedProperty.noLogin:
        return oneTimePage();
      case LoggedProperty.loggedIn:
        WidgetsBinding.instance.addPostFrameCallback((_) =>
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage(title: 'Goldstein College'))));
        return Container(
          child: Center(child: CircularProgressIndicator()),
          color: Colors.white,
        );
      default:
        errorReporter
            .captureMessage("Error occured when logging in $_deviceId");
        return Container(
          child: Center(child: Text("Error, please try re-enter the app")),
          color: Colors.white,
        );
    }
  }

  // A page that displays the password field and an enter button
  // push the user's info to the firebase and save it
  Widget oneTimePage() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(20),
          children: <Widget>[
            Text(
              "One Time Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: MediaQuery.of(context).size.width / 15,
              ),
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _password,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock), labelText: "Password"),
                obscureText: true,
                onSaved: (value) {
                  _password.text = value;
                },
                validator: (value) {
                  if (value.isEmpty)
                    return "Please enter a password";
                  else if (_hasher.verifyPass(false, value))
                    return "Incorrect password";
                  return null;
                },
              ),
            ),
            SizedBox(height: 10),
            DialogButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  idDBS.create({}, id: _deviceId);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomePage(title: 'Goldstein College')));
                }
              },
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Get the uniqId on each start of the app and check if the user is
  // already logged in
  Future<void> _getUniqId() async {
    var deviceInfo = DeviceInfoPlugin();
    var uniqID;
    try {
      if (Platform.isIOS) {
        var iosDeviceInfo = await deviceInfo.iosInfo;
        uniqID = iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        uniqID = androidDeviceInfo.androidId; // unique ID on Android
      }
    } on PlatformException {
      errorReporter.captureMessage("Failed to get device data");
      throw PlatformException;
    }
    setState(() {
      _deviceId = uniqID;
    });
  }

  // Determine if the user's ID exists in the firebase
  // If it does, set _loginState to logged in, otherwise not logged in
  _userLogged() async {
    idDBS.db.collection('userIDs').doc(_deviceId).get().then((doc) {
      setState(() {
        _loginState =
            (doc.exists) ? LoggedProperty.loggedIn : LoggedProperty.noLogin;
      });
    });
  }
}
