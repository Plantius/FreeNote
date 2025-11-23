import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:free_note/models/event.dart';
import 'package:free_note/services/database_service.dart';
import 'dart:math' show Random;

class EventsProvider extends ChangeNotifier {
  final DatabaseService database;
  final EventController<Event> controller = EventController();

  final _events = <Event>[];
  final _visibleCalendars = <int>{ 0, };

  EventsProvider(this.database);

  List<Event> get visibleEvents {
    return _events
      .where((event) => _visibleCalendars.contains(event.calendarId))
      .toList();
  }

  void addRandomEvent() {
    final rand = Random();

    final now = DateTime.now();
    
    final start = DateTime(
      now.year,
      now.month,
      now.day - rand.nextInt(7),
      8 + rand.nextInt(10),
    );

    final end = start.add(Duration(
      minutes: 30,
    ));

    final event = Event(
      id: 0,
      calendarId: 0,
      title: 'Event Title',
      start: start, 
      end: end,
    );

    _events.add(event);

    if (_visibleCalendars.contains(event.calendarId)) {
      controller.add(event.toCalendarEvent());
    }

    notifyListeners();
  }

  // ignore: unused_element
  void _repopulateCalendar() {
    controller.removeWhere((element) => true);

    controller.addAll(
      visibleEvents.map((event) => event.toCalendarEvent()
    ).toList());
  }
}
