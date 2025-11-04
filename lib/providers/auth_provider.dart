import 'package:flutter/material.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;
  User? _user;

  User? get user => _user;

  AuthProvider() {
    _authService.userStream.listen((user) {
      _user = _authService.user;
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    final user = await _authService.signIn(email, password);

    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> signUp(String email, String password) async {
    final user = await _authService.signUp(email, password);

    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> signOut() async {
    await _authService.signOut();

    _user = null;
    notifyListeners();
  }
}
