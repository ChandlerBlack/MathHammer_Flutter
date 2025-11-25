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
        ],
      ),
      floatingActionButton: FloatingActionButton( // Thanks for the idea Prof Henderson
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/addUnit');
        },
      ),
    );
  }
}