// When fetched from the backend, private and shared calendars can be treated
// equally. Names will overlap, thats fine, more important things to work on.
class Calendar {
  int id = 0;
  final String name;
  bool visible;
  final int color;

  Calendar({
    required this.id,
    required this.name,
    required this.visible,
    required this.color,
  });

  @override
  String toString() {
    return 'Calendar(#$id, "$name", visible=$visible)';
  }

  factory Calendar.fromJson(Map<String, dynamic> json) {
    return Calendar(
      id: json['id'] as int,
      name: json['name'] as String,
      visible: json['visible'] as bool,
      color: json['color'] as int,
    );
  }
}
