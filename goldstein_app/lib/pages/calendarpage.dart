import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:goldstein_app/leftmenu.dart';

// Calendar Page that holds the calendar and all events located then
class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List<dynamic>> _events;
  List _selectedEvents;
  CalendarController _controller;
  TextEditingController _eventController;
  SharedPreferences prefs;

  // Initialise variables and events
  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    _events = {};
    _selectedEvents = _events[_selectedDay] ?? [];
    _controller = CalendarController();
    _eventController = TextEditingController();
    clearOldEvents();
    initPrefs();
  }

  // Initialise the instance of events
  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      for (String key in prefs.getKeys()) {
        Map<DateTime, dynamic> currMonth =
            decodeMap(json.decode(prefs.getString(key)));
        currMonth.forEach((currKey, value) {
          _events[currKey] = value;
        });
      }
    });
  }

  // Clear preferences that are from a month before the current one
  clearOldEvents() async {
    final _currentYM = int.parse(currentYM(DateTime.now()));
    prefs = await SharedPreferences.getInstance();
    for (String key in prefs.getKeys()) {
      final currentEvent = int.parse(key);
      if (currentEvent < _currentYM) {
        prefs.remove(key);
      }
    }
  }

  // Covert a map of DateTimes to a map of strings and return it
  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  // Covert a map of Strings to a map of DateTimes and return it
  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  // Build the calendar page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calendar"),
        ),
        body: Center(
          child: _openCalendar(),
        ),
        drawer: LeftMenu());
  }

  // Builds the calendar, used to change the style of the calendar
  // At any time
  Widget _buildCalendar() {
    return TableCalendar(
      calendarController: _controller,
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle:
          CalendarStyle(outsideDaysVisible: false, markersColor: Colors.blue),
      headerStyle:
          HeaderStyle(centerHeaderTitle: true, formatButtonVisible: false),
      builders: CalendarBuilders(
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date, events) {
        setState(() {
          _selectedEvents = events;
        });
      },
    );
  }

  // Push the calendar page onto the stack
  // Opens the calendar
  Widget _openCalendar() {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildCalendar(),
          const SizedBox(height: 8.0),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAddDialog,
      ),
    );
  }

  // Builds the events marker placed in the bottom right of the day
  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _controller.isSelected(date)
            ? Colors.red[500]
            : _controller.isToday(date)
                ? Colors.red[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  // Displays the events when a selected on the calendar
  Widget _buildEventList() {
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
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }

  // Creates an event for a specified day by clicking the plus
  _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _eventController,
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                if (_eventController.text.isEmpty) return;
                setState(() {
                  if (_events[_controller.selectedDay] != null) {
                    _events[_controller.selectedDay].add(_eventController.text);
                  } else {
                    _events[_controller.selectedDay] = [_eventController.text];
                  }
                  final _currYM = currentYM(_controller.selectedDay);

                  prefs.setString(_currYM, json.encode(encodeMap(_events)));
                  _eventController.clear();
                  Navigator.pop(context);
                });
              },
              child: Text("Add"))
        ],
      ),
    );
  }

  currentYM(DateTime date) {
    final year = date.year.toString();
    final month = date.month;
    if (month < 10) {
      return (year + "0" + month.toString());
    }
    return year + month.toString();
  }
}
