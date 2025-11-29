import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/pages/main_page.dart';
import 'package:free_note/providers/events_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CalendarDayPage extends StatefulWidget {
  final DateTime date;
  const CalendarDayPage({super.key, required this.date});

  @override
  State<CalendarDayPage> createState() => _CalendarDayPageState();
}

class _CalendarDayPageState extends State<CalendarDayPage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventsProvider>();

    return MainPage(
      currentLocation: '/calendar',
      child: DayView(
        controller: provider.controller,
        initialDay: widget.date,
        backgroundColor: Theme.of(context).primaryColor,
        headerStyle: HeaderStyle(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: BoxBorder.fromLTRB(bottom: BorderSide(color: Colors.white)),
          ),
        ),
        onEventTap: (events, date) {
          if (events.isEmpty) {
            return;
          }

          final eventData = events.first;
          final event = eventData.event;

          if (event == null) {
            logger.e('No event attached to EventData');
          }
          context.push('/event/${event!.id}', extra: event);
        },
      ),
    );
  }
}
