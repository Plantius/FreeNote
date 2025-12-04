import 'package:flutter/material.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/widgets/profile_entry.dart';
import 'package:free_note/widgets/searchers/simple_search_delegate.dart';

class FriendSearchDelegate extends SimpleSearchDelegate<Profile> {
  FriendSearchDelegate({required super.entries});

  @override
  Widget buildEntry(BuildContext context, Profile profile) {
    return ProfileEntry(profile: profile);
  }

  @override
  bool matches(String query, Profile profile) {
    return profile.username.contains(query.toLowerCase());
  } 
}
