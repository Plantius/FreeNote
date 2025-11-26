import 'dart:math' show Random;
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

  factory Event.random() {
    final rand = Random();

    final now = DateTime.now();

    final start = DateTime(
      now.year,
      now.month,
      now.day - rand.nextInt(7),
      8 + rand.nextInt(10),
    );

    final end = start.add(Duration(minutes: 30));

    final event = Event(
      id: 0,
      calendarId: 0,
      title: 'Event Title',
      start: start,
      end: end,
    );

    return event;
  }

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
