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
  List<dynamic> _selectedEvents;
  Widget pageItems;
  DateTime selectedDate;
  DateTime startDate;
  DateTime endDate;
  Map<String, Widget> widgets = Map();
  String widgetKeyFormat = "yyyy-MM-dd";
  DateTime _openDay;

  @override
  void initState() {
    super.initState();
    _events = {};
    _selectedEvents = [];
    selectedDate = DateTime.now();
    startDate = selectedDate.subtract(Duration(days: 10));
    endDate = selectedDate.add(Duration(days: 10));
    _openDay =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
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
          _openDay =
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
          pageItems = _generatePageItems();
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
      pageItems: _generatePageItems(),
      widgets: widgets,
      widgetKeyFormat: widgetKeyFormat,
      noItemsWidget: Center(
        child: Text("No events"),
      ),
    );
  }

  // Create the page items from the firestore database
  Widget _generatePageItems() {
    return StreamBuilder<List<EventModel>>(
        stream: eventDBS.streamList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<EventModel> allEvents = snapshot.data;
            if (allEvents.isNotEmpty) {
              _events = EventHelpers().groupEvents(allEvents);
              var dayEvents = _events[
                  _openDay.subtract(Duration(hours: _openDay.hour)).toLocal()];
              _selectedEvents = dayEvents == null ? [] : dayEvents;
            } else {
              _events = {};
              _selectedEvents = [];
            }
          }
          return _buildItems();
        });
  }

  // Create the listview to hold the page items
  Widget _buildItems() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.title.toString()),
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EventDetailsPage(
                                  event: event,
                                )))
                  },
                ),
              ))
          .toList(),
    );
  }
}
