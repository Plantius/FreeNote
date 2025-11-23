import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';
import 'package:go_router/go_router.dart';
import 'package:popover/popover.dart';
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
    final notesProvider = context.watch<NotesProvider>();

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
            icon: Icon(Icons.people),
          ),
          NotificationButton(),
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
          Expanded(child: widget.child),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SearchButton(
                searchTerms: notesProvider.notes,
              ), 
              AddButton()
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getLocationIndex(widget.currentLocation),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list), 
            label: 'Notes'
          ),
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

class SearchButton extends StatefulWidget {
  final List<Note> searchTerms;
  
  const SearchButton({super.key, required this.searchTerms});

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 45,
        width: 45,
        child: IconButton(
          onPressed: () {
            showSearch(context: context, delegate: CustomSearchDelegate(searchTerms: widget.searchTerms));
          },
          icon: const Icon(Icons.search),
        ),
      ),
    );
  }
}

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      //TODO: Figure out how to have it highlight on pressed
      padding: const EdgeInsets.all(1.0),
      child: SizedBox(
        height: 45,
        width: 45,
        child: NotificationPopupMenu(),
      ),
    );
  }
}

class NotificationPopupMenu extends StatelessWidget {
  //TODO: Add a thing that notifications icon changes
  //Depending on if there are new notifications
  //Listener to the backend?
  const NotificationPopupMenu({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPopover(
        context: context,
        bodyBuilder: (context) => AddNotifications(),
        //determine width and height
        //determine background colour
        height: 140,
        width: 300,
        backgroundColor: Colors.grey, //TODO: Change colour?
        direction: PopoverDirection.bottom,
        //TODO: Somehow make it outline to the left ish
        ),
        child: Icon(Icons.notifications)
    );
  }
}

class AddNotifications extends StatefulWidget {
  const AddNotifications({super.key});

  @override
  State<AddNotifications> createState() => _AddNotificationsState();
}

class _AddNotificationsState extends State<AddNotifications> {
  List<String> notifications = ["Notif1", "Notif2", "Notif3", "Notif4", "Notif5"];
  List<int> notificationTypes = [0,1,2,3,4];
  List<bool> notificationRead = [true, false, false, true, false];
  //0 = Friend Request (incoming) (popup with accept or deny)
  ////1 = X has accepted your friend request
  //2 = Announcement / System Message (Popup)
  //3 > Above, unimplemented, should default to 1 now.

  //TODO: Add changing icons if new notifications
  //TODO: Add Mark as read button

  //TODO: Ideally this should be grabbed from backend
  @override
  Widget build(BuildContext context) {
    //TODO:: Some calculations in here?
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        var selectedNotification = notifications[index];
        var notificationType = notificationTypes[index];
        var title = Text(selectedNotification);
        var subtitle = Text(selectedNotification);
        var tileColor = Colors.blueGrey;
        if(notificationRead[index] == false) {
          tileColor = Colors.amber; //TODO: Change colours
        }
        if(notificationType == 0) {

        }
        if(notificationType == 1) {

        }
        if(notificationType == 2) {

        }
        return ListTile(
          title: title,
          subtitle: subtitle,
          tileColor: tileColor, //TODO: Change to correct colour
          textColor: Colors.black,
          //TODO: On tap make sure the tile gets returned to the backend as read
        );
      },
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
  List<Note> searchTerms;
  List<String> noteTitles = [];
  List<String> noteBodies = [];

  bool titlesPopulated = false;

  void populateTitles() {
    if(!titlesPopulated) {
      titlesPopulated = true;
      noteTitles = [];
      for(var terms in searchTerms) {
        noteTitles.add(terms.title);
        noteBodies.add(terms.content);
      }
    }
  }

  CustomSearchDelegate({required this.searchTerms});

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
    populateTitles();
    List<String> bodyBuilding = [];
    List<Note> matchedNote = [];
    for(var fruit in searchTerms) {
      bool addMatch = false;
      if (fruit.title.toLowerCase().contains(query.toLowerCase())) {
        addMatch = true;
      }
      else if(fruit.content.toLowerCase().contains(query.toLowerCase())) {
        addMatch = true;
      }
      if(addMatch) {
        matchedNote.add(fruit);
        //TODO: Ideally grab the part where it matches the query.. and remove newlines?
        if(fruit.content.length > 256)
        {
          bodyBuilding.add(fruit.content.substring(0, 256));
        }
        else
        {
          bodyBuilding.add(fruit.content); //TODO: Test case where body is empty string? does it still get added?
        }
      }
    }
    return ListView.builder(
      itemCount: matchedNote.length,
      itemBuilder: (context, index) {
        var result = matchedNote[index].title;
        var resultbody = bodyBuilding[index];
        var resultid = matchedNote[index].id;
        var resultfruit = matchedNote[index];
        return ListTile(
          leading: Icon(Icons.note), //TODO: Should be corresponding to the note type
          subtitle: Text(resultbody), //TODO: Text should be the first 
          onTap: () {
            context.push('/note/$resultid', extra: resultfruit);
          },
          title: Text(
            result,
          ), //returns the name as fruit as index tile on the found search answers
          //TODO: Potentially change what it shows, maybe show the context of the note too?
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    populateTitles();
    List<String> bodyBuilding = [];
    List<Note> matchedNote = [];
    for(var fruit in searchTerms) {
      bool addMatch = false;
      if (fruit.title.toLowerCase().contains(query.toLowerCase())) {
        addMatch = true;
      }
      else if(fruit.content.toLowerCase().contains(query.toLowerCase())) {
        addMatch = true;
      }
      if(addMatch) {
        matchedNote.add(fruit);
        //TODO: Ideally grab the part where it matches the query.. and remove newlines?
        if(fruit.content.length > 256)
        {
          bodyBuilding.add(fruit.content.substring(0, 256));
        }
        else
        {
          bodyBuilding.add(fruit.content); //TODO: Test case where body is empty string? does it still get added?
        }
      }
    }
    return ListView.builder(
      itemCount: matchedNote.length,
      itemBuilder: (context, index) {
        var result = matchedNote[index].title;
        var resultbody = bodyBuilding[index];
        var resultid = matchedNote[index].id;
        var resultfruit = matchedNote[index];
        return ListTile(
          leading: Icon(Icons.note), //TODO: Should be corresponding to the note type
          subtitle: Text(resultbody), //TODO: Text should be the first 
          onTap: () {
            context.push('/note/$resultid', extra: resultfruit);
          },
          title: Text(
            result,
          ), //returns the name as fruit as index tile on the found search answers
          //TODO: Potentially change what it shows, maybe show the context of the note too?
        );
      },
    );
  }
}
