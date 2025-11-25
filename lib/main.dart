
import 'package:flutter/material.dart';
import 'package:mathhammer/pages/settings_page.dart';
import 'package:mathhammer/widgets/unit_card_base.dart';
import 'pages/add_unit_page.dart';
import 'pages/unit_library_page.dart';
import 'pages/simulation_page.dart';
import 'pages/camera_page.dart';
import 'package:mathhammer/database/db.dart';

// Global TODO: 
// 1. Set up local database to store unit information using sqflite
// 2. Implement camera functionality to take pictures of units
// 3. Build out Add Unit Page form and camera preview
// 4. Improve Unit Library Page layout and functionality
// 5. Implement selection of units and running simulations between them
// 6. Implement settings page to adjust app preferences

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the database
  await initDatabase(); // Uncomment when database code is ready
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathHammer',
      theme: ThemeData.dark(),
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 1;

  // list of pages for bottom navigation
  final List<Widget> _pages = [
    AddUnitPage(),
    SimulationPage(),
    UnitLibraryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('MathHammer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),

              );
            }
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index), // also thanks Prof Henderson
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
      ),
      floatingActionButton: _fabBuilder(),
    );
    
  }

  // helper to handle the different FABs for each page 
  Widget? _fabBuilder() {
    switch (_selectedIndex) {
        case 1:
          return FloatingActionButton(
            child: const Icon(Icons.play_arrow),
            onPressed: () {
              null; // TODO: implement starting a simulation
            },
          );
        case 2:
          return FloatingActionButton( // Thanks for the idea Prof Henderson
            child: const Icon(Icons.add),
            onPressed: () {
              setState(() => _selectedIndex = 0);
            },
          );  
    }
  }
}
