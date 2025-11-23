import 'package:flutter/material.dart';
import 'package:free_note/models/event.dart';
import 'package:free_note/services/database_service.dart';
import 'dart:math' show Random;

class EventsProvider extends ChangeNotifier {
  final DatabaseService database;

  final _events = <Event>[];
  final _enabledCalendars = <int>{ 0, };

  EventsProvider(this.database);

  List<Event> get visibleEvents {
    return _events
      .where((event) => _enabledCalendars.contains(event.calendarId))
      .toList();
  }

  void addRandomEvent() {
    final rand = Random();

    final now = DateTime.now();
    
    final start = DateTime(
      now.year,
      now.month,
      now.day + rand.nextInt(60) - 30,
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
    notifyListeners();
  }
}
