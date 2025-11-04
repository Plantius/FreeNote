import 'package:flutter/material.dart';
import 'package:free_note/data/database_service.dart';
import 'package:free_note/router/router.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:free_note/data/supabase.dart';
import 'package:provider/provider.dart';
import 'package:free_note/event_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();

  final supabase = SupabaseService.client;
  final database = DatabaseService.instance;

  // Login, replace when login wrapper exists
  final response = await supabase.auth.signInWithPassword(
    email: 'test@example.com',
    password: 'supersecret',
  );

  if (response.user != null) {
    logger.i(response.user!.email.toString());
  } else {
    logger.e("Login failed.");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NotesProvider(database)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FreeNote',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(109, 33, 134, 1),
          surface: Color.fromRGBO(40, 43, 48, 1),
          primary: Color.fromRGBO(109, 33, 134, 1),
          brightness: Brightness.dark,
        ),
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
