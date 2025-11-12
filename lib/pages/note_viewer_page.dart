import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteViewerPage extends StatefulWidget {
  final Note note;
  const NoteViewerPage({super.key, required this.note});

  @override
  State<NoteViewerPage> createState() => _NoteViewerPageState();
}

class _NoteViewerPageState extends State<NoteViewerPage> {
  final QuillController _controller = QuillController.basic();
  bool editing = false;

  @override
  void initState() {
    try {
      _controller.document = Document.fromJson(jsonDecode(widget.note.content));
    } on FormatException {
      logger.e('Unconverted note: "${widget.note.title}" (#${widget.note.id}), recovering as plaintext...');

      final delta = Delta();      
      delta.insert('${widget.note.content}\n');
      _controller.document = Document.fromDelta(delta);
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveDocument() async {
    logger.i('Saving note #${widget.note.id}');
    widget.note.content = jsonEncode(_controller.document.toDelta().toJson());
    context.read<NotesProvider>().saveNote(widget.note);
  }

  void _onBackNavigation(bool didPop, dynamic result) async {
    _saveDocument();
  }

  @override
  Widget build(BuildContext context) {    
    return PopScope(
      onPopInvokedWithResult: _onBackNavigation,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.note.title, 
            style: Theme.of(context).textTheme.titleLarge
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  editing = !editing;
                  _controller.readOnly = !editing;
                });
              },
              icon: Icon(
                editing 
                ? Icons.remove_red_eye 
                : Icons.edit
              ),
            ),
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: _buildNote(context),
      ),
    );
  }

  Widget _buildNote(BuildContext context) {
    if (editing) {
      return Column(
        children: [
          _buildToolbar(context),
          Expanded(
            child: _buildEditor(context)
          )
        ],
      );
    } else {
      return _buildEditor(context);
    }
  }

  Widget _buildToolbar(BuildContext context) {
    return QuillSimpleToolbar(
      controller: _controller,
      config: QuillSimpleToolbarConfig(
        toolbarIconAlignment: WrapAlignment.start,

        // Disabled some options to make the toolbar more concise. 
        // Could maybe be shown in "advanced mode" or something.
        showIndent: false,
        showSubscript: false,
        showSuperscript: false,
        showFontSize: false,
        showQuote: false,
        showInlineCode: false,
        showCodeBlock: false,
        showSearchButton: false,
      ),
    );
  }

  Widget _buildEditor(BuildContext context) {
    return QuillEditor.basic(
      controller: _controller,
      config: QuillEditorConfig(
        checkBoxReadOnly: false,
        onLaunchUrl: _onLaunhUrl
      ),
    );
  }

  void _onLaunhUrl(String href) async {
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
  }
}
