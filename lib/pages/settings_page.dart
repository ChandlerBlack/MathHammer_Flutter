import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../settings_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final settingsManager = Provider.of<SettingsManager>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Theme
          const Text(
            'Appearance',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: Text(themeManager.isDarkMode ? 'Enabled' : 'Disabled'),
              value: themeManager.isDarkMode,
              onChanged: (_) => themeManager.toggleTheme(),
              secondary: Icon(
                themeManager.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Library Sorting
          const Text(
            'Library Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sort Units By:', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  ToggleButtons(
                    isSelected: [settingsManager.isAlphabetical, 
                    !settingsManager.isAlphabetical],
                    onPressed: (int index) {
                      if (index == 0) {
                        settingsManager.setSortOrder(SortOrder.alphabetical);
                      } else {
                        settingsManager.setSortOrder(SortOrder.reverseAlphabetical);
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('A-Z'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Z-A'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}