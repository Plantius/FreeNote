import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:free_note/widgets/confirm_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteViewerPage extends StatefulWidget {
  final Note? note;
  final int noteId;

  const NoteViewerPage({super.key, required this.note, required this.noteId});

  @override
  State<NoteViewerPage> createState() => _NoteViewerPageState();
}

class _NoteViewerPageState extends State<NoteViewerPage> {
  late TextEditingController _titleController = TextEditingController();
  final QuillController _controller = QuillController.basic();
  final _focusNode = FocusNode();
  Note? note;

  // NOTE: It would be nicer to start in viewing mode, but links don't work
  // in that case, but do work when switching back from editing mode, for some
  // reason.
  bool editing = true;

  int _savedStateHash = 0;

  @override
  void initState() {
    _loadDocument();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _loadDocument() async {
    if (widget.note == null) {
      final notes = context.read<NotesProvider>();
      Note? loadedNote = await notes.loadNote(widget.noteId);
      if (loadedNote != null) {
        note = loadedNote;
      } else {
        if (mounted) {
          context.go('/notes');
        }
      }
    } else {
      note = widget.note!;
    }

    try {
      setState(() {
        final json = jsonDecode(note!.content);
        _controller.document = Document.fromJson(json);
      });
    } on FormatException {
      logger.e(
        'Unconverted note: "${note!.title}" (#${note!.id}), recovering as plaintext...',
      );

      setState(() {
        final delta = Delta();
        delta.insert('${note!.content}\n');
        _controller.document = Document.fromDelta(delta);
      });
    }

    _titleController.text = note!.title;
    _savedStateHash = _controller.document.toDelta().hashCode;
  }

  void _saveDocument() async {
    if (note == null) {
      return;
    }

    logger.i('Saving note #${note!.id}');

    final delta = _controller.document.toDelta();
    int hashCode = delta.hashCode;

    if (_hasUnsavedChanges(deltaHashCode: hashCode)) {
      note!.title = _titleController.text;
      note!.content = jsonEncode(delta.toJson());

      context.read<NotesProvider>().saveNote(note!);

      _savedStateHash = hashCode;
    } else {
      logger.i('Note is already up-to-date');
    }
  }

  bool _hasUnsavedChanges({int? deltaHashCode}) {
    deltaHashCode ??= _controller.document.toDelta().hashCode;

    if (deltaHashCode != _savedStateHash) {
      return true;
    }

    return (note?.title ?? '') != _titleController.text;
  }

  Future<void> _onBackNavigation(bool didPop, dynamic result) async {
    if (!didPop) {
      if (!_hasUnsavedChanges()) {
        context.pop();
      } else {
        bool? pop = await showDialog<bool?>(
          context: context,
          builder: (context) {
            return ConfirmDialog(
              text: 'You have unsaved changes. Discard these?',
            );
          },
        );

        if (mounted && (pop ?? false)) {
          context.pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onBackNavigation,
      child: Scaffold(
        appBar: AppBar(
          title: note == null
              ? Text(
                  'Loading...',
                  style: Theme.of(context).textTheme.titleLarge,
                )
              : TextField(
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Title',
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[\r\n]')),
                  ],
                ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  editing = !editing;
                  _controller.readOnly = !editing;
                });
              },
              icon: Icon(editing ? Icons.remove_red_eye : Icons.edit),
            ),
            IconButton(onPressed: _saveDocument, icon: const Icon(Icons.save)),
            IconButton(
              onPressed: note == null
                  ? null
                  : () {
                      context.push('/note/${note!.id}/options', extra: note!);
                    },
              icon: const Icon(Icons.menu),
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
          Expanded(child: _buildEditor(context)),
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

        customButtons: [
          QuillToolbarCustomButtonOptions(
            icon: const Icon(Icons.note_add),
            onPressed: _insertNoteLink,
          ),
        ],

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
        showDividers: false,
      ),
    );
  }

  Widget _buildEditor(BuildContext context) {
    return QuillEditor.basic(
      controller: _controller,
      focusNode: _focusNode,
      config: QuillEditorConfig(
        checkBoxReadOnly: false,
        onLaunchUrl: (href) => _onLaunchUrl(context, href),
        customLinkPrefixes: ['freenote'],
        autoFocus: true,
      ),
    );
  }

  void _insertNoteLink() async {
    final delta = Delta()..insert('(link)', {'link': 'freenote:///note/34'});

    final selection = TextSelection(
      baseOffset: _controller.selection.baseOffset,
      extentOffset: _controller.selection.extentOffset,
    );

    _controller.replaceText(
      selection.baseOffset,
      selection.extentOffset - selection.baseOffset,
      delta,
      selection,
    );

    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _onLaunchUrl(BuildContext context, String href) async {
    logger.i('Attempting to navigate to `$href`...');

    final Uri url = Uri.parse(href);

    if (url.scheme == 'freenote') {
      if (mounted) {
        context.push(url.path);
      }
    } else {
      final canLaunch = await canLaunchUrl(url);

      if (canLaunch) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not open link: $href')));
        });
      }
    }
  }
}
