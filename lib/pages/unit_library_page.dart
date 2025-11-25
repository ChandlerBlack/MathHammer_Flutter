import 'package:flutter/material.dart';
import 'package:mathhammer/pages/add_unit_page.dart';
import 'package:mathhammer/widgets/unit_card_base.dart';
import '../models/unit_stats.dart';

class UnitLibraryPage extends StatefulWidget{
  const UnitLibraryPage({super.key});

  @override
  State<UnitLibraryPage> createState() => _UnitLibraryPageState();  
}

// TODO: link to database to fetch all stored units
class _UnitLibraryPageState extends State<UnitLibraryPage> {
  // Dummy units for testing 
  final List<Unit> _dummyUnits = [
    Unit(
      id: 'lib1',
      name: 'Tactical Squad',
      movement: 6,
      toughness: 4,
      save: 3,
      wounds: 2,
      leadership: 6,
      objectiveControl: 2,
      modelCount: 10,
      rangedWeapons: [],
      meleeWeapons: [],
    ),
    Unit(
      id: 'lib2',
      name: 'Terminators',
      movement: 5,
      toughness: 5,
      save: 2,
      wounds: 3,
      leadership: 6,
      objectiveControl: 3,
      modelCount: 5,
      rangedWeapons: [],
      meleeWeapons: [],
    ),
    Unit(
      id: 'lib3',
      name: 'Dreadnought',
      movement: 8,
      toughness: 9,
      save: 2,
      wounds: 8,
      leadership: 6,
      objectiveControl: 4,
      modelCount: 1,
      rangedWeapons: [],
      meleeWeapons: [],
    ),
    Unit(
      id: 'lib4',
      name: 'Scout Squad',
      movement: 6,
      toughness: 4,
      save: 4,
      wounds: 1,
      leadership: 6,
      objectiveControl: 1,
      modelCount: 5,
      rangedWeapons: [],
      meleeWeapons: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Unit Library Page',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: _dummyUnits.length,
              itemBuilder: (context, index) => UnitCardBase(unit: _dummyUnits[index]),
            ),
          ),
        ],
      ),
    );
  }
}