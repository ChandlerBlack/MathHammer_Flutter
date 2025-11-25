// This widget is the forum for adding a new unit to the database that will be used in the add unit page.
import 'package:flutter/material.dart';
import 'package:mathhammer/pages/camera_page.dart';
class NewUnitForum extends StatelessWidget {
  const NewUnitForum({super.key});

  @override
  Widget build(BuildContext context) {
    return Center( 
      child: Column( 
        children: [
          Card ( // card above the form for camera preview
            child: Container( 
              width: 300,
              height: 200,
              color: Colors.grey,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Scaffold(
                        body: CameraPage(),
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
                ),
              ),
            )
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Unit Name',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Unit Stats',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Unit Abilities',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Unit Weapons',
            ),
          ),
        ]
      )
    );
  }
}