import 'package:flutter/material.dart';
import 'package:mathhammer/widgets/new_unit%20_forum.dart';

class AddUnitPage extends StatefulWidget {
  const AddUnitPage({super.key});

  @override
  State<AddUnitPage> createState() => _AddUnitPageState();  

}

class _AddUnitPageState extends State<AddUnitPage> {
  @override
  Widget build(BuildContext context) {
    return Center( 
      child: Wrap( 
        children: [
          NewUnitForum()
        ]
      )
    );
  }
}