import 'package:flutter/material.dart';
import 'package:mathhammer/widgets/unit_card_base.dart';
import '../models/unit_stats.dart';

class SimulationPage extends StatelessWidget {
  const SimulationPage({super.key});

  // Dummy units for testing
  static final List<Unit> _dummyUnits = [
    Unit(
      id: 'test1',
      name: 'Space Marine',
      movement: 6,
      toughness: 4,
      save: 3,
      wounds: 2,
      leadership: 6,
      objectiveControl: 2,
      modelCount: 5,
      rangedWeapons: [],
      meleeWeapons: [],
    ),
    Unit(
      id: 'test2',
      name: 'Ork Boyz',
      movement: 5,
      toughness: 5,
      save: 6,
      wounds: 1,
      leadership: 7,
      objectiveControl: 1,
      modelCount: 10,
      rangedWeapons: [],
      meleeWeapons: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Simulation Page',
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
    );
  }
}