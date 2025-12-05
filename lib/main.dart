import 'package:flutter/material.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/providers/auth_provider.dart';
import 'package:free_note/providers/friends_provider.dart';
import 'package:free_note/providers/notifications_provider.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:free_note/services/database_service.dart';
import 'package:free_note/router/router.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:free_note/providers/events_provider.dart';
import 'package:free_note/services/supabase_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:calendar_view/calendar_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();

  AuthService.instance.userStream.listen((state) {
    User? user = AuthService.instance.user;
    String userState = user == null ? '(null)' : user.email!;
    logger.i(
      'Authentication state change: ${state.event}, user is now $userState',
    );
  });

  await AuthService.instance.signOut();

  User? user = AuthService.instance.user;
  if (user != null) {
    logger.i('logged in? ${user.email}');
  }

  final database = DatabaseService.instance;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => NotesProvider(database)),
        ChangeNotifierProvider(create: (context) => EventsProvider(database)),
        ChangeNotifierProvider(create: (context) => FriendsProvider(database)),
        ChangeNotifierProvider(
          create: (context) => NotificationsProvider(database),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp.router(
        title: 'FreeNote',
        theme: ThemeData(
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Color.fromRGBO(0xDB, 0x91, 0xEF, 1),
            ),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromRGBO(109, 33, 134, 1),
            surface: Color.fromRGBO(40, 43, 48, 1),
            primary: Color.fromRGBO(109, 33, 134, 1),
            brightness: Brightness.dark,
          ),
        ),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FlutterQuillLocalizations.delegate,
        ],
      ),
    );
  }
}
