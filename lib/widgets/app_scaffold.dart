import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FreeNote AppBar'),
        backgroundColor: colors.primary,
      ),
      body: child,
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
