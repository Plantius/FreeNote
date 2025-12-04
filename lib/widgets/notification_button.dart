import 'package:flutter/material.dart';
import 'package:free_note/models/notification.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/providers/friends_provider.dart';
import 'package:free_note/providers/notifications_provider.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: IconButton(
        icon: Icon(Icons.notifications),
        onPressed: () => showPopover(
          context: context,
          bodyBuilder: (context) => NotificationPopOver(),
          height: 420,
          width: 300,
          backgroundColor: Theme.of(context).colorScheme.primary,
          direction: PopoverDirection.left,
        ),
      ),
    );
  }
}

class NotificationPopOver extends StatefulWidget {
  const NotificationPopOver({super.key});

  @override
  State<NotificationPopOver> createState() => _NotificationPopOverState();
}

class _NotificationPopOverState extends State<NotificationPopOver> {
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
