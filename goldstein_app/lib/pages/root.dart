import 'package:flutter/material.dart';
import 'package:goldstein_app/assets/password.dart';

class MyRoot extends StatefulWidget {
  @override
  _MyRootState createState() => _MyRootState();
}

class _MyRootState extends State<MyRoot> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _hasher = PasswordHash();

  @override
  Widget build(BuildContext context) {
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
            TextButton(
              onPressed: () {},
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
