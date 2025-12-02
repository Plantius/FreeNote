import 'package:flutter/material.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/models/notification.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:free_note/services/database_service.dart';
import 'package:free_note/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsProvider with ChangeNotifier {
  final DatabaseService database;
  final supabase = SupabaseService.client;

  late final RealtimeChannel _channel;

  List<CustomNotification> _notifications = [];

  NotificationsProvider(this.database) {
    AuthService.instance.userStream.listen((state) {
      loadNotifications();
      _channel = database.getChannel('friend_requests', (payload) {
        logger.i('Received notification payload: ${payload.toString()}');
        // CHECK IF THE NOTIFICATION IS FOR THE CURRENT USER
        logger.i(
          'Current user id: ${supabase.auth.currentUser?.id}, to_uid in payload: ${payload.newRecord['to_uid'] ?? payload.oldRecord['to_uid']}',
        );
        if (payload.newRecord['to_uid'] ??
            payload.oldRecord['to_uid'] == supabase.auth.currentUser?.id) {
          logger.i('Notification is for the current user, reloading.');
          loadNotifications();
        }
      });
    });
  }

  @override
  void dispose() {
    _channel.unsubscribe();
    super.dispose();
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
