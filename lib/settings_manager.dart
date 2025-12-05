import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum SortOrder {
  alphabetical,
  reverseAlphabetical
}



// This class was needed to maintain persistent settings
class SettingsManager extends ChangeNotifier {
  static const String _sortOrderKey = 'sort_order';
  SortOrder _sortOrder = SortOrder.alphabetical;
  SortOrder get sortOrder => _sortOrder;
  bool get isAlphabetical => _sortOrder == SortOrder.alphabetical;

  SettingsManager() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_sortOrderKey) ?? 0;
    _sortOrder = SortOrder.values[index];
    notifyListeners();
  }

  Future<void> setSortOrder(SortOrder order) async {
    _sortOrder = order;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sortOrderKey, _sortOrder.index);
  }

}