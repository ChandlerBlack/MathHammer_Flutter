// This widget is the forum for adding a new unit to the database that will be used in the add unit page.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mathhammer/pages/camera_page.dart';
class NewUnitForum extends StatefulWidget {
  const NewUnitForum({super.key});

  @override
  State<NewUnitForum> createState() => _NewUnitForumState();
}

class _NewUnitForumState extends State<NewUnitForum> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _movementController = TextEditingController();
  final _toughnessController = TextEditingController();
  final _saveController = TextEditingController();
  final _woundsController = TextEditingController();
  final _leadershipController = TextEditingController();
  final _objectiveController = TextEditingController();
  final _modelController = TextEditingController();
  
  File? _imagefile;

  @override
  void dispose() {
    _nameController.dispose();
    _movementController.dispose();
    _toughnessController.dispose();
    _saveController.dispose();
    _woundsController.dispose();
    _leadershipController.dispose();
    _objectiveController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TODO: On tap of the image, open camera page to take picture
            Card(
              child: InkWell(
                onTap: () async {
                  // Navigate to camera page and await the result
                  final result = await Navigator.push<File?>(
                    context,
                    MaterialPageRoute(builder: (context) => const CameraPage()),
                  );
                  if (result != null) {
                    setState(() {
                      _imagefile = result;
                    });
                  }
                },
                child: _imagefile == null // if no image, show placeholder
                  ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(100.0),
                      child: Icon(Icons.image_not_supported_sharp, size: 100, color: Colors.grey),
                    ),
                  )
                  : Image.file(_imagefile!),
              ),
            ),

            // Unit Name
            _fieldBuilder('Unit Name:', _nameController),

            // grid of inputs for the stats
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // to prevent scrolling inside the form
              crossAxisCount: 3,
              childAspectRatio: 1.5, // to make the fields wider
              children: [
                _fieldBuilder('Movement', _movementController),
                _fieldBuilder('Toughness',  _toughnessController),
                _fieldBuilder('Save',  _saveController),
                _fieldBuilder('Wounds',  _woundsController),
                _fieldBuilder('Leadership',  _leadershipController),
                _fieldBuilder('Objective',  _objectiveController),
                _fieldBuilder('Models',  _modelController),
              ],
            ),
            const SizedBox(height: 16.0),
            // Save Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Save the unit
                }
                else {
                  // show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill out all required fields')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ]
        )
      )
    );
  }

  // helper widget to build a text form field
  Widget _fieldBuilder(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: controller == _nameController
          ? TextInputType.text
          : TextInputType.number, // found this, so that only numbers can be entered for all other fields
        validator: (value) => 
          value?.isEmpty ?? true ? 'Required $label' : null,
      ),
    );
  }
}