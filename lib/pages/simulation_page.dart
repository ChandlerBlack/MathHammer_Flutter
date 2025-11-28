import 'package:flutter/material.dart';
import 'package:mathhammer/widgets/unit_card_base.dart';
import '../models/unit_stats.dart';

class SimulationPage extends StatelessWidget {
  final Unit? unit1;
  final Unit? unit2;
  final Function(int) onClearSlot;
  final VoidCallback onNavigateToLibrary;

  const SimulationPage({
    super.key,
    this.unit1,
    this.unit2,
    required this.onClearSlot,
    required this.onNavigateToLibrary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Simulation',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (unit1 != null || unit2 != null)
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    onClearSlot(1);
                    onClearSlot(2);
                  },
                ),
            ],
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.0, // Adjust this value to control card proportions (width/height)
            children: [
              _buildSlot(context, unit1, 1),
              _buildSlot(context, unit2, 2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSlot(BuildContext context, Unit? unit, int slotNumber) {
    if (unit == null) {
      return Card(
        margin: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: onNavigateToLibrary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 8),
              Text('Select Unit $slotNumber', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: UnitCardBase(unit: unit, onReturn: () {}),
    );
  }
}