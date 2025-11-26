import 'package:flutter/material.dart';
import 'package:free_note/models/event.dart';
import 'package:free_note/pages/error_page.dart';
import 'package:free_note/providers/events_provider.dart';
import 'package:provider/provider.dart';

class EventViewerPage extends StatefulWidget {
  final Event? event;
  final int eventId;

  const EventViewerPage({super.key, this.event, required this.eventId});

  @override
  State<EventViewerPage> createState() => _EventViewerPageState();
}

class _EventViewerPageState extends State<EventViewerPage> {
  Event? event;

  @override
  void initState() {
    _loadEvent();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadEvent() {
    // TODO: look up event by widget.event.id. Or don't.
    event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    if (event == null) {
      return ErrorPage(error: 'Event is (null)!');
    }

    final provider = context.read<EventsProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(event!.title)),
      body: Column(
        children: [
          Text(event!.start.toIso8601String()),
          Text(event!.end.toIso8601String()),
          Text(
            'In ${provider.getCalendar(event!.calendarId)}'
          ),
        ],
      ),
    );
  }
}
