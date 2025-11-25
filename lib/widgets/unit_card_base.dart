// This widget creates a card that displays an image and name of a unit. that when tapped
// uses a hero animation to switch to a larger card that displays the full details of the unit.
// the full details card is implemented in unit_card_full.dart
import 'package:flutter/material.dart';
import 'unit_card_full.dart';

class UnitCardBase extends StatelessWidget {
  const UnitCardBase({super.key});



  @override
  Widget build(BuildContext context) {
    return Center( 
      child: Card( 
        color: const Color.fromARGB(255, 104, 173, 212) ,
        shadowColor: const Color.fromARGB(255, 72, 71, 71),
        elevation: 8,  
        child: InkWell( 
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: UnitCardFull(),
                ),
              ),
            );
          },
          child: SizedBox(
            width: double.infinity,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                // add a small image of the unit here 

                // trying out using the FadedInImage widget for loading images with a placeholder might be useful later
                // https://api.flutter.dev/flutter/widgets/FadeInImage-class.html
                FadeInImage(
                  placeholder: AssetImage('assets/images/placeholder.png'),
                  image: AssetImage('assets/images/placeholder.png'),
                  width: 100,
                  height: 100,
                ),
            
                // add the name of the unit here
                Text("Unit Name"),
              ]
            ),
          )
        )
      )
    );
  }
}