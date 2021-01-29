import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'constants.dart';

SentryClient errorReporter = SentryClient(SentryOptions(dsn: DSN));

class PopupError {
  // Create a popup with the error
  showErrorPop(context) {
    Alert(
      context: context,
      type: AlertType.error,
      style: AlertStyle(isCloseButton: false, isOverlayTapDismiss: false),
      title: "Error Encountered",
      desc:
          "An error was encountered, an error message has already been logged\nThe app will exit now",
      buttons: [DialogButton(child: Text("Ok"), onPressed: () => exit(1))],
    ).show();
  }
}
