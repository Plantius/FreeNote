import 'package:flutter/material.dart';
import 'package:free_note/router/router.dart';
import 'package:free_note/provides/notes_page_provider.dart';
import 'package:provider/provider.dart';
import 'package:free_note/data/supabase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => NotesPageProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FreeNote',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(255, 0, 255, 1),
          brightness: Brightness.dark,
        ),
      ),
      routerConfig: router,
    );
  }
}
