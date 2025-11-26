// This widget creates a card that displays the full details of a unit.
// It is used in conjunction with unit_card_base.dart to provide a hero animation
// when transitioning from the base card to the full details card.
import 'package:flutter/material.dart';
import '../models/unit_stats.dart';
import 'dart:io';
class UnitCardFull extends StatelessWidget {
  const UnitCardFull({super.key, required this.unit});

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(unit.name),
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
                      unit.imagePath != null
                          ? Image.file(File(unit.imagePath!), height: 300, fit: BoxFit.contain)
                          : Icon(Icons.image_not_supported_rounded, size: 200, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(unit.name, style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              // a lot of this will be changed when the database is hooked up
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Movement: ${unit.movement}"', style: Theme.of(context).textTheme.titleMedium),
                  Text('Toughness: ${unit.toughness}', style: Theme.of(context).textTheme.titleMedium),
                  Text('Save: ${unit.save}+', style: Theme.of(context).textTheme.titleMedium),
                  Text('Wounds: ${unit.wounds}', style: Theme.of(context).textTheme.titleMedium),
                  Text('Leadership: ${unit.leadership}', style: Theme.of(context).textTheme.titleMedium),
                  Text('Objective Control: ${unit.objectiveControl}', style: Theme.of(context).textTheme.titleMedium),
                  Text('Model Count: ${unit.modelCount}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  // TODO: Add weapon stats, abilities, etc.
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}