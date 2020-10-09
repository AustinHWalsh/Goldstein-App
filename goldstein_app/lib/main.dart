import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // Root
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goldstein App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Goldstein College'),
    );
  }
}

// Home Page
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '	\u{1F984}',
              style: TextStyle(fontSize: 100),
            ),
          ],
        ),
      ),
      drawer: LeftMenu(),
    );
  }
}

// Drawer Menu located on left side of screen
class LeftMenu extends StatefulWidget {
  @override
  _LeftMenuState createState() => _LeftMenuState();
}

class _LeftMenuState extends State<LeftMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: menu(context),
    );
  }

  // Holds the values of the menu in a list tile
  Widget menu(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 100.0,
          child: DrawerHeader(
            child: Text(
              "Menu",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              textAlign: TextAlign.left,
            ),
            decoration: BoxDecoration(
              color: Colors.red,
            ),
          ),
        ),
        ListTile(
          title: Text("Home"),
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage(title: 'Goldstein College')));
          },
        ),
        ListTile(
          title: Text("\u{1F4C5} Calendar"),
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => CalendarPage()));
          },
        ),
      ],
    );
  }
}

// Calendar Page that holds the calendar and all events located then
class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List<dynamic>> _events;
  List _selectedEvents;
  CalendarController _controller;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    _events = {
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
    };
    _selectedEvents = _events[_selectedDay] ?? [];
    _controller = CalendarController();
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
}
