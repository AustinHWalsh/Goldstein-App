import 'package:flutter/material.dart';
import 'package:goldstein_app/events/event.dart';
import 'package:goldstein_app/pages/add_event.dart';
import 'package:goldstein_app/ui/menu_open.dart' show MenuOpen;
import 'package:goldstein_app/ui/misc_popups.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsPage extends StatefulWidget {
  final EventModel event;

  const EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  TextStyle headerStyle =
      new TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  TextStyle contentStyle = new TextStyle(
    fontSize: 15,
  );

  // Create the page to view the event and the button to edit if the user
  // is logged in
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event details'),
      ),
      body: _eventPage(),
    );
  }

  Widget _eventPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Event", style: headerStyle),
          SizedBox(height: 10.0),
          Text(widget.event.title, style: contentStyle),
          SizedBox(height: 20.0),
          Text("Details", style: headerStyle),
          SizedBox(height: 10.0),
          Text(widget.event.description),
          SizedBox(height: 20.0),
          Visibility(
            visible: widget.event.url.toString() != '',
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.8),
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              child: ListTile(
                title: Text("Event URL"),
                onTap: () async {
                  String _url = widget.event.url.toString();
                  if (_url != "") {
                    if (await canLaunch(_url))
                      await launch(_url);
                    else {
                      await InvalidURL().openInvalidUrl(context);
                    }
                  }
                },
                trailing: Icon(Icons.launch_rounded),
              ),
            ),
          )
        ],
      ),
    );
  }
}
