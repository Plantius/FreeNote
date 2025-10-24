import 'package:flutter/material.dart';
import 'package:free_note/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://qqofogsfiwttdcmpymsh.supabase.co';
const supabaseKey = String.fromEnvironment('SUPABASE_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FreeNote',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
      ),
      home: const MyHomePage(title: 'FreeNote'),
    );
  }
}
