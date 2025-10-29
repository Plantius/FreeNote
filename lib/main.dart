import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:free_note/router/router.dart';
import 'package:free_note/provides/notes_page_provider.dart';
import 'package:provider/provider.dart';

const supabaseUrl = 'https://qqofogsfiwttdcmpymsh.supabase.co';
const supabaseKey = String.fromEnvironment('SUPABASE_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

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
        )
      ),
      routerConfig: router,
    );
  }
}
