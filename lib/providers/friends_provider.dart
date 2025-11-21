import 'package:flutter/foundation.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:free_note/services/database_service.dart';

class FriendsProvider with ChangeNotifier {
  final DatabaseService database;
  List<Profile>? _friends;

  bool _isLoading = false;
  String? _errorMessage;

  FriendsProvider(this.database) {
    AuthService.instance.userStream.listen((state) {
      loadFriends();
    });
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Profile> get friends => _friends == null ? [] : _friends!;

  Future<void> loadFriends() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final friends = await database.fetchFriends();
      _isLoading = false;
      notifyListeners();
      if (friends != null) {
        _friends = friends;
      } else {
        _friends = [];
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch friends: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
}
