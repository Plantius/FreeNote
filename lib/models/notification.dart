enum NotificationType {fRequest, fAccept, systemMessage}

class Notification {
  final int id;
  String content;
  final DateTime createdAt;
  bool read;
  NotificationType type;

  Notification({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.type,
    required this.read,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as int,
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      type: json['type'] as NotificationType,
      read: json['read'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'content': content,
    'created_at': createdAt,
    'type' : type,
    'read' : read,
  };
}
