import 'package:flutter/material.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;
  User? _user;
  bool _error = false;
  bool _loading = false;

  User? get user => _user;
  bool get error => _error;
  bool get loading => _loading;

  AuthProvider() {
    _authService.userStream.listen((user) {
      _user = _authService.user;
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _loading = true; 
    _error = false;
    notifyListeners();

    _user = await _authService.signIn(email, password);
    _loading = false;
    _error = _user == null;
    notifyListeners();

    return _user != null;
  }

  Future<bool> signUp(String email, String password) async {
    _loading = true; 
    _error = false;
    notifyListeners();

    _user = await _authService.signUp(email, password);
    _loading = false;
    _error = _user == null;
    notifyListeners();

    logger.i('Sign up? $_user $_loading $_error');

    return _user != null;
  }

  Future<void> signOut() async { // TODO: should signout have errors?
    _loading = false;
    _error = false;
    _user = null;
    await _authService.signOut();
    notifyListeners();
  }
}
