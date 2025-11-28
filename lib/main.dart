
import 'package:flutter/material.dart';
import 'package:mathhammer/pages/settings_page.dart';
import 'package:mathhammer/models/unit_stats.dart';
import 'pages/add_unit_page.dart';
import 'pages/unit_library_page.dart';
import 'pages/simulation_page.dart';
import 'package:mathhammer/database/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDatabase(); 
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
  Unit? _selectedUnit1;
  Unit? _selectedUnit2;

  void _selectUnitForSimulation(Unit unit, int slot) {
    setState(() {
      if (slot == 1) {
        _selectedUnit1 = unit;
      } else if (slot == 2) {
        _selectedUnit2 = unit;
      }
    });
  }

  void _clearSimulationSlot(int slot) {
    setState(() {
      if (slot == 1) {
        _selectedUnit1 = null;
      } else if (slot == 2) {
        _selectedUnit2 = null;
      }
    });
  }

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // list of pages for bottom navigation
  List<Widget> get _pages => [
    AddUnitPage(),
    SimulationPage(
      unit1: _selectedUnit1,
      unit2: _selectedUnit2,
      onClearSlot: _clearSimulationSlot,
      onNavigateToLibrary: () => _navigateToPage(2),
    ),
    UnitLibraryPage(
      onSelectUnit: _selectUnitForSimulation,
      selectedUnit1: _selectedUnit1,
      selectedUnit2: _selectedUnit2,
      onNavigateToSimulation: () => _navigateToPage(1),
    ),
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
        default:
          return null;
    }
  }
}
