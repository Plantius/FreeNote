import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomOverlayAction extends StatelessWidget {
  final String text;
  final void Function() action;

  const BottomOverlayAction(this.text, {super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: action, 
      child: Text(
        text, 
        style: TextStyle(
          color: Colors.white,
        ),
      )
    );
  }
}

class BottomOverlay<T> extends StatelessWidget {
  final Widget child;
  final T? Function()? onDone;
  final BottomOverlayAction? action;

  const BottomOverlay({
    super.key, 
    required this.child,
    this.onDone,
    this.action,
  });

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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              action == null 
                ? Container() 
                : action!,

              BottomOverlayAction(
                'Done', 
                action: () {
                  context.pop((onDone ?? _defaultOnDone).call());
                }
              )
            ],
          ),

          child
        ],
      ),
    );
  }

  T? _defaultOnDone() {
    return null;
  }
}
