import 'package:flutter/material.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/providers/friends_provider.dart';
import 'package:free_note/widgets/overlays/bottom_overlay.dart';
import 'package:free_note/widgets/profile_entry.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FriendsOverlay extends StatelessWidget {
  const FriendsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FriendsProvider>();
    final friends = provider.friends;

    return BottomOverlay<Profile>(
      child: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return ProfileEntry(
            profile: friends[index],
            onTap: () {
              context.pop(provider.friends[index]);
            },
          );
        },
      ),
    );
  }
}
