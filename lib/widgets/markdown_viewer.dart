import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarkdownViewer extends StatelessWidget {
  final String data;
  final EdgeInsetsGeometry? padding;

  const MarkdownViewer({super.key, required this.data, this.padding});

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;

    return Padding(
      padding: padding ?? const EdgeInsets.all(8.0),
      child: Markdown(
        data: data,
        selectable: true,
        imageBuilder: (uri, title, alt) {
          final url = uri.toString();

          if (url.toLowerCase().endsWith('.svg')) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SvgPicture.network(
                url,
                placeholderBuilder: (context) =>
                    const Center(child: CircularProgressIndicator()),
                fit: BoxFit.contain,
                height: 200,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    alt ?? 'Image failed to load',
                    style: const TextStyle(color: Colors.red),
                  );
                },
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Image.network(
              url,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Text(
                  alt ?? 'Image failed to load',
                  style: const TextStyle(color: Colors.red),
                );
              },
            ),
          );
        },
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          p: const TextStyle(fontSize: 16.0),
          // TODO: this solves a contrast issue with blockquotes, possibly
          //  use different color. Ideally, I think a lighter version of
          //  surface, but this is not directly available and has to be
          //  computed.
          blockquoteDecoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        onTapLink: (text, href, title) async {
          if (href == null) return;

          final Uri url = Uri.parse(href);
          final canLaunch = await canLaunchUrl(url);

          if (canLaunch) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Could not open link: $href')),
              );
            });
          }
        },
      ),
    );
  }
}
