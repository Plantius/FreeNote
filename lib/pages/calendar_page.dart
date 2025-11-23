import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/models/event.dart';
import 'package:free_note/providers/events_provider.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  void _rebuildCalendar(List<Event> events) {
    final controller = CalendarControllerProvider.of(context).controller;
    controller.removeWhere((element) => true);
    controller.addAll(
      events.map((e) => e.toCalendarEvent()
    ).toList());
  }

  @override
  Widget build(BuildContext context) {
    final eventsProvider = context.watch<EventsProvider>();
    _rebuildCalendar(eventsProvider.visibleEvents);

    return Scaffold(
      body: MonthView(
        cellBuilder: _cellBuilder,
        weekDayBuilder: _weekdayBuilder,
        useAvailableVerticalSpace: true,
        onCellTap: (events, date) {
          eventsProvider.addRandomEvent();
        },
        headerStyle: HeaderStyle(
          leftIconConfig: IconDataConfig(
            color: Colors.white,
          ),
          rightIconConfig: IconDataConfig(
            color: Colors.white,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          )
        ),
      ),
    );
  }

  Widget _cellBuilder<T>(
    dynamic date,
    List<CalendarEventData<T>> events,
    isToday,
    isInMonth,
    hideDaysNotInMonth,
  ) {
    Color titleColor = isInMonth ? Colors.white : Theme.of(context).colorScheme.primary;

    return FilledCell<T>(
      date: date,
      shouldHighlight: isToday,
      backgroundColor: Theme.of(context).primaryColor,
      events: events,
      isInMonth: isInMonth,
      onTileTap: null,
      onTileDoubleTap: null,
      onTileLongTap: null,
      dateStringBuilder: null,
      hideDaysNotInMonth: hideDaysNotInMonth,
      titleColor: titleColor,
      highlightedTitleColor: titleColor,
    );
  }

  Widget _weekdayBuilder(int index) {
    return WeekDayTile(
      dayIndex: index,
      weekDayStringBuilder: null,
      displayBorder: true,
      backgroundColor: Theme.of(context).primaryColor,
      textStyle: TextStyle(
        color: Colors.white,
      ),
    );
  }
}
