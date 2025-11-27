import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/models/calendar.dart';
import 'package:free_note/models/event.dart';
import 'package:free_note/services/database_service.dart';

class EventsProvider extends ChangeNotifier {
  final DatabaseService database;
  final EventController<Event> controller = EventController();

  final _events = <Event>[];
  final _calendars = <Calendar>[
    Calendar(id: 0, name: 'Work', visible: true, color: 0xFFFF00FF),
    Calendar(id: 1, name: 'Private', visible: false, color: 0xFFFF0000),
  ];

  EventsProvider(this.database);

  List<Event> get visibleEvents {
    return _events
      .where(eventIsVisible)
      .toList();
  }

  List<Calendar> get calendars => _calendars;

  void addEvent(Event event) {
    logger.i('Adding event: $event');
    _events.add(event);

    Calendar calendar = getCalendar(event.calendarId)!;
    if (calendar.visible) {
      controller.add(event.toCalendarEvent(calendar));
    }

    notifyListeners();
  }

  bool eventIsVisible(Event event) {
    return _calendars.any(
      (calendar) => event.calendarId == calendar.id && calendar.visible
    );
  }

  Event? getEvent(int id) { // TODO: maybe improve
    return _events
      .where((event) => event.id == id)
      .singleOrNull;
  }

  Calendar? getCalendar(int id) {
    return _calendars
      .where((calendar) => calendar.id == id)
      .singleOrNull;
  }

  void updateCalendarVisibility(Calendar calendar, bool visible) {
    if (calendar.visible == visible) {
      return;
    }

    calendar.visible = visible;
    _repopulateCalendar(); // TODO: More granular repopulation
    notifyListeners();
  }

  // ignore: unused_element
  void _repopulateCalendar() {
    controller.removeWhere((element) => true);

    controller.addAll(
      visibleEvents.map(
        (event) => event.toCalendarEvent(
          getCalendar(event.calendarId)!
        )
      ).toList(),
    );
  }
}
