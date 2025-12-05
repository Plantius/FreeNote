import 'dart:math' show Random;
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:free_note/models/calendar.dart';

class Event {
  final int id;
  final int calendarId;
  final String title;
  final DateTime start;
  final DateTime end;
  int noteId;

  Event({
    required this.id,
    required this.calendarId,
    required this.title,
    required this.start,
    required this.end,
    required this.noteId,
  });

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
      noteId: 0, // FIXME: TODO FETCH ME
    );
  }

  @override
  String toString() {
    return 'Event(#$id, "$title" at $start to $end => Note #$noteId)';
  }
}
