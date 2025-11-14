import 'package:flutter/material.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/providers/auth_provider.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {

  List<String> friends = ["Niels", "Niels2"];

    return Scaffold(
      appBar: AppBar(
        title: Text('Friends', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.person_add)),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(child: Text(friends[index][0]),),
              title: Text(friends[index]),
              subtitle: Text(''),
              trailing: Text(''),
              onLongPress: () {

              }
            );
          })
      )
    );
  }
}
