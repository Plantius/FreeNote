import 'package:flutter/material.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/providers/auth_provider.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Option extends StatelessWidget {
  final void Function() action; 
  final IconData icon;
  final String text;
  final bool? danger;

  const Option({super.key, 
    required this.action, 
    required this.icon, 
    required this.text,
    this.danger
  });

  @override
  Widget build(BuildContext context) {
    Color color = danger ?? false ? Colors.red : Colors.white;

    return TextButton(
      onPressed: action,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                icon,
                size: 30,
                color: color,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context)
                  .textTheme
                  .labelLarge?.copyWith(color: color),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (AuthService.instance.user == null) {
      logger.e('Invalid state: no logged in user');
      context.go('/login');
    }

    User user = AuthService.instance.user!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: CircleAvatar(
                      child: Text(
                        'X',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        user.email ?? '',
                        style: Theme.of(context).textTheme.titleSmall,
                      )
                    ],
                  )
                )
              ],
            ),
            Option(
              action: () async {
                context.read<AuthProvider>().signOut();
                context.go('/login');
              },
              icon: Icons.logout,
              text: 'Log out',
            ),
            SizedBox(
              height: 8,
            ),
            Option(
              action: () {
                logger.w('TODO: implement Delete Account');
              }, 
              icon: Icons.delete, 
              text: 'Delete Account',
              danger: true,
            ),
          ],
        ),
      ),
    );
  }
}
