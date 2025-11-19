
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'pages/add_unit_page.dart';
import 'pages/unit_library_page.dart';

late final List<CameraDescription> _cameras;


// Global TODO: 
/*
1. Need to set up a local database to store unit information using sqflite
2. Need to implement camera functionality to take pictures of units
3. Need to build out the Add Unit Page form and camera preview
4. Need to improve the Unit Library Page layout and functionality
5. Need to implement the selection of units and running simulations between them
6. Need to implement the setting page to adjust app preferences
*/



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'MathHammer',
        theme: ThemeData.dark(),
        home: MainScaffold(title: 'MathHammer', child: PictureThis()),
        routes: {
          '/addUnit': (context) => MainScaffold(
              title: 'Add Unit',
              child: AddUnitPage()
          ),
          '/library': (context) => MainScaffold(
              title: 'Unit Library',
              child: UnitLibraryPage()
          ),
        }
    );
  }
}

class PictureThis extends StatelessWidget {
  const PictureThis();

  @override
  Widget build(BuildContext context) {
    return Center( child: Wrap( children: [
      Text("")
    ]));
  }
}

class MainScaffold extends StatelessWidget {

  final Widget child;
  final String title;

  MainScaffold({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
            ),
          ]
      ),
      body: Column(
        children: [
          /* TODO: need to add two sections for where the base cards of the two 
          selected units will go and if none are selected then display generic placeholder 
          cards 
          
          also need to add below this the area where the results of the sim
          will be displayed and 
          if no sim has been run yet then display a placeholder there as well
          */
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_add),
            label: 'Add Units',
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.play_circle),
            label: 'Run Sim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Unit Library',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed('/addUnit');
          } else if (index == 1) {
              null; // Placeholder for Run Sim action
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed('/library');
          }
        },
      ),
    );
  }
}
