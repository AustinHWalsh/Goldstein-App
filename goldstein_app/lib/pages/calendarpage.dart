import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:goldstein_app/ui/menu_open.dart' show MenuOpen;
import 'package:goldstein_app/events/event.dart';
import 'package:goldstein_app/events/event_firestore_service.dart';
import 'package:goldstein_app/pages/view_event.dart';
import 'package:goldstein_app/ui/leftmenu.dart';

// Calendar Page that holds the calendar and all events located then
class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  CalendarController _controller;
  DateTime _openDay;

  // Initialise variables and events
  @override
  void initState() {
    super.initState();
    _events = {};
    _selectedEvents = [];
    _controller = CalendarController();
    _openDay = DateTime.utc(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 12);
  }

  // Groups the persistent events so they can be displayed
  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> allEvents) {
    Map<DateTime, List<dynamic>> data = {};
    allEvents.forEach((event) {
      DateTime date = DateTime(event.eventDate.year, event.eventDate.month,
              event.eventDate.day, 12)
          .toUtc();
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

  // Build the calendar page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
      ),
      body: StreamBuilder<List<EventModel>>(
          stream: eventDBS.streamList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<EventModel> allEvents = snapshot.data;
              if (allEvents.isNotEmpty) {
                _events = _groupEvents(allEvents);
                if (MenuOpen.menuCalendar) {
                  var dayEvents =
                      _events[_openDay.subtract(Duration(hours: 11)).toUtc()];
                  _selectedEvents = dayEvents == null ? [] : dayEvents;
                  MenuOpen.menuCalendar = false;
                }
              } else {
                _events = {};
                _selectedEvents = [];
              }
            }
            return _openCalendar();
          }),
      drawer: LeftMenu(),
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
          const SizedBox(height: 16.0),
          Expanded(child: _buildEventList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.pushNamed(context, 'add_event');
          // show events after add_event page disappears
          setState(() {
            var dayEvents =
                _events[_controller.selectedDay.subtract(Duration(hours: 11))];
            _selectedEvents = dayEvents == null ? [] : dayEvents;
          });
        },
      ),
    );
  }

  // Builds the calendar, used to change the style of the calendar
  // At any time
  Widget _buildCalendar() {
    return TableCalendar(
      events: _events,
      calendarController: _controller,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableCalendarFormats: const {CalendarFormat.month: "Month"},
      calendarStyle:
          CalendarStyle(outsideDaysVisible: false, markersColor: Colors.blue),
      headerStyle:
          HeaderStyle(centerHeaderTitle: true, formatButtonVisible: false),
      onDaySelected: (date, events) {
        setState(() {
          _selectedEvents = events;
        });
      },
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
