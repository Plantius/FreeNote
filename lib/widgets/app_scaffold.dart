import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';
import 'package:go_router/go_router.dart';
import 'package:popover/popover.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String currentLocation;

  const AppScaffold({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: colors.primary,
        actions: [
          IconButton(
            onPressed: () {
              context.push('/friends');
            },
            icon: Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              //context.push('/messages');
            },
            icon: Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {
              context.push('/profile');
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: child),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [SearchButton(), AddButton()],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getLocationIndex(currentLocation),
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

        // TODO: possibly use different colors for highlighting.
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 45,
        width: 45,
        child: IconButton(
          onPressed: () {
            showSearch(context: context, delegate: CustomSearchDelegate());
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
        /*child: TextButton(
                onPressed: (){
                  //TODO: Write code here
                }, 
                child: AddNotePopupMenu()),
                //child: Icon(Icons.search)),*/
        child: AddNotePopupMenu(),
      ),
    );
  }
}

class AddNotePopupMenu extends StatelessWidget {
  const AddNotePopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPopover(
        context: context,
        bodyBuilder: (context) => AddMenuItems(),
        // width: 50,
        height: 140,
        backgroundColor: Colors.deepPurple,
        direction: PopoverDirection.top,
      ),
      child: Icon(Icons.add),
    );
  }
}

class AddMenuItems extends StatelessWidget {
  const AddMenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //1st Menu option
        TextButton(
          onPressed: () {
            final note = Note(
              id: 0,
              title: 'New Note',
              content: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            context.push('/note/${note.id}', extra: note);
          },
          child: Icon(Icons.note, size: 30, color: Colors.white),
        ),

        //2nd menu option
        TextButton(
          onPressed: () {
            //TODO: Write code here
          },
          child: Icon(Icons.audio_file, size: 30, color: Colors.white),
        ),

        //3rd menu option
        TextButton(
          onPressed: () {
            //TODO: Write code here
          },
          child: Icon(Icons.timer, size: 30, color: Colors.white),
        ),

        //4th menu option
        TextButton(
          onPressed: () {
            //TODO: Write code here
          },
          child: Icon(Icons.draw, size: 30, color: Colors.white),
        ),
      ],
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    'Apple',
    'Banana',
    'Pear',
  ]; //TODO: Replace this list by what you pull from database!

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //TODO: Fix Search Function / make it more efficient
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(
            result,
          ), //returns the name as fruit as index tile on the found search answers
          //TODO: Potentially change what it shows, maybe show the context of the note too?
          //TODO: And then instead of "Text" it should probably be a textbutton that shows part of the thing and that as function opens the editor on that note
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(
            result,
          ), //returns the name as fruit as index tile on the found search answers
          //TODO: Potentially change what it shows, maybe show the context of the note too?
        );
      },
    );
  }
}
