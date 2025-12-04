import 'package:free_note/models/profile.dart';

enum NotificationType { 
  friendRequest,
}

class CustomNotification {
  final int id;
  String content;
  Profile? sender;
  final DateTime createdAt;
  final NotificationType type;

  CustomNotification({
    required this.id,
    required this.content,
    this.sender,
    required this.createdAt,
    required this.type,
  });

  factory CustomNotification.fromJson(Map<String, dynamic> json) {
    return CustomNotification(
      id: json['id'] as int,
      content: json['content'] ?? '',
      sender: json['profiles'] != null
          ? Profile.fromJson(json['profiles'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      type: NotificationType.friendRequest,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'sender': sender?.toJson(),
    'created_at': createdAt.toIso8601String(),
    'type': type.toString(),
  };

  @override
  String toString() {
    return 'Notification(#$id, "$content", from: ${sender?.username ?? "System"})';
  }
}
