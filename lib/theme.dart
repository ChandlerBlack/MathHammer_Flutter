import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class ThemeManager extends ChangeNotifier {

  final PageTransitionsTheme pageTransitionsTheme = const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: NoAnimationPageTransitionsBuilder(),
      TargetPlatform.macOS: NoAnimationPageTransitionsBuilder(),
      TargetPlatform.windows: NoAnimationPageTransitionsBuilder(),
    }
  );

  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeManager() {
    _loadTheme();
  }

  // Load saved theme preference
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? true;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Toggle between light and dark theme
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _saveTheme();
    notifyListeners();
  }

  // Set specific theme
  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    await _saveTheme();
    notifyListeners();
  }

  // Save theme preference
  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _themeMode == ThemeMode.dark);
  }

  // Light theme definition
  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: const Color.fromARGB(255, 255, 255, 255),
        onPrimary: const Color(0xFF0081A7),
        secondary: const Color.fromARGB(255, 246, 246, 246),
      ),
      scaffoldBackgroundColor: const Color(0xFFFDFCDC),
      textTheme: GoogleFonts.electrolizeTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF0081A7),
        foregroundColor: const Color.fromARGB(255, 61, 40, 40),
        elevation: 2,
        titleTextStyle: GoogleFonts.electrolize(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color.fromARGB(255, 255, 229, 204),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF0081A7),
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color.fromARGB(255, 49, 91, 123),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(179, 191, 191, 191),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0081A7),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color.fromARGB(255, 255, 229, 204),
        titleTextStyle: GoogleFonts.electrolize(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
        contentTextStyle: GoogleFonts.electrolize(
          fontSize: 16,
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      sliderTheme: SliderThemeData(
        thumbColor: const Color(0xFF0081A7),
        activeTrackColor: const Color(0xFF005F73),
        inactiveTrackColor: const Color(0xFFB0B0B0),
      ),
      pageTransitionsTheme: pageTransitionsTheme,

    );
  }

  // Dark theme definition
  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color.fromARGB(255, 218, 218, 218),
        onPrimary: const Color(0xFF124559),
        secondary: const Color.fromARGB(255, 255, 255, 255),
      ),
      scaffoldBackgroundColor: const Color(0xFF01161E),
      textTheme: GoogleFonts.electrolizeTextTheme(ThemeData.dark().textTheme), 
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF124559),
        foregroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: GoogleFonts.electrolize(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color.fromARGB(255, 89, 89, 89),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        surfaceTintColor: Color.fromARGB(255, 130, 203, 231),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF598392),
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF124559),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[500],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF598392),
          foregroundColor: Colors.white,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color.fromARGB(255, 89, 89, 89),
        titleTextStyle: GoogleFonts.electrolize(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        contentTextStyle: GoogleFonts.electrolize(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      sliderTheme: SliderThemeData(
        thumbColor: const Color(0xFF598392),
        activeTrackColor: const Color(0xFF81CFEF),
        inactiveTrackColor: const Color(0xFF444444),
      ),
      pageTransitionsTheme: pageTransitionsTheme,
    );
  }
}