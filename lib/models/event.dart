import 'package:calendar_view/calendar_view.dart';

class Event {
  final int id;
  final int calendarId;
  final String title;
  final DateTime start;
  final DateTime end;

  Event({
    required this.id,
    required this.calendarId,
    required this.title,
    required this.start,
    required this.end,
  });

  CalendarEventData<Event> toCalendarEvent() {
    return CalendarEventData<Event>(
      date: start,
      startTime: start,
      endTime: end,
      title: title,
      description: '<empty description>',
      event: this,
    );
  }
}
