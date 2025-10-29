import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class MarkdownViewer extends StatelessWidget {
  final String data;
  final EdgeInsetsGeometry? padding;

  const MarkdownViewer({super.key, required this.data, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(8.0),
      child: Markdown(
        data: data,
        selectable: true,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
        onTapLink: (text, href, title) {},
      ),
    );
  }
}
