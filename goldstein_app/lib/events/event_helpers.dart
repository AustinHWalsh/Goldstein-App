import 'package:goldstein_app/events/event.dart';

class EventHelpers {
  // Groups the persistent events so they can be displayed
  Map<DateTime, List<dynamic>> groupEvents(List<EventModel> allEvents) {
    Map<DateTime, List<dynamic>> data = {};
    allEvents.forEach((event) {
      DateTime date = DateTime(
              event.eventDate.year, event.eventDate.month, event.eventDate.day)
          .toLocal();
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

  // Compare a datetime to the current day excluding seconds/milliseconds
  bool compareDate(DateTime date) {
    DateTime now = DateTime.now();
    return (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year);
  }
}
