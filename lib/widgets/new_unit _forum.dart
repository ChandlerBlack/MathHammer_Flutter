// This widget is the forum for adding a new unit to the database that will be used in the add unit page.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mathhammer/pages/camera_page.dart';
import '../database/db.dart';
import '../models/unit_stats.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/settings_manager.dart';



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
  final _invulnController = TextEditingController(text: '7');

  var random = Random();

  
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
    _invulnController.dispose();
    super.dispose();
  }

  int generateId() {
    return random.nextInt(100000);
  }

  static final List<ap.AudioPlayer> _lowLatencyPlayers = []; // all this is to allow multiple sounds to play at once
  static const int _maxLowLatencyPlayers = 5;
  static int _currentPlayerIndex = 0;

  static Future<ap.AudioPlayer> _getLowLatencyPlayer() async {
    if (_lowLatencyPlayers.length < _maxLowLatencyPlayers) {
      final newPlayer = ap.AudioPlayer();
      _lowLatencyPlayers.add(newPlayer);
      return newPlayer;
    }
    // If all players are busy, return the next one in the list
    final player = _lowLatencyPlayers[_currentPlayerIndex];
    _currentPlayerIndex = (_currentPlayerIndex + 1) % _maxLowLatencyPlayers; 
    return player;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: Card(
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
                    HapticFeedback.heavyImpact();
                  },
                  child: _imagefile == null // if no image, show placeholder
                    ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(80.0),
                        child: Column(
                          children: [
                            Icon(Icons.image_not_supported_sharp, size: 100, color: Colors.grey),
                            Text('Tap to add image', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    )
                    : Image.file(_imagefile!),
                ),
              ),
            ),


            // Unit Name
            _fieldBuilder('Unit Name:', _nameController),

            // grid of inputs for the stats
            GridView.count(
              shrinkWrap: true,
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
                _fieldBuilder('Invuln Save', _invulnController),
              ],
            ),
            const SizedBox(height: 16.0),
            // Save Button
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final newUnit = Unit(
                      id: generateId().toString(),
                      name: _nameController.text,
                      movement: int.parse(_movementController.text),
                      toughness: int.parse(_toughnessController.text),
                      save: int.parse(_saveController.text),
                      wounds: int.parse(_woundsController.text),
                      leadership: int.parse(_leadershipController.text),
                      objectiveControl: int.parse(_objectiveController.text),
                      modelCount: int.parse(_modelController.text),
                      imagePath: _imagefile?.path,
                    );
                    
                    await insertUnit(newUnit);

                    if (context.mounted) {
                      // successful save
                      ScaffoldMessenger.of(context).showSnackBar( 
                        const SnackBar(
                        content: Text('Unit saved successfully'),
                        duration: Duration(milliseconds: 700),
                        backgroundColor: Colors.green,
                      ));

                      // clear the form
                      _formKey.currentState!.reset();
                      setState(() {
                        _imagefile = null;
                      });
                      final settingsManager = Provider.of<SettingsManager>(context, listen: false);
                      if (settingsManager.soundEnabled) {
                        _getLowLatencyPlayer().then((player) => player.play(ap.AssetSource('sounds/Objective achieved.mp3')));
                      }
                    }
                  } catch (e) {
                    // show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error saving unit: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(milliseconds: 700),
                      ),
                    );
                  }
                }
                else {
                  // show error message
                  final settingsManager = Provider.of<SettingsManager>(context, listen: false);
                  if (settingsManager.soundEnabled) {
                    _getLowLatencyPlayer().then((player) => player.play(ap.AssetSource('sounds/Awaiting orders.mp3')));
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill out all required fields'),
                      backgroundColor: Colors.red,
                      duration: const Duration(milliseconds: 700),
                    ),
                  );
                }
                HapticFeedback.heavyImpact();

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