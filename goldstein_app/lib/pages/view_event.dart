import 'package:flutter/material.dart';
import 'package:goldstein_app/events/event.dart';
import 'package:goldstein_app/pages/edit_event.dart';
import 'package:goldstein_app/ui/menu_open.dart' show MenuOpen;

class EventDetailsPage extends StatefulWidget {
  final EventModel event;

  const EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  // Create the page to view the event and the button to edit if the user
  // is logged in
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Event details'),
        ),
        body: _eventPage(),
        floatingActionButton: Visibility(
          visible: MenuOpen.userLogged,
          child: FloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditEventPage(
                      key: widget.key,
                      note: widget.event,
                    ),
                  ));
            },
          ),
        ));
  }

  Widget _eventPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.event.title,
          ),
          SizedBox(height: 20.0),
          Text(widget.event.description)
        ],
      ),
    );
  }
}
