import 'package:flutter/foundation.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/services/database_service.dart';

class FriendsProvider with ChangeNotifier {
  final DatabaseService database;
  bool _isLoading = false;
  String? _errorMessage;

  FriendsProvider(this.database);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<List<Profile>> loadFriends() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final friends = await database.fetchFriends();
      _isLoading = false;
      notifyListeners();
      return friends!;
    } catch (e) {
      _errorMessage = 'Failed to fetch friends: $e';
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

}
