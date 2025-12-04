import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/widgets/create_button.dart';
import 'package:free_note/widgets/searchers/note_search_delegate.dart';
import 'package:free_note/widgets/notification_button.dart';
import 'package:free_note/widgets/overlays/calendar_list_overlay.dart';
import 'package:go_router/go_router.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  final Widget child;
  final String currentLocation;

  const MainPage({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        actions: [
          IconButton(
            onPressed: () {
              context.push('/friends');
            },
            icon: Icon(Icons.people),
          ),

          NotificationButton(),
          
          IconButton(
            onPressed: () {
              context.push('/profile');
            },
            icon: Icon(Icons.settings),
          ),
          
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) =>
                    CalendarListOverlay(allowSelection: false),
              );
            },
            icon: Icon(
              Icons.calendar_view_month,
            ), // This is not ideal, but I don't know where else to put the button
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.child
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SearchButton(),
              AddButton(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getLocationIndex(widget.currentLocation),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Notes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/notes');
              break;

            case 1:
              context.go('/calendar');
              break;

            default:
              debugPrint('Unmapped location index: $index');
              break;
          }
        },
        backgroundColor: colors.primary,

        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
      backgroundColor: colors.surface,
    );
  }

  int _getLocationIndex(String location) {
    switch (location) {
      case '/notes':
        return 0;

      case '/calendar':
        return 1;

      default:
        break;
    }

    debugPrint('Unmapped location specifier: $location');
    return 0;
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotesProvider>();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 45,
        width: 45,
        child: IconButton(
          onPressed: () async {
            final note = await showSearch<Note?>(
              context: context,
              delegate: NoteSearchDelegate(
                entries: provider.rootNotes
              ),
            );

            if (context.mounted && note != null) {
              context.push('/note/${note.id}');
            }
          },
          icon: const Icon(Icons.search),
        ),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 45, 
        width: 45, 
        child: CreateButton()
      ),
    );
  }
}
