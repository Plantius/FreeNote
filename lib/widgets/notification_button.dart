import 'package:flutter/material.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/providers/friends_provider.dart';
import 'package:free_note/providers/notifications_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();

    return GestureDetector(
      child: IconButton(
        icon: Icon(
          provider.notifications.isEmpty
              ? Icons.notifications_none
              : Icons.notifications_active,
        ),
        onPressed: () => showPopover(
          context: context,
          bodyBuilder: (context) => NotificationPopOver(),
          height: 420,
          width: 300,
          backgroundColor: Theme.of(context).colorScheme.surface,
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
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();
    final notifications = provider.notifications;

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final sender = notification.sender?.username ?? 'Someone';

        return ListTile(
          title: Text('"$sender" has sent you a friend request. Confirm?'),

          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
          ),

          textColor: Colors.white,

          onTap: () {
            _openConfirmFriend(provider, notification.sender!, notification.id);
          },
        );
      },
    );
  }

  Future<void> _openConfirmFriend(
    NotificationsProvider provider,
    Profile user,
    int notificationId,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Accept friend request from "${user.username}"?'),
        actions: [
          TextButton(
            child: Text('Deny'),
            onPressed: () {
              context.read<FriendsProvider>().denyFriendRequest(user);
              context.pop();
            },
          ),

          TextButton(
            child: Text('Accept'),
            onPressed: () {
              context.read<FriendsProvider>().acceptFriendRequest(user);
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
