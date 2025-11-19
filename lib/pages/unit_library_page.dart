import 'package:flutter/material.dart';

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
          Text("Unit Library Page"),
          FloatingActionButton( // TODO: need to move this to the bottom right corner
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/addUnit');
            },
          ),
        ],
      )
    );
  }
}