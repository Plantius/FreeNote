import 'dart:math';

import 'package:free_note/event_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  static final AuthService _instance = AuthService._();

  AuthService._();

  static AuthService get instance {
    return _instance;
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user;
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response.user;
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? get user => _supabase.auth.currentUser;

  Stream<AuthState> get userStream => _supabase.auth.onAuthStateChange;
}
