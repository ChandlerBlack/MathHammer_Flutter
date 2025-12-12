import 'package:flutter/material.dart';
import 'package:mathhammer/pages/settings_page.dart';
import 'package:mathhammer/models/unit_stats.dart';
import 'package:provider/provider.dart';
import 'pages/add_unit_page.dart';
import 'pages/unit_library_page.dart';
import 'pages/simulation_page.dart';
import 'package:mathhammer/database/db.dart';
import 'package:mathhammer/theme/theme.dart';
import 'package:mathhammer/theme/settings_manager.dart';
import 'package:flutter/services.dart';


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
      theme: themeManager.lightTheme,
      darkTheme: themeManager.darkTheme,
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
        onTap: (index) {
          setState(() => _selectedIndex = index);
          HapticFeedback.heavyImpact();
        },   
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

  Widget? _fabBuilder() {
    switch (_selectedIndex) { // kept switch in case i want to add more fabs later
        case 2:
          return FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () { // thanks for the idea Prof Henderson
              setState(() => _selectedIndex = 0);
              HapticFeedback.heavyImpact();
            },
          );
        default:
          return null;
    }
  }
}