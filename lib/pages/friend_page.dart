import 'package:flutter/material.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/providers/friends_provider.dart';
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
    final friendProvider = context.watch<FriendsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: FriendSearch(searchTerms: friendProvider.friends),
              );
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              openAddFriends();
            },
            icon: Icon(Icons.person_add),
          ),
        ],
      ),
      body: _buildFriendsList(context),
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
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      provider.friends[index].username
                          .substring(0, 1)
                          .toUpperCase(),
                    ),
                  ),
                  title: Text(provider.friends[index].username),
                  subtitle: Text(provider.friends[index].email),
                  trailing: Text(''),
                  onLongPress: () {},
                );
              },
            ),
            onRefresh: () async {
              await provider.loadFriends(forceRefresh: true);
            },
          );
        }
      },
    );
  }

  Future openAddFriends() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: TextField(
        controller: _usernameController,
        decoration: InputDecoration(hintText: 'Enter username'),
      ),
      actions: [
        TextButton(
          autofocus: true,
          onPressed: submitFriendRequest,
          child: Text('Send Request'),
        ),
      ],
    ),
  );

  Future<void> submitFriendRequest() async {
    final friendProvider = context.read<FriendsProvider>();
    final username = _usernameController.text.trim();

    final success = await friendProvider.sendFriendRequest(username);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
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

class FriendSearch extends SearchDelegate {
  final List<Profile> searchTerms;

  FriendSearch({required this.searchTerms});

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
    List<Profile> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.username.contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(
            result.username,
          ), //returns the name as fruit as index tile on the found search answers
          //TODO: Potentially change what it shows, maybe show the context of the note too?
          //TODO: And then instead of "Text" it should probably be a textbutton that shows part of the thing and that as function opens the editor on that note
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Profile> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.username.contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(
            result.username,
          ), //returns the name as fruit as index tile on the found search answers
          //TODO: Potentially change what it shows, maybe show the context of the note too?
          //TODO: And then instead of "Text" it should probably be a textbutton that shows part of the thing and that as function opens the editor on that note
        );
      },
    );
  }
}
