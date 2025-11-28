import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}


// need to have settings to adjust app preferences
//  1. Theme (light/dark)
//  2. Library sorting options
//  3. App sound settings

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( child: Wrap( children: [
        
      ])),
    );
  }
}