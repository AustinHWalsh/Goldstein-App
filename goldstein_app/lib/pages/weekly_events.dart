import 'package:flutter/material.dart';
import 'package:scrolling_day_calendar/scrolling_day_calendar.dart';
import 'package:goldstein_app/ui/leftmenu.dart';
import 'package:goldstein_app/events/event.dart';
import 'package:goldstein_app/pages/view_event.dart';
import 'package:goldstein_app/events/event_firestore_service.dart';
import 'package:goldstein_app/events/event_helpers.dart';

class WeeklyEvent extends StatefulWidget {
  @override
  _WeeklyEventState createState() => _WeeklyEventState();
}

class _WeeklyEventState extends State<WeeklyEvent> {
  // set the initial page value
  Map<DateTime, List<dynamic>> _events;
  Widget pageItems;
  DateTime selectedDate;
  DateTime startDate;
  DateTime endDate;
  Map<String, Widget> widgets = Map();
  String widgetKeyFormat = "yyyy-MM-dd";

  @override
  void initState() {
    super.initState();
    _events = {};
    selectedDate = DateTime.now();
    startDate = selectedDate.subtract(Duration(days: 10));
    endDate = selectedDate.add(Duration(days: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calendar"),
        ),
        drawer: LeftMenu(),
        body: dailyView());
  }

  // View of the scrolling day calendar
  Widget dailyView() {
    return ScrollingDayCalendar(
      startDate: startDate,
      endDate: endDate,
      selectedDate: selectedDate,
      onDateChange: (direction, DateTime selectedDate) {
        setState(() {
          pageItems = ListView(
            children: [
              ListTile(
                title: Text("Test"),
                onTap: () => {print("Pressed")},
              ),
              ListTile(
                title: Text("Test2"),
                onTap: () => {print("Second")},
              )
            ],
          );
        });
      },
      dateStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayDateFormat: "dd, MMM yyyy",
      dateBackgroundColor: Colors.red,
      forwardIcon: Icons.arrow_forward,
      backwardIcon: Icons.arrow_back,
      pageChangeDuration: Duration(
        milliseconds: 100,
      ),
      pageItems: pageItems,
      widgets: widgets,
      widgetKeyFormat: widgetKeyFormat,
      noItemsWidget: Center(
        child: Text("No events"),
      ),
    );
  }

  Widget generatePageItems() {
    return StreamBuilder<List<EventModel>>(
        stream: eventDBS.streamList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<EventModel> allEvents = snapshot.data;
            if (allEvents.isNotEmpty) {
              _events = EventHelpers().groupEvents(allEvents);
            }
          }
        });
  }
}
