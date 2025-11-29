import 'package:flutter/material.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/providers/friends_provider.dart';
import 'package:free_note/widgets/overlays/bottom_overlay.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FriendsOverlay extends StatelessWidget {
  const FriendsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    FriendsProvider provider = context.read<FriendsProvider>();

    return BottomOverlay<Profile>(
      child: ListView.builder(
        itemCount: provider.friends.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text(
                provider.friends[index].username
                  .substring(0, 1)
                  .toUpperCase(),
              ),
            ),
            title: Text(provider.friends[index].username),
            onTap: () {
              context.pop(provider.friends[index]);
            },
          );
        },
      ),
    );
  }
}
