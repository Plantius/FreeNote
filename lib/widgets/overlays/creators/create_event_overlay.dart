import 'package:flutter/material.dart';
import 'package:free_note/models/event.dart';
import 'package:free_note/models/calendar.dart';
import 'package:free_note/providers/events_provider.dart';
import 'package:free_note/widgets/overlays/bottom_overlay.dart';
import 'package:free_note/widgets/overlays/calendar_list_overlay.dart';
import 'package:provider/provider.dart';

class CreateEventOverlay extends StatefulWidget {
  const CreateEventOverlay({super.key});

  @override
  State<CreateEventOverlay> createState() => _CreateEventOverlayState();
}

class _CreateEventOverlayState extends State<CreateEventOverlay> {
  final TextEditingController _titleController = TextEditingController();

  Calendar? _selectedCalendar;

  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now().add(const Duration(hours: 1));

  Future<void> _pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _start,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;

    final newStart = DateTime(
      picked.year,
      picked.month,
      picked.day,
      _start.hour,
      _start.minute,
    );

    setState(() {
      _start = newStart;

      if (!_isEndValid(_end, _start)) {
        _end = newStart.add(const Duration(hours: 1));
      }
    });
  }

  Future<void> _pickStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_start),
    );
    if (picked == null) return;

    final newStart = DateTime(
      _start.year,
      _start.month,
      _start.day,
      picked.hour,
      picked.minute,
    );

    setState(() {
      _start = newStart;

      if (!_isEndValid(_end, _start)) {
        _end = newStart.add(const Duration(hours: 1));
      }
    });
  }

  Future<void> _pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _end,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;

    final newEnd = DateTime(
      picked.year,
      picked.month,
      picked.day,
      _end.hour,
      _end.minute,
    );

    if (_isEndValid(newEnd, _start)) {
      setState(() => _end = newEnd);
    }
  }

  Future<void> _pickEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_end),
    );
    if (picked == null) return;

    final newEnd = DateTime(
      _end.year,
      _end.month,
      _end.day,
      picked.hour,
      picked.minute,
    );

    if (_isEndValid(newEnd, _start)) {
      setState(() => _end = newEnd);
    }
  }

  bool _isEndValid(DateTime end, DateTime start) {
    if (end.year != start.year ||
        end.month != start.month ||
        end.day != start.day) {
      return false;
    }

    return end.isAfter(start);
  }

  Future<void> _selectCalendar(BuildContext context) async {
    final calendar = await showModalBottomSheet<Calendar>(
      context: context,
      builder: (context) => const CalendarListOverlay(allowSelection: true),
    );

    if (calendar != null) {
      setState(() => _selectedCalendar = calendar);
    }
  }

  @override
  Widget build(BuildContext context) {
    _selectedCalendar ??= context.read<EventsProvider>().defaultCalendar;

    return BottomOverlay<Event>(
      onDone: () {
        final title = _titleController.text.trim();
        if (title.isEmpty) {
          return null;
        }
        if (_selectedCalendar == null) {
          return null;
        }

        return Event(
          id: 0,
          calendarId: _selectedCalendar!.id,
          title: title,
          start: _start,
          end: _end,
        );
      },

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Calendar'),
                TextButton(
                  onPressed: () => _selectCalendar(context),
                  child: Text(
                    _selectedCalendar?.name ?? 'Select',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Start'),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => _pickStartDate(context),
                      child: Text(
                        '${_start.year}-${_start.month}-${_start.day}',
                      ),
                    ),
                    TextButton(
                      onPressed: () => _pickStartTime(context),
                      child: Text(
                        TimeOfDay.fromDateTime(_start).format(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('End'),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => _pickEndDate(context),
                      child: Text('${_end.year}-${_end.month}-${_end.day}'),
                    ),
                    TextButton(
                      onPressed: () => _pickEndTime(context),
                      child: Text(TimeOfDay.fromDateTime(_end).format(context)),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
