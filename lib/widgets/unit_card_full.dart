// This widget creates a card that displays the full details of a unit.
// It is used in conjunction with unit_card_base.dart to provide a hero animation
// when transitioning from the base card to the full details card.
import 'package:flutter/material.dart';
import '../models/unit_stats.dart';
import 'dart:io';
import '../database/db.dart';
class UnitCardFull extends StatelessWidget {
  final Unit unit;
  final Function(Unit, int)? onSelectForSimulation;
  final Unit? selectedUnit1;
  final Unit? selectedUnit2;
  final VoidCallback? onNavigateToSimulation;

  const UnitCardFull({
    super.key,
    required this.unit,
    this.onSelectForSimulation,
    this.selectedUnit1,
    this.selectedUnit2,
    this.onNavigateToSimulation,
  });

  Future<void> _showSlotSelectionDialog(BuildContext context) async {
    final int? selectedSlot = await showDialog<int>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select Slot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.filter_1),
                title: Text('Slot 1 ${selectedUnit1 != null ? "(${selectedUnit1!.name})" : "(Empty)"}'),
                onTap: () => Navigator.of(dialogContext).pop(1),
              ),
              ListTile(
                leading: const Icon(Icons.filter_2),
                title: Text('Slot 2 ${selectedUnit2 != null ? "(${selectedUnit2!.name})" : "(Empty)"}'),
                onTap: () => Navigator.of(dialogContext).pop(2),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (selectedSlot != null && context.mounted) {
      onSelectForSimulation!(unit, selectedSlot);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${unit.name} added to Slot $selectedSlot'),
          duration: const Duration(seconds: 1),
        ),
      );
      
      if (onNavigateToSimulation != null) {
        Navigator.of(context).pop();
        onNavigateToSimulation!();
      }
    }
  }

  Future<void> _deleteConfirmation(BuildContext context) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Unit'),
          content: Text('Are you sure you want to delete ${unit.name}? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed:() => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed:() => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (shouldDelete == true && context.mounted) {
      try {
        await deleteUnit(unit.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${unit.name} has been deleted.'),
              duration: const Duration(milliseconds: 700),
            ),
          );
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting unit: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(unit.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'unit_${unit.name}',
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: unit.imagePath != null
                            ? Image.file(File(unit.imagePath!), height: 250, width: 250, fit: BoxFit.contain)
                            : Icon(Icons.image_not_supported_sharp, size: 250, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        unit.name,
                        style: Theme.of(context).textTheme.headlineLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Movement: ${unit.movement}"', style: Theme.of(context).textTheme.titleMedium),
                  Text('Toughness: ${unit.toughness}', style: Theme.of(context).textTheme.titleMedium),
                  Text('Save: ${unit.save}+', style: Theme.of(context).textTheme.titleMedium),
                  Text('Invulnerable Save: ${unit.invulnerableSave}+', style: Theme.of(context).textTheme.titleMedium),
                  Text('Wounds: ${unit.wounds}', style: Theme.of(context).textTheme.titleMedium),
                  Text('Leadership: ${unit.leadership}', style: Theme.of(context).textTheme.titleMedium),
                  Text('Objective Control: ${unit.objectiveControl}', style: Theme.of(context).textTheme.titleMedium),
                  Text('Model Count: ${unit.modelCount}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            ElevatedButton( // add unit to simulation screen
              onPressed: () => _showSlotSelectionDialog(context), 
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                textStyle: const TextStyle(fontSize: 18),
              ), child:   const Text('Select for Simulation'),
            ),
          ],
        ),
      ),
    );
  }
}