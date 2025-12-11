import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathhammer/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Initialize Flutter bindings for Google Fonts
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeManager Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('Default theme mode is dark', () async {
      final manager = ThemeManager();
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(manager.themeMode, ThemeMode.dark);
      expect(manager.isDarkMode, isTrue);
    });

    test('Toggle theme from dark to light', () async {
      final manager = ThemeManager();
      await manager.toggleTheme();
      
      expect(manager.themeMode, ThemeMode.light);
      expect(manager.isDarkMode, isFalse);
    });

    test('Toggle theme from light to dark', () async {
      SharedPreferences.setMockInitialValues({'theme_mode': false});
      final manager = ThemeManager();
      await Future.delayed(const Duration(milliseconds: 100));
      
      await manager.toggleTheme();
      
      expect(manager.themeMode, ThemeMode.dark);
      expect(manager.isDarkMode, isTrue);
    });

    test('Set specific theme mode', () async {
      final manager = ThemeManager();
      await manager.setTheme(ThemeMode.light);
      
      expect(manager.themeMode, ThemeMode.light);
      expect(manager.isDarkMode, isFalse);
    });

    test('Set theme to system mode', () async {
      final manager = ThemeManager();
      await manager.setTheme(ThemeMode.system);
      
      expect(manager.themeMode, ThemeMode.system);
      // isDarkMode returns false for system mode
      expect(manager.isDarkMode, isFalse);
    });

    test('Multiple theme toggles work correctly', () async {
      final manager = ThemeManager();
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(manager.themeMode, ThemeMode.dark);
      
      await manager.toggleTheme();
      expect(manager.themeMode, ThemeMode.light);
      
      await manager.toggleTheme();
      expect(manager.themeMode, ThemeMode.dark);
      
      await manager.toggleTheme();
      expect(manager.themeMode, ThemeMode.light);
    });

    test('Theme mode persists after toggle', () async {
      final manager = ThemeManager();
      await manager.toggleTheme();
      
      // Simulate app restart
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getBool('theme_mode');
      
      expect(savedTheme, isFalse); // Light mode
    });

    test('Theme mode persists across instances', () async {
      SharedPreferences.setMockInitialValues({'theme_mode': false});
      
      final manager = ThemeManager();
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(manager.themeMode, ThemeMode.light);
    });

    test('ChangeNotifier triggers on theme toggle', () async {
      final manager = ThemeManager();
      var notified = false;
      
      manager.addListener(() {
        notified = true;
      });
      
      await manager.toggleTheme();
      
      expect(notified, isTrue);
    });

    test('ChangeNotifier triggers on setTheme', () async {
      final manager = ThemeManager();
      var notified = false;
      
      manager.addListener(() {
        notified = true;
      });
      
      await manager.setTheme(ThemeMode.light);
      
      expect(notified, isTrue);
    });

    test('ChangeNotifier triggers multiple times', () async {
      final manager = ThemeManager();
      await Future.delayed(const Duration(milliseconds: 100));
      
      var notifyCount = 0;
      manager.addListener(() {
        notifyCount++;
      });
      
      await manager.toggleTheme();
      await manager.toggleTheme();
      await manager.setTheme(ThemeMode.dark);
      
      expect(notifyCount, 3);
    });

    test('isDarkMode reflects current theme correctly', () async {
      final manager = ThemeManager();
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(manager.isDarkMode, isTrue);
      
      await manager.setTheme(ThemeMode.light);
      expect(manager.isDarkMode, isFalse);
      
      await manager.setTheme(ThemeMode.dark);
      expect(manager.isDarkMode, isTrue);
      
      await manager.setTheme(ThemeMode.system);
      expect(manager.isDarkMode, isFalse);
    });

    test('PageTransitionsTheme is configured', () {
      final manager = ThemeManager();
      
      expect(manager.pageTransitionsTheme, isNotNull);
      expect(manager.pageTransitionsTheme.builders, isNotEmpty);
    });

    test('PageTransitionsTheme has all platforms', () {
      final manager = ThemeManager();
      
      final builders = manager.pageTransitionsTheme.builders;
      expect(builders.containsKey(TargetPlatform.android), isTrue);
      expect(builders.containsKey(TargetPlatform.iOS), isTrue);
      expect(builders.containsKey(TargetPlatform.linux), isTrue);
      expect(builders.containsKey(TargetPlatform.macOS), isTrue);
      expect(builders.containsKey(TargetPlatform.windows), isTrue);
    });

    test('Theme mode string constant is correct', () async {
      final manager = ThemeManager();
      
      // Access via reflection would be needed, but we can verify behavior
      await manager.toggleTheme();
      final prefs = await SharedPreferences.getInstance();
      
      expect(prefs.containsKey('theme_mode'), isTrue);
    });

    test('Loading theme handles missing preference', () async {
      // No initial values set
      final manager = ThemeManager();
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Should default to dark
      expect(manager.themeMode, ThemeMode.dark);
    });

    test('Multiple managers can coexist', () async {
      final manager1 = ThemeManager();
      final manager2 = ThemeManager();
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      await manager1.setTheme(ThemeMode.light);
      await manager2.setTheme(ThemeMode.dark);
      
      expect(manager1.themeMode, ThemeMode.light);
      expect(manager2.themeMode, ThemeMode.dark);
    });

    test('Listeners can be removed', () async {
      final manager = ThemeManager();
      await Future.delayed(const Duration(milliseconds: 100));
      
      var notifyCount = 0;
      void listener() {
        notifyCount++;
      }
      
      manager.addListener(listener);
      await manager.toggleTheme();
      
      manager.removeListener(listener);
      await manager.toggleTheme();
      
      expect(notifyCount, 1);
    });

    test('Theme objects are not null', () {
      final manager = ThemeManager();
      
      expect(manager.lightTheme, isNotNull);
      expect(manager.darkTheme, isNotNull);
    });

    test('Theme objects are ThemeData instances', () {
      final manager = ThemeManager();
      
      expect(manager.lightTheme, isA<ThemeData>());
      expect(manager.darkTheme, isA<ThemeData>());
    });

    test('Light and dark themes are different objects', () {
      final manager = ThemeManager();
      
      expect(manager.lightTheme, isNot(same(manager.darkTheme)));
    });

    // Note: Font tests removed - Google Fonts requires network access in tests
  });
}
