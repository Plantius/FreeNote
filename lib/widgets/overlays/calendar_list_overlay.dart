import 'package:flutter/material.dart';
import 'package:free_note/models/calendar.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/providers/events_provider.dart';
import 'package:free_note/widgets/overlays/bottom_overlay.dart';
import 'package:free_note/widgets/overlays/create_calendar_overlay.dart';
import 'package:free_note/widgets/overlays/friends_overlay.dart';
import 'package:provider/provider.dart';

// NOTE: Much of this can be reused for a general overlay maybe?
class CalendarListOverlay extends StatelessWidget {
  const CalendarListOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventsProvider>();

    return BottomOverlay(
      action: BottomOverlayAction(
        'Add', 
        action: () => _onAddCalendar(context, provider),
      ),
      child: Column(
        children: [
          for (Calendar calendar in provider.calendars) 
            SwitchListTile(
              value: calendar.visible, 
              title: Row(
                children: [
                  IconButton(
                    onPressed: () => _onShare(context, provider, calendar),
                    icon: Icon(Icons.share),
                  ),

                  SizedBox(width: 8),

                  Text(calendar.name)
                ],
              ),
              onChanged: (value) {
                provider.updateCalendarVisibility(calendar, value);
              }
            ),
        ],
      )
    );
  }

  void _onAddCalendar(
    BuildContext context, 
    EventsProvider provider
  ) async {
    Calendar? calendar = await showModalBottomSheet<Calendar>(
      context: context, 
      builder: (context) => CreateCalendarOverlay(),
    );

    if (calendar != null && context.mounted) {
      provider.addCalendar(calendar);
    }
  }

  void _onShare(
    BuildContext context, 
    EventsProvider provider, 
    Calendar calendar
  ) async {
    Profile? profile = await showModalBottomSheet(
      context: context, 
      builder: (context) => FriendsOverlay(),
    );

    if (profile != null && context.mounted) {
      provider.shareCalendar(calendar, profile);
    }
  }
}
