import 'package:flutter/material.dart';
import 'package:mathhammer/widgets/unit_card_base.dart';
import '../models/unit_stats.dart';
import '../database/db.dart';
import 'package:provider/provider.dart';
import '../theme/settings_manager.dart';

class UnitLibraryPage extends StatefulWidget{
  final Function(Unit, int)? onSelectUnit;
  final Unit? selectedUnit1;
  final Unit? selectedUnit2;
  final VoidCallback? onNavigateToSimulation;

  const UnitLibraryPage({
    super.key,
    this.onSelectUnit,
    this.selectedUnit1,
    this.selectedUnit2,
    this.onNavigateToSimulation,
  });

  @override
  State<UnitLibraryPage> createState() => _UnitLibraryPageState();  
}

class _UnitLibraryPageState extends State<UnitLibraryPage> {
  void _refreshUnits() async {
    setState(() {});
  }

  Future<List<Unit>> _getUnits() async {
    final settingsManager = Provider.of<SettingsManager>(context, listen: false);
    if (settingsManager.isAlphabetical) {
      return getUnitsAlphabetical();
    } else {
      return getUnitsReverseAlphabetical();

    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsManager = Provider.of<SettingsManager>(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Unit Library',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _refreshUnits,
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Unit>>(
              key: ValueKey(settingsManager.sortOrder),
              future: _getUnits(),
              builder:(context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) { // waiting for units
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) { // error getting units
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Error loading units.'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _refreshUnits,
                          child: const Text('Retry'),
                        ),
                      ],
                    )
                  );
                } 
                if (!snapshot.hasData || snapshot.data!.isEmpty) { // no units found
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.library_books_outlined, size: 80, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('No units found'),
                        const SizedBox(height: 8),
                        const Text('Add some new units to get started!'),
                      ],
                    )
                  );
                }

                final units = snapshot.data!;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: units.length,
                  itemBuilder: (context, index) => UnitCardBase(
                    unit: units[index],
                    onReturn: _refreshUnits,
                    onSelectForSimulation: widget.onSelectUnit,
                    selectedUnit1: widget.selectedUnit1,
                    selectedUnit2: widget.selectedUnit2,
                    onNavigateToSimulation: widget.onNavigateToSimulation,
                  ),
                );
              },
            )
          ),
        ],
      ),
    );
  }
}