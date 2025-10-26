import 'package:go_router/go_router.dart';
import 'package:free_note/widgets/app_scaffold.dart';
import 'package:free_note/pages/notes_page.dart';
import 'package:free_note/pages/calendar_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    // Authentication checks should go here:
    // If not logged_in(): return '/login'

    if (state.matchedLocation == '/') {
      return '/notes';
    }

    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppScaffold(
          currentLocation: state.matchedLocation, 
          child: child
        );
      },
      routes: [
        GoRoute(
          path: '/notes',
          builder: (context, state) {
            return const NotesPage();
          }
        ),
        GoRoute(
          path: '/calendar',
          builder: (context, state) {
            return const CalendarPage();
          }
        )
      ]
    )
  ],
);
