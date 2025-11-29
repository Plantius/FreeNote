import 'package:flutter/material.dart';
import 'package:free_note/models/calendar.dart';
import 'package:free_note/providers/events_provider.dart';
import 'package:free_note/widgets/overlays/bottom_overlay.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// NOTE: Much of this can be reused for a general overlay maybe?
class CalendarOverlay extends StatelessWidget {
  const CalendarOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventsProvider>();

    return BottomOverlay(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  context.pop();
                }, 
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),

          for (Calendar calendar in provider.calendars) 
            SwitchListTile(
              value: calendar.visible, 
              title: Text(calendar.name),
              onChanged: (value) {
                
                provider.updateCalendarVisibility(calendar, value);
              }
            ),
        ],
      ),
    );
  }
}
