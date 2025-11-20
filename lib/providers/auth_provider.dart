import 'package:flutter/material.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;
  User? _user;
  String? _error;
  bool _loading = false;

  User? get user => _user;
  String? get error => _error;
  bool get loading => _loading;

  AuthProvider() {
    _authService.userStream.listen((user) {
      _user = _authService.user;
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    return _authenticate(email, password, _authService.signIn);
  }

  Future<bool> signUp(String email, String password) async {
    return _authenticate(email, password, _authService.signUp);
  }

  Future<bool> _authenticate(
    String email, String password, 
    Future<User?> Function(String, String) func
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

  Future<void> signOut() async { // TODO: should signout have errors?
    _loading = false;
    _error = null;
    _user = null;

    await _authService.signOut();
    
    notifyListeners();
  }
}
