import 'package:flutter/material.dart';
import 'package:free_note/providers/friends_provider.dart';
import 'package:free_note/widgets/profile_entry.dart';
import 'package:free_note/widgets/searchers/friend_search_delegate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FriendsProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Friends', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: FriendSearchDelegate(entries: provider.friends),
              );
            },
            icon: Icon(Icons.search),
          ),

          IconButton(
            onPressed: () {
              _openAddFriends();
            },
            icon: Icon(Icons.person_add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildFriendsList(context),
      ),
    );
  }

  Widget _buildFriendsList(BuildContext context) {
    return Consumer<FriendsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return RefreshIndicator(
            child: ListView.builder(
              itemCount: provider.friends.length,
              itemBuilder: (context, index) {
                return ProfileEntry(profile: provider.friends[index]);
              },
            ),
            onRefresh: () async {
              await provider.loadFriends();
            },
          );
        }
      },
    );
  }

  Future _openAddFriends() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: TextField(
        controller: _usernameController,
        decoration: InputDecoration(hintText: 'Enter username'),
      ),
      actions: [
        TextButton(
          autofocus: true,
          onPressed: _submitFriendRequest,
          child: Text('Send Request'),
        ),
      ],
    ),
  );

  Future<void> _submitFriendRequest() async {
    final provider = context.read<FriendsProvider>();
    final username = _usernameController.text.trim();

    final success = await provider.sendFriendRequest(username);

    if (mounted) {
      if (success) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sent friend request to $username!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not find user with name $username')),
        );
      }
    }
  }
}
