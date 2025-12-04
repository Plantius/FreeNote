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
    _channel = database.getChannel('friend_requests', handlePayload);

    AuthService.instance.userStream.listen((state) {
      loadNotifications();
    });
  }

  void handlePayload(PostgresChangePayload payload) {
    logger.i('Received notification payload: $payload');

    final current = supabase.auth.currentUser?.id;
    final toUid = payload.newRecord['to_uid'] as String?;

    if ((payload.eventType == PostgresChangeEvent.insert ||
            payload.eventType == PostgresChangeEvent.update) &&
        toUid == current) {
      logger.i('Notification is for the current user, reloading.');
      loadNotifications();
    } else if (payload.eventType == PostgresChangeEvent.delete) {
      final id = payload.oldRecord['id'] as int?;
      if (id != null) {
        removeNotification(id);
      }
    }
  }

  @override
  void dispose() {
    _channel.unsubscribe();
    super.dispose();
  }

  List<CustomNotification> get notifications => _notifications;

  Future<void> loadNotifications() async {
    try {
      final notifications = await database.fetchNotifications();
      if (notifications.isNotEmpty && notifications != _notifications) {
        _notifications = notifications;
        notifyListeners();
      }
    } catch (e) {
      logger.e('Failed to load notifications: $e');
    }
  }

  Future<void> removeNotification(int id) async {
    _notifications.removeWhere((notification) => notification.id == id);
    notifyListeners();
  }
}
