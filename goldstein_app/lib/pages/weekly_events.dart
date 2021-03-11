import 'package:flutter/material.dart';
import 'package:goldstein_app/pages/add_event.dart';
import 'package:goldstein_app/ui/leftmenu.dart';
import 'package:goldstein_app/events/event.dart';
import 'package:goldstein_app/pages/view_event.dart';
import 'package:goldstein_app/events/event_firestore_service.dart';
import 'package:goldstein_app/events/event_helpers.dart';
import 'package:goldstein_app/ui/menu_open.dart';
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

  // Create the current page of each week
  Widget _createWeekPage() {
    return ListView(
      children: [
        Container(
          color: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Stack(
            children: <Widget>[
              Container(
                child: FlatButton.icon(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                  ),
                  color: Colors.red,
                  onPressed: () {
                    _pageController.previousPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  },
                  label: Text(""),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                alignment: Alignment.centerLeft,
              ),
              Text(
                weekString(_openDay),
                style: TextStyle(color: Colors.white),
              ),
              Container(
                child: FlatButton.icon(
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  ),
                  color: Colors.red,
                  onPressed: () {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  },
                  label: Text(""),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                alignment: Alignment.centerRight,
              ),
            ],
            alignment: FractionalOffset.center,
          ),
          height: MediaQuery.of(context).size.height / 12,
        ),
        _dailyEvents(),
      ],
    );
  }

  // Generate each day of the week as a header and use that for each list item
  Widget _dailyEvents() {
    DateTime weekMon =
        _openDay.subtract(Duration(days: _openDay.weekday - DateTime.monday));
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: List<Widget>.generate(DateTime.sunday, (index) {
        return _weekdayHeader(weekMon.add(Duration(days: index)));
      }),
    );
  }

  // Returns the widget with the weekday as a header for the listview
  Widget _weekdayHeader(DateTime day) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Container(
          child: ListTile(
            title: Text("${dateFormat.format(day)}"),
          ),
          decoration: BoxDecoration(
              color: Colors.grey[300], border: Border.all(color: Colors.black)),
        ),
        _generateListItems(day)
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
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
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
                  onLongPress: () async {
                    if (MenuOpen.userLogged) {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEventPage(
                              key: widget.key,
                              note: event,
                            ),
                          ));
                    }
                  },
                ),
              ))
          .toList(),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  // Generate the current week in the year from a day
  int weekFromDay(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(date.year - 1);
    } else if (woy > numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }

  int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
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
