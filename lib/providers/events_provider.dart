import 'package:flutter/material.dart';
import 'package:free_note/models/event.dart';
import 'package:free_note/services/database_service.dart';

class EventsProvider extends ChangeNotifier {
  final DatabaseService database;

  List<Event> allEvents = [];
  Set<int> enabledCalendars = { 0, };

  EventsProvider(this.database);

  List<Event> get visibleEvents {
    return allEvents
        .where((event) => enabledCalendars.contains(event.calendarId))
        .toList();
  }
}
