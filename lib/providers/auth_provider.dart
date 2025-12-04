import 'package:flutter/material.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:free_note/services/database_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;
  User? _user;
  Profile? _profile;
  String? _error;
  bool _loading = false;

  String _username = '';

  User? get user => _user;
  Profile? get profile {
    if (_authService.user == null) {
      return null;
    } 

    if (_profile != null) {
      return _profile;
    }

    if (_profile == null) {
      _profile ??= Profile(
        uid: _authService.user!.id, 
        username: _username, 
        email: _authService.user!.email ?? '',
      );

      logger.i('Created local profile: $_profile');
    }

    return _profile;
  }

  String? get error => _error;
  bool get loading => _loading;

  AuthProvider() {
    _authService.userStream.listen((user) async {
      _user = _authService.user;

      if (_user == null) {
        _profile = null;
      } else if (_profile == null || _profile!.uid != _user!.id) {
        _profile = await DatabaseService.instance.fetchProfile();
      }

      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    return _authenticate(email, password, _authService.signIn);
  }

  Future<bool> signUp(String email, String username, String password) async {
    bool success = await _authenticate(
      email,
      password,
      (email, password) => _authService.signUp(email, username, password),
    );

    if (success) {
      _username = username;
    }

    return success;
  }

  Future<bool> _authenticate(
    String email,
    String password,
    Future<User?> Function(String, String) func,
  ) async {
    _loading = true;
    _error = null;
    _user = null;
    notifyListeners();

    try {
      _user = await func(email, password);
    } on AuthException catch (e) {
      _error = e.message;
    } catch (e) {
      logger.e(e);
    }

    if (_user == null && _error == null) {
      _error = 'Unknown error';
    }

    _loading = false;
    notifyListeners();

    return _error == null;
  }

  Future<void> signOut() async {
    _loading = false;
    _error = null;
    _user = null;

    await _authService.signOut();

    notifyListeners();
  }
}
