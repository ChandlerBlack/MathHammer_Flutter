// This widget creates a card that displays an image and name of a unit. that when tapped
// uses a hero animation to switch to a larger card that displays the full details of the unit.
// the full details card is implemented in unit_card_full.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'unit_card_full.dart';
import '../models/unit_stats.dart';

class UnitCardBase extends StatelessWidget {
  final Unit? unit;

  const UnitCardBase({super.key, this.unit});


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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UnitCardFull(),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            unit!.imagePath != null
                ? Image.file(File(unit!.imagePath!), height: 100)
                : Icon(Icons.image_not_supported_rounded, size: 100, color: Colors.grey),
            const SizedBox(height: 8),
            Text(unit!.name, style: Theme.of(context).textTheme.titleMedium),
          ]
        )
      )
    );

  }
}