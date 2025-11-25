
import 'package:flutter/material.dart';
import 'package:mathhammer/pages/settings_page.dart';
import 'package:mathhammer/widgets/unit_card_base.dart';
import 'pages/add_unit_page.dart';
import 'pages/unit_library_page.dart';

// Global TODO: 
// 1. Set up local database to store unit information using sqflite
// 2. Implement camera functionality to take pictures of units
// 3. Build out Add Unit Page form and camera preview
// 4. Improve Unit Library Page layout and functionality
// 5. Implement selection of units and running simulations between them
// 6. Implement settings page to adjust app preferences

void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathHammer',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScaffold(title: 'MathHammer'),
        '/addUnit': (context) => MainScaffold(
          title: 'Add Unit',
          child: AddUnitPage(),
        ),
        '/library': (context) => MainScaffold(
          title: 'Unit Library',
          child: UnitLibraryPage(),
        ),
        '/settings': (context) => MainScaffold(
          title: 'Settings',
          child: SettingsPage(),
        ),
      },
    );
  }
}

class MainScaffold extends StatelessWidget {
  final Widget? child;
  final String title;

  const MainScaffold({super.key, this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).pushReplacementNamed('/settings'),
          ),
        ],
      ),
      body: child ?? _buildHomePage(context),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_add),
            label: 'Add Units',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle),
            label: 'Simulations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Unit Library',
          ),
        ],
        onTap: (index) => _onNavTap(context, index),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_circle_filled),
        onPressed: () {
          null; // TODO: implement simulation start
        },
      ),
    );
  }

  void _onNavTap(BuildContext context, int index) {
    final routes = ['/addUnit', '/', '/library'];
    if (routes[index] != null) {
      Navigator.of(context).pushReplacementNamed(routes[index]!);
    }
  }

  Widget _buildHomePage(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Welcome to MathHammer!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Expanded(
          child: GridView.builder( // display unit cards used in the current simulation, placeholder for now
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 2,
            itemBuilder: (context, index) => const UnitCardBase(),
          ),
        ),
      ],
    );
  }
}
