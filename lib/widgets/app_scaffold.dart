import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FreeNote AppBar'),
      ),
      body: child,
      bottomNavigationBar: const Text('Placeholder NavBar'),
    );
  }
}
