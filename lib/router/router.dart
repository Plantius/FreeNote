import 'package:free_note/models/event.dart';
import 'package:free_note/pages/calendar_day_page.dart';
import 'package:free_note/pages/event_viewer_page.dart';
import 'package:free_note/pages/friend_page.dart';
import 'package:free_note/pages/note_options_page.dart';
import 'package:free_note/pages/main_page.dart';
import 'package:free_note/pages/profile_page.dart';
import 'package:free_note/services/supabase_service.dart';
import 'package:free_note/pages/error_page.dart';
import 'package:free_note/pages/login_page.dart';
import 'package:go_router/go_router.dart';
import 'package:free_note/pages/note_viewer_page.dart';
import 'package:free_note/pages/notes_page.dart';
import 'package:free_note/pages/calendar_month_page.dart';
import 'package:free_note/models/note.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final supabase = SupabaseService.client;

    if (supabase.auth.currentUser == null) {
      return '/login';
    }

    if (state.matchedLocation == '/') {
      return '/notes';
    }

    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainPage(currentLocation: state.matchedLocation, child: child);
      },
      routes: [
        GoRoute(
          path: '/notes',
          builder: (context, state) {
            return NotesPage();
          },
        ),
        GoRoute(
          path: '/calendar',
          builder: (context, state) {
            return const CalendarMonthPage();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/note/:id',
      builder: (context, state) {
        final idString = state.pathParameters['id']!;
        final id = int.tryParse(idString) ?? 0;

        return NoteViewerPage(note: state.extra as Note?, noteId: id);
      },
    ),
    GoRoute(
      path: '/calendar/day',
      builder: (context, state) {
        return CalendarDayPage(date: state.extra as DateTime);
      },
    ),
    GoRoute(
      // ID is only kept for semantics; only extra is used.
      path: '/note/:id/options',
      builder: (context, state) {
        if (state.extra == null) {
          return ErrorPage(
            error: 'Can only navigate to options page from note page!',
          );
        }

        return NoteOptionsPage(note: state.extra as Note);
      },
    ),
    GoRoute(
      path: '/event/:id',
      builder: (context, state) {
        final idString = state.pathParameters['id']!;
        final id = int.tryParse(idString) ?? 0;

        return EventViewerPage(event: state.extra as Event?, eventId: id);
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return LoginPage();
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return ProfilePage();
      },
    ),
    GoRoute(
      path: '/friends',
      builder: (context, state) {
        return FriendPage();
      },
    ),
  ],
  errorBuilder: (context, state) {
    return ErrorPage(error: state.error.toString());
  },
);
