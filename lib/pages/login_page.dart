import 'package:flutter/material.dart';
import 'package:free_note/providers/auth_provider.dart';
import 'package:free_note/event_logger.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
      body: Column(
        children: [
          const Text('Username...'),
          const Text('Password...'),
          IconButton(
            onPressed: () async {
              _debugLogin();
            },
            icon: Icon(Icons.auto_awesome),
          ),
        ],
      ),
    );
  }

  void _debugLogin() async {
    final success = await context.read<AuthProvider>().signIn(
      'test@example.com',
      'supersecret',
    );

    if (success) {
      logger.i('Successfully logged into development account');

      if (mounted) {
        context.go('/');
      }
    } else {
      logger.e('Logging into development account failed');
    }
  }
}
