import 'package:flutter/material.dart';
import 'package:free_note/models/profile.dart';

class ProfileEntry extends StatelessWidget {
  final Profile profile;

  const ProfileEntry({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          profile.username
            .substring(0, 1)
            .toUpperCase(),
        ),
      ),

      title: Text(profile.username),
    );
  }
}
