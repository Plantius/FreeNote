import 'package:flutter/material.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/widgets/profile_picture.dart';

class ProfileEntry extends StatelessWidget {
  final Profile profile;

  const ProfileEntry({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfilePicture(
        profile: profile
      ),
      title: Text(
        profile.username
      ),
    );
  }
}
