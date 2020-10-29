import 'package:goldstein_app/events/event.dart';
import 'package:flutter/material.dart';
import 'package:goldstein_app/events/event_firestore_service.dart';
import 'package:goldstein_app/pages/calendarpage.dart';
import 'package:goldstein_app/ui/menu_open.dart' show MenuOpen;

class EditEventPage extends StatefulWidget {
  final EventModel note;

  const EditEventPage({Key key, this.note}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(
        text: widget.note != null ? widget.note.title : "");
    _description = TextEditingController(
        text: widget.note != null ? widget.note.description : "");
    _eventDate = widget.note.eventDate;
    processing = false;
  }

  // Builds the page to edit an event to the calendar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Event"),
      ),
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: _openEditPage(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text("Delete ${widget.note.title}?"),
                    actions: [
                      FlatButton(
                        child: Text("No"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      FlatButton(
                        child: Text("Yes"),
                        onPressed: () async {
                          await eventDBS.removeItem(widget.note.id);
                          MenuOpen.menuCalendar = true;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CalendarPage()));
                        },
                      )
                    ],
                    elevation: 24.0,
                  ));
        },
      ),
    );
  }

  // Layout of open page to easily be changed
  List<Widget> _openEditPage() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextFormField(
          controller: _title,
          validator: (value) => (value.isEmpty) ? "Please enter a title" : null,
          style: style,
          decoration: InputDecoration(
              labelText: "Title",
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextFormField(
          controller: _description,
          minLines: 3,
          maxLines: 5,
          validator: (value) =>
              (value.isEmpty) ? "Please enter a description" : null,
          style: style,
          decoration: InputDecoration(
              labelText: "Description",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
      ),
      const SizedBox(height: 10.0),
      ListTile(
        title: Text("Date (YYYY-MM-DD)"),
        subtitle: Text(
            "${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}"),
        onTap: () async {
          DateTime picked = await showDatePicker(
              context: context,
              initialDate: _eventDate,
              firstDate: DateTime(_eventDate.year),
              lastDate: DateTime(_eventDate.year + 2));
          if (picked != null) {
            setState(() {
              _eventDate = picked;
            });
          }
        },
      ),
      SizedBox(height: 10.0),
      processing
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Theme.of(context).primaryColor,
                child: MaterialButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        processing = true;
                      });
                      if (compareDate(_eventDate))
                        _eventDate = DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day, 12);
                      final data = {
                        "title": _title.text,
                        "description": _description.text,
                        "event_date": _eventDate
                      };
                      if (widget.note != null) {
                        await eventDBS.updateData(widget.note.id, data);
                      }
                      MenuOpen.menuCalendar = true;
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalendarPage()));
                      setState(() {
                        processing = false;
                      });
                    }
                  },
                  child: Text(
                    "Save",
                    style: style.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
    ];
  }

  // Compare a datetime to the current day excluding seconds/milliseconds
  bool compareDate(DateTime date) {
    DateTime now = DateTime.now();
    return (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year);
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}
