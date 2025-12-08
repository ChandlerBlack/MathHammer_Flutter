// This widget creates a card that displays an image and name of a unit. that when tapped
// uses a hero animation to switch to a larger card that displays the full details of the unit.
// the full details card is implemented in unit_card_full.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'unit_card_full.dart';
import '../models/unit_stats.dart';

class UnitCardBase extends StatelessWidget {
  final Unit? unit;
  final VoidCallback? onReturn;
  final Function(Unit, int)? onSelectForSimulation;
  final Unit? selectedUnit1;
  final Unit? selectedUnit2;
  final VoidCallback? onNavigateToSimulation;

  const UnitCardBase({
    super.key,
    this.unit,
    required this.onReturn,
    this.onSelectForSimulation,
    this.selectedUnit1,
    this.selectedUnit2,
    this.onNavigateToSimulation,
  });


  @override
  Widget build(BuildContext context) {
    if (unit == null) {
      return Card(
        child: Center(
          child: Text('No Unit Data', style: TextStyle(fontSize: 18, color: Colors.red)),
        ),
      );
    }
    return Card(
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UnitCardFull(
                unit: unit!,
                onSelectForSimulation: onSelectForSimulation,
                selectedUnit1: selectedUnit1,
                selectedUnit2: selectedUnit2,
                onNavigateToSimulation: onNavigateToSimulation,
              ),
            ),
          );
          if (result == true && onReturn != null) {
            onReturn!();
          }
        },
        child: Hero(
          tag: 'unit_${unit!.name}',
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[300],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: unit!.imagePath != null
                          ? Image.file(
                              File(unit!.imagePath!),
                              fit: BoxFit.cover,
                          )
                        : Icon(Icons.image_not_supported_rounded, size: 120, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      unit!.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                ),
                ],
              ),
            ),
          ),
        ),
      )
    );

  }
}