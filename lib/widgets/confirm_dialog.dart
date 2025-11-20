import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmDialog extends StatelessWidget {
  final String text;

  const ConfirmDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        text,
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop(false);
          },
          child: const Text('No'),
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            context.pop(true);
          }
        ),
      ],
    );
  }
}
