import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/models/notification.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/providers/friends_provider.dart';
import 'package:free_note/providers/notifications_provider.dart';
import 'package:free_note/widgets/add_button.dart';
import 'package:free_note/widgets/note_search_delegate.dart';
import 'package:free_note/widgets/overlays/calendar_list_overlay.dart';
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
                notes: provider.rootNotes
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
      child: SizedBox(height: 45, width: 45, child: AddNotePopupMenu()),
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
      child: SizedBox(height: 45, width: 45, child: NotificationPopupMenu()),
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
      child: IconButton(
        icon: Icon(Icons.notifications),
        onPressed: () => showPopover(
          context: context,
          bodyBuilder: (context) => AddNotifications(),
          //determine width and height
          //determine background colour
          height: 420,
          width: 300,
          backgroundColor: Colors.grey, //TODO: Change colour?
          direction: PopoverDirection.left,
          //TODO: Somehow make it outline to the left ish
        ),
      ),
    );
  }
}

class AddNotifications extends StatefulWidget {
  const AddNotifications({super.key});

  @override
  State<AddNotifications> createState() => _AddNotificationsState();
}

class _AddNotificationsState extends State<AddNotifications> {
  //TODO: Add changing icons if new notifications
  //TODO: Add Mark as read button

  @override
  Widget build(BuildContext context) {
    List<CustomNotification> notifications = context
        .watch<NotificationsProvider>()
        .notifications;

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        CustomNotification selectedNotification = notifications[index];
        var notificationType = notifications[index].type;
        var title = Text('Empty');
        String concat = selectedNotification.content;
        var tileColor = Colors.blueGrey;
        if (notificationType == NotificationType.fRequest) {
          concat =
              '${selectedNotification.sender?.username ?? "Someone"} has sent you a friendship request. Confirm?';
        }
        if (notificationType == NotificationType.fAccept) {
          concat =
              '${selectedNotification.sender?.username ?? "Someone"} has accepted your friend request.';
        }
        if (notificationType == NotificationType.systemMessage) {
          concat = 'System notification. Click to open!';
        }
        title = Text(concat);
        return ListTile(
          title: title,
          tileColor: tileColor, //TODO: Change to correct colour
          textColor: Colors.black,
          onTap: () {
            if (notificationType == NotificationType.fRequest) {
              openConfirmFriend(
                selectedNotification.sender!,
                selectedNotification.id,
              );
            } else if (notificationType == NotificationType.fAccept) {
              openAcceptFriend(selectedNotification.sender!);
            } else if (notificationType == NotificationType.systemMessage) {
              openSystemMessage(selectedNotification.content);
            }
          },
          //TODO: On tap make sure the tile gets returned to the backend as read
        );
      },
    );
  }

  Future openConfirmFriend(Profile user, int notificationId) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('${user.username} has requested to be friends!'),
      actions: [
        TextButton(
          child: Text('ACCEPT'),
          onPressed: () {
            context.read<FriendsProvider>().acceptFriendRequest(user);
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('DENY'),
          onPressed: () {
            context.read<FriendsProvider>().denyFriendRequest(user);
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );

  Future openAcceptFriend(Profile user) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('${user.username} has accepted your friend request!'),
      actions: [
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );

  Future openSystemMessage(String popupBody) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('System Message!'),
      content: Text(popupBody),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('CLOSE'),
        ),
      ],
    ),
  );
}
