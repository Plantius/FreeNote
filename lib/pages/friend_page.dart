import 'package:flutter/material.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/providers/auth_provider.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {

  List<String> friends = ["Niels", "Niels2"];

    return Scaffold(
      appBar: AppBar(
        title: Text('Friends', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: FriendSearch());
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {

            }, 
            icon: Icon(Icons.person_add)),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(child: Text(friends[index][0]),),
              title: Text(friends[index]),
              subtitle: Text(''),
              trailing: Text(''),
              onLongPress: () {

              }
            );
          })
      )
    );
  }
}


class FriendSearch extends SearchDelegate {
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
