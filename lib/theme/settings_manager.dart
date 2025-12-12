import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum SortOrder {
  alphabetical,
  reverseAlphabetical
}

// This class was needed to maintain persistent settings pulled the idea from the lab 10 code
class SettingsManager extends ChangeNotifier {
  static const String _sortOrderKey = 'sort_order';
  static const String _soundEnabledKey = 'sound_enabled';
  
  SortOrder _sortOrder = SortOrder.alphabetical;
  bool _soundEnabled = true;
  
  SortOrder get sortOrder => _sortOrder;
  bool get isAlphabetical => _sortOrder == SortOrder.alphabetical;
  bool get soundEnabled => _soundEnabled;

  SettingsManager() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_sortOrderKey) ?? 0;
    _sortOrder = SortOrder.values[index];
    _soundEnabled = prefs.getBool(_soundEnabledKey) ?? true;
    notifyListeners();
  }

  Future<void> setSortOrder(SortOrder order) async {
    _sortOrder = order;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sortOrderKey, _sortOrder.index);
    await prefs.setBool(_soundEnabledKey, _soundEnabled);
  }

}