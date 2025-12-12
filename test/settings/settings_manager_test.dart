import 'package:flutter_test/flutter_test.dart';
import 'package:mathhammer/theme/settings_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsManager Tests', () {
    setUp(() async {
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('Default sort order is alphabetical', () async {
      final manager = SettingsManager();
      // Give time for async initialization
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(manager.sortOrder, SortOrder.alphabetical);
      expect(manager.isAlphabetical, isTrue);
    });

    test('Default sound setting is enabled', () async {
      final manager = SettingsManager();
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(manager.soundEnabled, isTrue);
    });

    test('Set sort order to reverse alphabetical', () async {
      final manager = SettingsManager();
      await manager.setSortOrder(SortOrder.reverseAlphabetical);
      
      expect(manager.sortOrder, SortOrder.reverseAlphabetical);
      expect(manager.isAlphabetical, isFalse);
    });

    test('Disable sound effects', () async {
      final manager = SettingsManager();
      await Future.delayed(const Duration(milliseconds: 100));
      await manager.setSoundEnabled(false);
      
      expect(manager.soundEnabled, isFalse);
    });

    test('Enable sound effects', () async {
      final manager = SettingsManager();
      await manager.setSoundEnabled(false);
      await manager.setSoundEnabled(true);
      
      expect(manager.soundEnabled, isTrue);
    });

    test('Sort order persists', () async {
      SharedPreferences.setMockInitialValues({
        'sort_order': SortOrder.reverseAlphabetical.index,
      });
      
      final manager = SettingsManager();
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(manager.sortOrder, SortOrder.reverseAlphabetical);
    });

    test('Sound setting persists', () async {
      SharedPreferences.setMockInitialValues({
        'sound_enabled': false,
      });
      
      final manager = SettingsManager();
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(manager.soundEnabled, isFalse);
    });

    test('ChangeNotifier triggers on sort order change', () async {
      final manager = SettingsManager();
      var notified = false;
      
      manager.addListener(() {
        notified = true;
      });
      
      await manager.setSortOrder(SortOrder.reverseAlphabetical);
      
      expect(notified, isTrue);
    });

    test('ChangeNotifier triggers on sound setting change', () async {
      final manager = SettingsManager();
      var notified = false;
      
      manager.addListener(() {
        notified = true;
      });
      
      await manager.setSoundEnabled(false);
      
      expect(notified, isTrue);
    });

    test('Multiple setting changes persist correctly', () async {
      final manager = SettingsManager();
      
      await manager.setSortOrder(SortOrder.reverseAlphabetical);
      await manager.setSoundEnabled(false);
      
      expect(manager.sortOrder, SortOrder.reverseAlphabetical);
      expect(manager.soundEnabled, isFalse);
      
      // Simulate app restart with new instance
      SharedPreferences.setMockInitialValues({
        'sort_order': SortOrder.reverseAlphabetical.index,
        'sound_enabled': false,
      });
      
      final newManager = SettingsManager();
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(newManager.sortOrder, SortOrder.reverseAlphabetical);
      expect(newManager.soundEnabled, isFalse);
    });
  });
}
