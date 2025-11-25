import 'package:flutter/material.dart';
import 'package:mathhammer/widgets/unit_card_base.dart';
class SimulationPage extends StatelessWidget {
  const SimulationPage({super.key});

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