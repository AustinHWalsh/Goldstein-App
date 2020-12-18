// Test function to determine if the left menu is working correctly

// Testing opening, accessing pages and closing the menu
// TODO:
// Test login
// Test accessing dino menu

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:goldstein_app/pages/main.dart';
import 'package:scrolling_day_calendar/scrolling_day_calendar.dart';

// Pull out left drawer
Future<void> openLeftMenu(WidgetTester tester) async {
  await tester.tap(find.byType(IconButton));
  await tester.pump();
}

void main() {
  testWidgets('Test open/close menu', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Test if the left menu icon appears on the homepage
    expect(find.byType(IconButton), findsOneWidget);

    // Test if the menu is opened when dragged
    await openLeftMenu(tester);
    expect(find.text("Menu"), findsOneWidget);
    expect(find.text("Home"), findsOneWidget);
  });
  testWidgets('Test opening homepage', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await openLeftMenu(tester);

    // Test opening homepage
    await tester.tap(find.text("Home"));
    expect(find.text("Homepage"), findsOneWidget);

    // Test opening add event TODO: change to login
    await openLeftMenu(tester);
    await tester.tap(find.text("Add Event"));
    expect(find.byType(IconButton), findsWidgets);

    // Test opening calendar/day events
    await openLeftMenu(tester);
    await tester.tap(find.widgetWithText(ListTile, "Calendar"));
    expect(find.widgetWithText(Scaffold, "Calendar"), findsOneWidget);
  });
}
