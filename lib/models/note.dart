class Note {
  final int id;
  String title;
  String content;
  final DateTime createdAt;
  DateTime updatedAt;
  bool isNested;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isNested,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as int,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isNested: json['is_nested'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'is_nested': isNested,
  };

  @override
  String toString() {
    return 'Note(#$id, "$title", isNested: $isNested)';
  }
}
