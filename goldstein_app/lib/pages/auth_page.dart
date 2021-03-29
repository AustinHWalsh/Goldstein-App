import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goldstein_app/pages/login_page.dart';
import 'package:goldstein_app/pages/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Image.asset(
              "assets/UNSW_Goldstein_College_arms.jpg",
              height: 35,
              width: 35,
            ),
            alignment: Alignment.center,
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextFormField(
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              color: Theme.of(context).primaryColor,
              child: DialogButton(
                width: MediaQuery.of(context).size.width / 2,
                onPressed: () {},
                child: Text(
                  "Login",
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0)
                      .copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
