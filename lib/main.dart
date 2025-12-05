
import 'package:flutter/material.dart';
import 'package:mathhammer/pages/settings_page.dart';
import 'package:mathhammer/models/unit_stats.dart';
import 'package:provider/provider.dart';
import 'pages/add_unit_page.dart';
import 'pages/unit_library_page.dart';
import 'pages/simulation_page.dart';
import 'package:mathhammer/database/db.dart';
import 'package:mathhammer/theme.dart';
import 'package:mathhammer/settings_manager.dart';


/*
  ToDo: 
  - Add sound effects (button clicks, simulation sounds)
  - Improve UI/UX (animations,custom icons, custom fonts)
  - implement sim 
 */


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDatabase(); 
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => SettingsManager()),
      ],
      child: const MyApp(),
    )
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return MaterialApp(
      title: 'MathHammer',
      theme: ThemeManager.lightTheme,
      darkTheme: ThemeManager.darkTheme,
      themeMode: themeManager.themeMode,
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
              if (_selectedUnit1 != null && _selectedUnit2 != null) {
                SnackBar(content: Text('Starting Simulation...'), backgroundColor: Colors.green, duration: Durations.short1,);
                // add call to sim 
              } else {
                SnackBar(content: Text('Please select two units for simulation.'), backgroundColor: Colors.red,);
              }
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
