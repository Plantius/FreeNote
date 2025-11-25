import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final void Function() action;
  final IconData icon;
  final String text;
  final bool? danger;

  const OptionButton({
    super.key,
    required this.action,
    required this.icon,
    required this.text,
    this.danger,
  });

  @override
  Widget build(BuildContext context) {
    Color color = danger ?? false ? Colors.red : Colors.white;

    return TextButton(
      onPressed: action,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
