import 'package:flutter/material.dart';
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
            "Duty Tutor: 9386 9786",
            style: _customText,
          ),
          Text(
            "Not sure what else",
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
              "Idea by Summmer Senthil-Kumar",
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
