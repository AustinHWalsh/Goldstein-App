import 'package:flutter/material.dart';
import 'package:goldstein_app/assets/error.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

TextStyle _customText = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);

class ContactPopup {
  // Open the popup containing contact information
  openContactPop(context) {
    Alert(
      context: context,
      title: "Contacts",
      content: Column(
        children: <Widget>[
          Text(
            "Duty Tutor: 9385 9786",
            style: _customText,
          ),
          Text(
            "Emergency: 9385 6666",
            style: _customText,
          ),
          Text(
            "UNSW IT: 9385 1333",
            style: _customText,
          ),
          Text(
            "Accommodation: 9385 4346",
            style: _customText,
          ),
        ],
      ),
      buttons: [],
    ).show();
  }
}

class CreditPopup {
  // Open the popoup containing credits
  openCreditPop(context) {
    Alert(
        context: context,
        title: "Credits",
        content: Column(
          children: <Widget>[
            Text(
              "Created by Austin Walsh",
              style: _customText,
            ),
            Text(
              "Idea by Summer Senthil-Kumar",
              style: _customText,
            ),
            Text(
              "With help from 2021 HC",
              style: _customText,
            )
          ],
        ),
        buttons: []).show();
  }
}

// Displays the InvalidURL popup if a url that is attempted to be opened doesnt
// exist
class InvalidURL {
  // If the provided url cannot be opened, display a popup to alert the user
  Future<void> openInvalidUrl(context) async {
    errorReporter.captureMessage("Invalid link provided");
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
