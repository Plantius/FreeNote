import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:free_note/models/event.dart';
import 'package:free_note/services/database_service.dart';

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

  void addEvent(Event event) {
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
