import 'package:flutter/material.dart';
import 'package:free_note/widgets/option_button.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/providers/auth_provider.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:free_note/widgets/profile_picture.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.user == null || auth.profile == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Loading...', 
            style: Theme.of(context).textTheme.titleLarge
          ),
        ),
      );
    }

    User user = AuthService.instance.user!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings', 
          style: Theme.of(context).textTheme.titleLarge
        ),
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
                    child: ProfilePicture(
                      profile: auth.profile!,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        auth.profile?.username ?? '',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        user.email ?? '',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            OptionButton(
              action: _logOutAction,
              icon: Icons.logout,
              text: 'Log out',
            ),

            OptionButton(
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

  Future<void> _logOutAction() async {
    await context.read<AuthProvider>().signOut();

    if (mounted) {
      context.go('/login');
    }
  }
}
