import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:free_note/providers/events_provider.dart';
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

    return Scaffold(
      body: DayView(
        controller: provider.controller,
        headerStyle: HeaderStyle(
          leftIconConfig: IconDataConfig(color: Colors.white),
          rightIconConfig: IconDataConfig(color: Colors.white),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        ),
        initialDay: widget.date,
      ),
    );
  }
}
