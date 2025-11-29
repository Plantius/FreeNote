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
    Calendar(id: 1, name: 'Work', visible: true, color: 0xFFFF00FF),
    Calendar(id: 2, name: 'Private', visible: false, color: 0xFFFF0000),
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

  Event? getEvent(int id) {
    Event? event = _events
      .where((event) => event.id == id)
      .singleOrNull;

    if (event == null) {
      logger.e('Could not find Event #$id');
    }

    return event;
  }

  Calendar? getCalendar(int id) {
    Calendar? calendar =_calendars
      .where((calendar) => calendar.id == id)
      .singleOrNull;

    if (calendar == null) {
      logger.e('Could not find Calendar #$id');
    }

    return calendar;
  }

  void addCalendar(Calendar calendar) async {
    logger.i('Adding Calendar: $calendar');
    
    Calendar? createdCalendar = await database.createCalendar(calendar);

    if (createdCalendar != null) {
      _calendars.add(createdCalendar);
    }

    notifyListeners();
  }

  void updateCalendarVisibility(Calendar calendar, bool visible) {
    if (calendar.visible == visible) {
      return;
    }

    calendar.visible = visible;
    _repopulateCalendar(); // TODO: More granular repopulation

    logger.i('Updated to $calendar');

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
