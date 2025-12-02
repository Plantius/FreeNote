import 'dart:math' show Random;
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/models/calendar.dart';

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

  factory Event.random(List<Calendar> calendars) {
    final rand = Random();

    final now = DateTime.now();

    final start = DateTime(
      now.year,
      now.month,
      now.day - rand.nextInt(7),
      8 + rand.nextInt(10),
    );

    final end = start.add(Duration(minutes: 120));

    final event = Event(
      id: 0,
      calendarId: calendars[rand.nextInt(calendars.length)].id,
      title: 'Event Title',
      start: start,
      end: end,
    );

    return event;
  }

  CalendarEventData<Event> toCalendarEvent(Calendar calendar) {
    final color = Color(calendar.color);

    return CalendarEventData<Event>(
      date: start,
      startTime: start,
      endTime: end,
      title: title,
      description: null, // Do not use description: instead use Notes.
      event: this,
      color: color,
      titleStyle: TextStyle(color: Colors.white, fontSize: 14),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      calendarId: json['calendar_id'] as int,
      title: json['title'] as String,
      start: DateTime.parse(json['starts_at'] as String),
      end: DateTime.parse(json['ends_at'] as String),
    );
  }

  @override
  String toString() {
    return 'Event(#$id, "$title" at $start to $end)';
  }
}
