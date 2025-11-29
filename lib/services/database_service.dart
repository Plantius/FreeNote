import 'dart:math';

import 'package:flutter/material.dart';
import 'package:free_note/models/calendar.dart';
import 'package:free_note/models/event.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/services/supabase_service.dart';
import 'package:free_note/event_logger.dart';

class DatabaseService {
  final supabase = SupabaseService.client;

  static final DatabaseService _instance = DatabaseService._();

  DatabaseService._();

  static DatabaseService get instance {
    return _instance;
  }

  Future<List<Note>> fetchNotes() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await supabase
        .from('notes')
        .select('*, user_notes(*)')
        .eq('user_notes.user_id', userId)
        .order('updated_at', ascending: false);

    logger.i(
      'Successfully fetched notes for user ${supabase.auth.currentUser?.email}',
    );

    return (response as List).map((note) => Note.fromJson(note)).toList();
  }

  Future<Profile?> fetchProfile() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final response = await supabase
          .from('profiles')
          .select('*')
          .eq('uid', userId)
          .single();
      logger.i('Successfully fetched profile for user $userId');
      return Profile.fromJson(response);
    } catch (e) {
      logger.e('Failed to fetch profile for user $userId: $e');
      return null;
    }
  }

  Future<Profile?> userExists(String username) async {
    try {
      final response = await supabase
          .from('profiles')
          .select('*')
          .eq('user_name', username)
          .maybeSingle();

      if (response == null) {
        logger.w('No profile found for user $username');
        return null;
      }
      return Profile.fromJson(response);
    } catch (e) {
      logger.e('Failed to fetch profile for user $username: $e');
      return null;
    }
  }

  Future<List<Profile>?> fetchFriends() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final friendIds = await supabase
          .from('user_friends')
          .select('uid1, uid2')
          .or('uid1.eq.$userId,uid2.eq.$userId');

      final friends = await Future.wait(
        friendIds.map((friend) async {
          final friendId = friend['uid1'] == userId
              ? friend['uid2']
              : friend['uid1'];
          final profileResponse = await supabase
              .from('profiles')
              .select('*')
              .eq('uid', friendId)
              .single();
          return Profile.fromJson(profileResponse);
        }),
      );

      logger.i('Successfully fetched friends for user $userId');
      return friends;
    } catch (e) {
      logger.e('Failed to fetch friends for user $userId: $e');
      return [];
    }
  }

  Future<Note?> fetchNote(int id) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await supabase
        .from('notes')
        .select('*, user_notes(*)')
        .eq('user_notes.user_id', userId)
        .eq('id', id)
        .maybeSingle();

    if (response == null) {
      logger.w('No note found with id $id for user $userId');
      return null;
    }

    logger.i('Successfully fetched note with id $id for user $userId');
    return Note.fromJson(response);
  }

  Future<Note?> createNote(Note note) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final inserted = await supabase
          .rpc(
            'create_note_with_user',
            params: {'p_title': note.title, 'p_content': note.content},
          )
          .select()
          .single();
      return Note.fromJson(inserted);
    } catch (e) {
      logger.e('Failed to create note for user $userId: $e');
      rethrow;
    }
  }

  Future<Calendar?> createCalendar(Calendar calendar) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await supabase
          .rpc(
            'create_calendar_with_user',
            params: {
              'p_name': calendar.name,
              'p_color': calendar.color,
              'p_visible': calendar.visible,
            },
          )
          .select()
          .single();

      logger.i('Successfully created calendar for user $userId');

      return Calendar.fromJson(response);
    } catch (e) {
      logger.e('Failed to create calendar: $e');
    }

    return null;
  }

  Future<void> shareCalendar(Calendar calendar, Profile profile) async {
    try {
      await supabase.from('user_calendars').insert({
        'calendar_id': calendar.id,
        'user_id': profile.uid,
      });

      logger.i(
        'Successfully shared calendar ${calendar.id} with user ${profile.uid}',
      );
    } catch (e) {
      logger.e(
        'Failed to share calendar ${calendar.id} with user ${profile.uid}: $e',
      );
    }
  }

  Future<List<Event>> fetchEvents() async {
    return [];
  }

  Future<List<Calendar>> fetchCalendars() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await supabase
          .from('calendars')
          .select('*, user_calendars(*)')
          .eq('user_calendars.user_id', userId);

      logger.i('Successfully fetched calendars for user $userId');

      return (response as List)
          .map((calendar) => Calendar.fromJson(calendar))
          .toList();
    } catch (e) {
      logger.e('Failed to fetch calendars: $e');
    }
    return [];
  }

  Future<void> updateNote(Note note) async {
    try {
      await supabase
          .from('notes')
          .update({
            'title': note.title,
            'content': note.content,
            'updated_at': note.updatedAt.toIso8601String(),
          })
          .eq('id', note.id);
    } catch (e) {
      logger.e('Failed to update note ${note.id}: $e');
      rethrow;
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await supabase.from('notes').delete().eq('id', id);
    } catch (e) {
      logger.e('Failed to delete note $id: $e');
      rethrow;
    }
  }

  Future<bool> sendFriendRequest(String uid) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      await supabase.from('friend_requests').insert({
        'from_uid': userId,
        'to_uid': uid,
      });
      logger.i('Succesfully send friend request to user $uid');
      return true;
    } catch (e) {
      logger.e('Failed to send friend request to user $uid');
    }
    return false;
  }

  Future<void> acceptFriendRequest(Profile user) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await supabase
          .from('friend_requests')
          .select('*')
          .eq('to_uid', userId)
          .eq('from_uid', user.uid)
          .maybeSingle();

      if (response == null) {
        logger.w('No friend request found from user ${user.uid} to accept');
        return;
      }

      await supabase.from('user_friends').insert({
        'uid1': userId,
        'uid2': user.uid,
      });

      await supabase
          .from('friend_requests')
          .delete()
          .eq('to_uid', userId)
          .eq('from_uid', user.uid);

      logger.i('Successfully accepted friend request from user ${user.uid}');
    } catch (e) {
      logger.e('Failed to accept friend request from user ${user.uid}: $e');
      rethrow;
    }
  }
}
