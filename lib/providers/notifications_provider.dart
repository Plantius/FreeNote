import 'package:flutter/material.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/models/notification.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:free_note/services/database_service.dart';

class NotificationsProvider with ChangeNotifier {
  final DatabaseService database;
  List<CustomNotification> _notifications = [];

  NotificationsProvider(this.database) {
    AuthService.instance.userStream.listen((state) {
      loadNotifications();
    });
  }

  List<CustomNotification> get notifications => _notifications;

  Future<void> loadNotifications() async {
    try {
      _notifications = await database.fetchNotifications();

      notifyListeners();
    } catch (e) {
      logger.e('Failed to load notifications: $e');
    }
  }

  Future<void> removeNotification(int id) async {
    _notifications.removeWhere((notification) => notification.id == id);
    notifyListeners();
  }
}
