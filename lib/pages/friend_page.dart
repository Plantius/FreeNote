import 'package:flutter/material.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/providers/auth_provider.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> friends = ["Niels", "Niels2"];

    User? user = AuthService.instance.user;

    if (user == null) {
      logger.e('Invalid state: no logged in user');
      context.go('/login');
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          child: ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(child: Text(friends[index][0]),),
                title: Text(friends[index]),
                subtitle: Text(''),
                trailing: Text(''),
              );
            })
        )
      );
    }
  }
}
