// Testing the functionality of the admin login, which shows editing events,
// adding events and announcements modifications if logged in

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goldstein_app/pages/main.dart';

// Pull out left drawer
Future<void> openLeftMenu(WidgetTester tester) async {
  await tester.tap(find.byType(IconButton));
  await tester.pump();
}

void main() {
  testWidgets('Test admin login works', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await openLeftMenu(tester);

    // Expect to find the "Login" tab in the left menu
    expect(find.text("Login"), findsOneWidget);
    await tester.tap(find.text("Login"));

    // Expect to find the enter button when the login appears
    expect(find.byIcon(Icons.lock), findsOneWidget);
  });
}
