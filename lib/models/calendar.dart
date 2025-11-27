// When fetched from the backend, private and shared calendars can be treated 
// equally. Names will overlap, thats fine, more important things to work on.
class Calendar {
  final int id;
  final String name;
  bool visible;
  final int color;

  Calendar({
    required this.id, 
    required this.name, 
    required this.visible, 
    required this.color
  });

  @override
  String toString() {
    return 'Calendar(#$id, "$name", visible=$visible)';
  }
}
