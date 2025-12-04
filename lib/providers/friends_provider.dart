import 'package:flutter/foundation.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:free_note/services/database_service.dart';

class FriendsProvider with ChangeNotifier {
  final DatabaseService database;
  List<Profile> _friends = [];

  bool _isLoading = false;
  String? _errorMessage;

  FriendsProvider(this.database) {
    AuthService.instance.userStream.listen((state) {
      loadFriends();
    });
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Profile> get friends => _friends;

  Future<void> loadFriends() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final friends = await database.fetchFriends();
      if (friends != null) {
        _friends = friends;
      } else {
        _friends = [];
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch friends: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> sendFriendRequest(String username) async {
    final profile = await database.userExists(username);
    if (profile == null) return false;

    return await database.sendFriendRequest(profile.uid);
  }

  Future<void> acceptFriendRequest(Profile user) async {
    try {
      await database.acceptFriendRequest(user);
      await loadFriends();
    } catch (e) {
      _errorMessage = 'Failed to accept friend request: $e';
      notifyListeners();
    }
  }

  Future<void> denyFriendRequest(Profile user) async {
    try {
      await database.denyFriendRequest(user);
    } catch (e) {
      _errorMessage = 'Failed to deny friend request: $e';
      notifyListeners();
    }
  }
}
