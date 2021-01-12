import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:goldstein_app/ui/menu_open.dart' show MenuOpen;

class LoginMenu {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  //final _passwordHash = LoginPassword();
  //final pass = Password.hash("Pass", new PBKDF2());

  // Open the login popup for the user to enter in information
  openPopup(context) {
    Alert(
        context: context,
        title: "Login",
        content: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _password,
                validator: (value) {
                  if (value.isEmpty) return "Please enter a password";
                  //else if (Password.verify(value, pass))
                  //return "Incorrect password";
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
                Navigator.pop(context);
                Navigator.pop(context);
                MenuOpen.menuCalendar = true;
                MenuOpen.userLogged = true;
              }
            },
          )
        ]).show();
  }
}
