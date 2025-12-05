import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:free_note/models/profile.dart';

class ProfilePicture extends StatelessWidget {
  final Profile profile;
  final TextStyle? style;

  const ProfilePicture({super.key, required this.profile, this.style});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: _toPleasantColor(profile.username),
      child: Text(profile.username.substring(0, 1).toUpperCase(), style: style),
    );
  }

  Color _toPleasantColor(String string) {
    final bytes = utf8.encode(string);
    final hash = bytes.fold(0, (p, c) => p + c) % 360;

    final hslColor = HSLColor.fromAHSL(1.0, hash.toDouble(), 0.5, 0.3);

    return hslColor.toColor();
  }
}

// // Create a stable hash
