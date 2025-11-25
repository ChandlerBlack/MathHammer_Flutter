// This widget creates a card that displays the full details of a unit.
// It is used in conjunction with unit_card_base.dart to provide a hero animation
// when transitioning from the base card to the full details card.
import 'package:flutter/material.dart';
class UnitCardFull extends StatelessWidget {
  const UnitCardFull({super.key});

  @override
  Widget build(BuildContext context) {
    return Center( 
      child: Card( 
        child: Wrap( 
          children: [
            // add a larger image of the unit here 

            // add the name of the unit here
            Text("Unit Name - Full Details"),

            // add more details about the unit here
            Text("Unit Stats: ..."),
            Text("Unit Abilities: ..."),
            Text("Unit Weapons: ..."),
          ]
        )
      )
    );
  }
}