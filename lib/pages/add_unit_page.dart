import 'package:flutter/material.dart';

class AddUnitPage extends StatefulWidget {
  const AddUnitPage({super.key});

  @override
  State<AddUnitPage> createState() => _AddUnitPageState();  

}

class _AddUnitPageState extends State<AddUnitPage> {
  @override
  Widget build(BuildContext context) {
    // TODO:
    /*
    Build out the Add Unit Page
     1. Form to add unit details (name, type, stats, etc.)
     2. Above the from, there needs to be a camera preview widget to take pictures of the unit
     3. Button to save the unit to the database
     4. Possibly a preview of the unit being added
    */ 
    return Center( child: Wrap( children: [
      Text("Add Unit Page")
    ]));
  }
}