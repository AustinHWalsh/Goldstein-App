import 'package:flutter/material.dart';
import 'package:goldstein_app/announcements/announce_firestore_service.dart';
import 'package:goldstein_app/announcements/announcement.dart';

class AddAnnouncePage extends StatefulWidget {
  final AnnouncementModel note;

  const AddAnnouncePage({Key key, this.note}) : super(key: key);

  @override
  _AddAnnouncePageState createState() => _AddAnnouncePageState();
}

class _AddAnnouncePageState extends State<AddAnnouncePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _author;
  TextEditingController _url;
  DateTime _announceDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(
        text: widget.note != null ? widget.note.details : "");
    _author = TextEditingController(
        text: widget.note != null ? widget.note.author : "");
    _announceDate = DateTime.now();
    _url =
        TextEditingController(text: widget.note != null ? widget.note.url : "");
    processing = false;
  }

  // Builds the page to add an event to the calendar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.note != null ? "Edit announcement" : "Add announcement"),
      ),
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: _openAddPage(),
          ),
        ),
      ),
    );
  }

  // Layout of open page to easily be changed
  List<Widget> _openAddPage() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextFormField(
          controller: _title,
          minLines: 3,
          maxLines: 5,
          validator: (value) =>
              (value.isEmpty) ? "Please enter the announcement" : null,
          style: style,
          decoration: InputDecoration(
              labelText: "Announcement",
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextFormField(
          controller: _author,
          validator: (value) =>
              (value.isEmpty) ? "Please enter an author" : null,
          style: style,
          decoration: InputDecoration(
              labelText: "Author",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
      ),
      const SizedBox(height: 10.0),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextFormField(
          controller: _url,
          style: style,
          decoration: InputDecoration(
              labelText: "URL",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
      ),
      const SizedBox(height: 10.0),
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
                      _announceDate = DateTime(
                          _announceDate.year,
                          _announceDate.month,
                          _announceDate.day,
                          _announceDate.hour,
                          _announceDate.minute);
                      final data = {
                        "details": _title.text,
                        "author": _author.text,
                        "date": _announceDate,
                        "url": _url.text,
                      };
                      if (widget.note != null) {
                        await announcementDBS.updateData(widget.note.id, data);
                      } else {
                        await announcementDBS.create(data);
                      }
                      Navigator.pop(context);
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

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    super.dispose();
  }
}
