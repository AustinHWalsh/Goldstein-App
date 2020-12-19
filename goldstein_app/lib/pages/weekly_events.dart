import 'package:flutter/material.dart';
import 'package:goldstein_app/ui/leftmenu.dart';
import 'package:goldstein_app/events/event.dart';
import 'package:goldstein_app/pages/view_event.dart';
import 'package:goldstein_app/events/event_firestore_service.dart';
import 'package:goldstein_app/events/event_helpers.dart';
import 'package:intl/intl.dart';
import 'package:goldstein_app/assets/constants.dart' as Constants;

class WeeklyEvent extends StatefulWidget {
  @override
  _WeeklyEventState createState() => _WeeklyEventState();
}

class _WeeklyEventState extends State<WeeklyEvent> {
  // set the initial page value
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  DateTime selectedDate;
  DateTime startDate;
  DateTime endDate;
  Map<String, Widget> widgets = Map();
  DateTime _openDay;
  DateFormat dateFormat = DateFormat("EEE, dd MMM yyyy");
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _events = {};
    _selectedEvents = [];
    selectedDate = DateTime.now();
    startDate =
        selectedDate.subtract(Duration(days: Constants.NUM_DAY_IN_YEAR));
    endDate = selectedDate.add(Duration(days: Constants.NUM_DAY_IN_YEAR));
    _openDay =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    _pageController = PageController(initialPage: weekFromDay(_openDay));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calendar"),
        ),
        drawer: LeftMenu(),
        body: _weekView());
  }

  // Widget containing the pageview of the scrollable weeks
  // Can only scroll upto a year both sides
  Widget _weekView() {
    return PageView.builder(
      controller: _pageController,
      itemBuilder: (context, index) {
        return _createWeekPage();
      },
      onPageChanged: (index) {
        if (index < _pageController.page) {
          _openDay = _openDay.subtract(Duration(days: DateTime.daysPerWeek));
        } else {
          _openDay = _openDay.add(Duration(days: DateTime.daysPerWeek));
        }
        setState(() {});
      },
      itemCount: Constants.TWO_YEARS,
    );
  }

  // Create the page of each week
  Widget _createWeekPage() {
    return Scaffold(
        body: ListTile(
      title: Container(
        color: Colors.red,
        child: Row(
          children: <Widget>[
            Text(
              weekString(_openDay),
              style: TextStyle(color: Colors.white),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      subtitle: _dailyEvents(),
      contentPadding: EdgeInsets.zero,
    ));
  }

  // Generate each day of the week as a header and use that for each list item
  Widget _dailyEvents() {
    DateTime weekMon =
        _openDay.subtract(Duration(days: _openDay.weekday - DateTime.monday));
    return ListView(
      children: <Widget>[
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              child: ListTile(
                title: Text("${dateFormat.format(weekMon)}"),
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.black)),
            ),
            _generateListItems(weekMon)
          ],
        ),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              child: ListTile(
                title: Text(
                    "${dateFormat.format(weekMon.add(Duration(days: DateTime.monday)))}"),
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.black)),
            ),
            _generateListItems(weekMon.add(Duration(days: DateTime.monday)))
          ],
        ),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              child: ListTile(
                title: Text(
                    "${dateFormat.format(weekMon.add(Duration(days: DateTime.tuesday)))}"),
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.black)),
            ),
            _generateListItems(weekMon.add(Duration(days: DateTime.tuesday)))
          ],
        ),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              child: ListTile(
                title: Text(
                    "${dateFormat.format(weekMon.add(Duration(days: DateTime.wednesday)))}"),
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.black)),
            ),
            _generateListItems(weekMon.add(Duration(days: DateTime.wednesday)))
          ],
        ),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              child: ListTile(
                title: Text(
                    "${dateFormat.format(weekMon.add(Duration(days: DateTime.thursday)))}"),
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.black)),
            ),
            _generateListItems(weekMon.add(Duration(days: DateTime.thursday)))
          ],
        ),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              child: ListTile(
                title: Text(
                    "${dateFormat.format(weekMon.add(Duration(days: DateTime.friday)))}"),
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.black)),
            ),
            _generateListItems(weekMon.add(Duration(days: DateTime.friday)))
          ],
        ),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              child: ListTile(
                title: Text(
                    "${dateFormat.format(weekMon.add(Duration(days: DateTime.saturday)))}"),
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.black)),
            ),
            _generateListItems(weekMon.add(Duration(days: DateTime.saturday)))
          ],
        ),
      ],
    );
  }

  // Create the list of items from the firestore database
  Widget _generateListItems(DateTime date) {
    return StreamBuilder<List<EventModel>>(
        stream: eventDBS.streamList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<EventModel> allEvents = snapshot.data;
            if (allEvents.isNotEmpty) {
              _events = EventHelpers().groupEvents(allEvents);
              var dayEvents = _events[
                  date.subtract(Duration(hours: _openDay.hour)).toLocal()];
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
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
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
      shrinkWrap: true,
      physics: ScrollPhysics(),
    );
  }

  // Generate the current week in the year from a day
  int weekFromDay(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / DateTime.daysPerWeek).floor();
  }

  // Generate the string containing the current week
  // i.e. Monday, dd MMM yyyy - Sunday, dd MMM yyyy
  String weekString(DateTime date) {
    DateTime weekMon =
        date.subtract(Duration(days: date.weekday - DateTime.monday));
    DateTime weekSun = date.add(Duration(days: DateTime.sunday - date.weekday));

    return "${dateFormat.format(weekMon)}\n${dateFormat.format(weekSun)}";
  }
}
