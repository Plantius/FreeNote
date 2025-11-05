import 'package:flutter/material.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/pages/error_page.dart';
import 'package:free_note/providers/auth_provider.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = AuthService.instance.user;

    if (user == null) {
      logger.e('Invalid state: no logged in user');
      context.go('/login');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          const Text('Stub for profile page'),
          TextButton(
            onPressed: () async {
              context.read<AuthProvider>().signOut();
              context.go('/login');
            }, 
            child: const Text('Sign Out'),
          )
        ],
      ),
    );
  }
}
