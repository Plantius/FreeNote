import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/models/event.dart';
import 'package:free_note/providers/events_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CalendarMonthPage extends StatefulWidget {
  const CalendarMonthPage({super.key});

  @override
  State<CalendarMonthPage> createState() => _CalendarMonthPageState();
}

class _CalendarMonthPageState extends State<CalendarMonthPage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventsProvider>();

    return Scaffold(
      body: MonthView(
        controller: provider.controller,
        cellBuilder: _cellBuilder,
        weekDayBuilder: _weekdayBuilder,
        useAvailableVerticalSpace: true,
        onCellTap: (events, date) {
          context.push('/calendar/day', extra: date);
        },
        headerStyle: HeaderStyle(
          leftIconConfig: IconDataConfig(color: Colors.white),
          rightIconConfig: IconDataConfig(color: Colors.white),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
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
    Color titleColor = isInMonth
        ? Colors.white
        : Theme.of(context).colorScheme.primary;

    return FilledCell<T>(
      date: date,
      shouldHighlight: isToday,
      backgroundColor: Theme.of(context).primaryColor,
      events: events,
      isInMonth: isInMonth,
      onTileTap: _onEventTap,
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
      textStyle: TextStyle(color: Colors.white),
    );
  }

  void _onEventTap<T>(CalendarEventData<T> eventData, DateTime date) {
    final event = eventData.event as Event?;
    if (event == null) {
      logger.e('No event attached to EventData');
    }
    logger.i('Clicked event "${event!.title}"');
    context.push('/event/${event.id}', extra: event);
  }
}
