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

  RealtimeChannel? _channel;

  List<CustomNotification> _notifications = [];

  NotificationsProvider(this.database) {
    AuthService.instance.userStream.listen((state) {
      _reloadChannel();
      loadNotifications();
    });

    _reloadChannel();
  }

  void _reloadChannel() {
    logger.d(
      'Reloading notifications channel for ${supabase.auth.currentUser?.id}.',
    );
    final userId = supabase.auth.currentUser?.id;

    _unsubscribeChannel();

    if (userId == null) return;

    final filter = PostgresChangeFilter(
      type: PostgresChangeFilterType.eq,
      column: 'to_uid',
      value: userId,
    );

    _channel = database.getChannel('friend_requests', filter, handlePayload);
  }

  void _unsubscribeChannel() {
    if (_channel != null) {
      _channel!.unsubscribe();
      _channel = null;
    }
  }

  void handlePayload(PostgresChangePayload payload) {
    logger.d('Received notification payload: $payload');

    if (payload.eventType == PostgresChangeEvent.insert ||
        payload.eventType == PostgresChangeEvent.update) {
      logger.d('Reloading notifications.');
      loadNotifications();
    } else if (payload.eventType == PostgresChangeEvent.delete) {
      final id = payload.oldRecord['id'] as int?;
      if (id != null) {
        logger.d('Removing notification with id $id');
        removeNotification(id);
      }
    }
  }

  @override
  void dispose() {
    _channel!.unsubscribe();
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
