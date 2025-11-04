import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popover/popover.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String currentLocation;

  const AppScaffold({
    super.key, 
    required this.child, 
    required this.currentLocation
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FreeNote AppBar'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: 
        [Expanded(child: child),

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
        currentIndex: _getLocationIndex(currentLocation),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Notes',
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
      ),
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
              child: TextButton(
                onPressed: (){
                  //TODO: Write code here
                }, 
                child: Icon(Icons.search)),
            )
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
            )
          );
  }
}

class AddNotePopupMenu extends StatelessWidget {
  const AddNotePopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPopover(context: context, bodyBuilder: (context) => AddMenuItems(),
      width: 50,
      height: 135,
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
      children: [
        //1st Menu option
          TextButton(
            onPressed: (){
                  //TODO: Write code here
            }, 
            child: Icon(Icons.note)),

          //2nd menu option
          TextButton(
            onPressed: (){
                  //TODO: Write code here
            }, 
            child: Icon(Icons.audio_file)),

          //3rd menu option
          TextButton(
            onPressed: (){
                  //TODO: Write code here
            }, 
            child: Icon(Icons.timer)),

          //4th menu option
          TextButton(
            onPressed: (){
                  //TODO: Write code here
            }, 
            child: Icon(Icons.draw)),
      ],
    );
  }
}