import 'package:flutter/material.dart';

class BottomOverlay extends StatelessWidget {
  final Widget child;

  const BottomOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      width: size.width - 40,
      padding: const EdgeInsets.all(8),
      child: child,
    );
  }
}
