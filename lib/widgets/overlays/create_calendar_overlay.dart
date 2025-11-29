import 'package:flutter/material.dart';
import 'package:free_note/models/calendar.dart';
import 'package:free_note/widgets/overlays/bottom_overlay.dart';

class CreateCalendarOverlay extends StatefulWidget {
  const CreateCalendarOverlay({super.key});

  @override
  State<CreateCalendarOverlay> createState() => _CreateCalendarOverlayState();
}

class _CreateCalendarOverlayState extends State<CreateCalendarOverlay> {
  final TextEditingController _nameController = TextEditingController();

  // Simple palette of colors
  final List<Color> _palette = const [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.teal,
  ];

  Color _selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return BottomOverlay<Calendar>(
      onDone: () {
        final name = _nameController.text.trim();
        if (name.isEmpty) return null;

        return Calendar(
          id: 0,
          name: name,
          visible: true,
          color: _selectedColor.toARGB32(),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 12,
              children: _palette.map((color) {
                final bool isSelected = color == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedColor = color;
                  }),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.onSurface,
                              width: 3,
                            )
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
