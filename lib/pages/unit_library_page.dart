import 'package:flutter/material.dart';
import 'package:mathhammer/pages/add_unit_page.dart';
import 'package:mathhammer/widgets/unit_card_base.dart';

class UnitLibraryPage extends StatefulWidget{
  const UnitLibraryPage({super.key});

  @override
  State<UnitLibraryPage> createState() => _UnitLibraryPageState();  
}

class _UnitLibraryPageState extends State<UnitLibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Unit Library Page',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Expanded(
            child: GridView.builder( // display all unit cards in the library, placeholder for now
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: 4,
              itemBuilder: (context, index) => const UnitCardBase(),
            ),
          ),
        ],
      ),
    );
 
  }



}