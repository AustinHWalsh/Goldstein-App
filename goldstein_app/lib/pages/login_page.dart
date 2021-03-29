import 'package:flutter/material.dart';
import 'package:goldstein_app/pages/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:goldstein_app/ui/menu_open.dart' show MenuOpen;
import 'package:goldstein_app/assets/password.dart';

class LoginMenu {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _hasher = PasswordHash();

  // Open the login popup for the user to enter in information
  openPopup(context) {
    Alert(
        context: context,
        title: "HC Login",
        content: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _password,
                validator: (value) {
                  if (value.isEmpty)
                    return "Please enter a password";
                  else if (_hasher.verifyPass(true, value))
                    return "Incorrect password";
                  return null;
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.lock), labelText: "Password"),
                obscureText: true,
                onSaved: (value) {
                  _password.text = value;
                },
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Enter",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                executeHCLogin(context);
              }
            },
          )
        ]).show();
  }

  // when the user is logged in via HC login - allow editing of objects
  void executeHCLogin(context) {
    Navigator.pop(context);
    Navigator.pop(context);
    MenuOpen.menuCalendar = true;
    MenuOpen.userLogged = true;
  }
}
