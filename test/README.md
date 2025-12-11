# MathHammer Unit Testing Guide

This guide explains how to run and create unit tests for the MathHammer Flutter project.

## Test Structure

```
test/
├── database/
│   └── db_test.dart                # Tests for database operations
├── models/
│   ├── unit_stats_test.dart        # Tests for Unit model
│   └── weapon_stats_test.dart      # Tests for Weapon model
├── settings/
│   └── settings_manager_test.dart  # Tests for SettingsManager
├── simulation/
│   ├── dice_test.dart              # Tests for Dice simulation
│   └── sim_test.dart               # Tests for combat simulation
├── theme/
│   └── theme_manager_test.dart     # Tests for ThemeManager
└── widgets/
    ├── unit_card_base_test.dart    # Tests for UnitCardBase widget
    └── unit_card_full_test.dart    # Tests for UnitCardFull widget
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/simulation/sim_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### View Coverage Summary
```bash
# Run tests with coverage and display summary
flutter test --coverage && dart coverage_summary.dart
```

The `coverage_summary.dart` script provides a clean, formatted output showing:
- Per-file coverage percentages
- Line coverage statistics
- Overall project coverage
- Visual indicators (✅ for good coverage, ⚠️ for areas needing improvement)

### View Detailed HTML Coverage Report (requires lcov)
```bash
# Install lcov (on Windows with Chocolatey)
choco install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open the report
start coverage/html/index.html
```

### Run Tests in Watch Mode
```bash
flutter test --watch
```

## Test Categories

### 1. Model Tests (`test/models/`)
Tests data models and their serialization:
- Unit creation and validation
- JSON serialization/deserialization
- Database map conversions
- Default values
- Edge cases (null handling, etc.)

**Example:**
```dart
test('Unit creation with required fields', () {
  final unit = Unit(
    id: '1',
    name: 'Space Marine',
    // ... other fields
  );
  expect(unit.name, 'Space Marine');
});
```

### 2. Simulation Tests (`test/simulation/`)
Tests game logic and calculations:
- Dice rolling mechanics
- Attack calculations
- Damage computations
- Statistical distributions

**Example:**
```dart
test('Dice rolls are within valid range (1-6)', () {
  final dice = Dice(100);
  dice.roll();
  
  for (final roll in dice.rolls) {
    expect(roll, greaterThanOrEqualTo(1));
    expect(roll, lessThanOrEqualTo(6));
  }
});
```

### 3. Settings Tests (`test/settings/`)
Tests persistent settings management:
- Default values
- Setting changes
- Persistence across app restarts
- ChangeNotifier behavior

**Example:**
```dart
test('Sound setting persists', () async {
  SharedPreferences.setMockInitialValues({
    'sound_enabled': false,
  });
  
  final manager = SettingsManager();
  await Future.delayed(const Duration(milliseconds: 100));
  
  expect(manager.soundEnabled, isFalse);
});
```

### 4. Theme Tests (`test/theme/`)
Tests theme management:
- Theme switching
- Persistence
- Light/dark mode properties
- ChangeNotifier triggers

**Example:**
```dart
test('Toggle theme from dark to light', () async {
  final manager = ThemeManager();
  await manager.toggleTheme();
  
  expect(manager.themeMode, ThemeMode.light);
});
```

### 5. Widget Tests (`test/widgets/`)
Tests UI components:
- Widget rendering
- User interactions
- Display logic
- Edge cases (null data, long text, etc.)

**Example:**
```dart
testWidgets('UnitCardBase displays unit name', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: UnitCardBase(unit: testUnit, onReturn: () {}),
      ),
    ),
  );

  expect(find.text('Test Unit'), findsOneWidget);
});
```

## Writing New Tests

### Basic Test Structure
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mathhammer/your_file.dart';

void main() {
  group('Your Feature Tests', () {
    // Setup runs before each test
    setUp(() {
      // Initialize test data
    });
    
    // Cleanup runs after each test
    tearDown(() {
      // Clean up resources
    });

    test('should do something', () {
      // Arrange
      final input = 'test';
      
      // Act
      final result = yourFunction(input);
      
      // Assert
      expect(result, expectedValue);
    });
  });
}
```

### Widget Test Structure
```dart
testWidgets('description', (WidgetTester tester) async {
  // Build the widget
  await tester.pumpWidget(
    MaterialApp(home: YourWidget()),
  );

  // Find elements
  expect(find.text('Expected Text'), findsOneWidget);
  
  // Interact with widget
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump(); // Trigger a frame
  
  // Assert after interaction
  expect(find.text('Updated Text'), findsOneWidget);
});
```

## Common Matchers

```dart
// Equality
expect(actual, equals(expected));
expect(actual, same(expected));

// Comparison
expect(value, greaterThan(5));
expect(value, lessThanOrEqualTo(10));

// Types
expect(value, isA<String>());
expect(value, isNotNull);

// Collections
expect(list, isEmpty);
expect(list, hasLength(3));
expect(list, contains('item'));

// Widgets
expect(find.text('Hello'), findsOneWidget);
expect(find.byType(Button), findsNothing);
expect(find.byIcon(Icons.add), findsNWidgets(2));

// Async
await expectLater(future, completes);
await expectLater(future, throwsException);
```

## Mocking Dependencies

### SharedPreferences
```dart
setUp(() {
  SharedPreferences.setMockInitialValues({
    'key': 'value',
  });
});
```

### Provider
```dart
testWidgets('test with provider', (tester) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => YourManager(),
      child: MaterialApp(home: YourWidget()),
    ),
  );
});
```

## Best Practices

1. **Test One Thing**: Each test should verify one specific behavior
2. **Use Descriptive Names**: Test names should explain what they're testing
3. **Arrange-Act-Assert**: Structure tests clearly with setup, action, and verification
4. **Avoid Test Interdependence**: Tests should run independently
5. **Use setUp/tearDown**: Keep tests DRY by extracting common setup
6. **Test Edge Cases**: Include tests for null, empty, and boundary values
7. **Mock External Dependencies**: Isolate the code under test
8. **Keep Tests Fast**: Avoid unnecessary delays or heavy operations

## Current Test Coverage

- ✅ Unit model (creation, serialization, validation)
- ✅ Dice rolling mechanics
- ✅ Settings management (sort order, sound)
- ✅ Theme management (light/dark, persistence)
- ✅ UnitCardBase widget rendering
- ⏳ Database operations (TODO)
- ⏳ Simulation combat logic (TODO)
- ⏳ Camera functionality (TODO)

## Adding Tests for Database

```dart
// Example: test/database/db_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mathhammer/database/db.dart';

void main() {
  setUpAll(() {
    // Initialize FFI for desktop testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Database Tests', () {
    test('Insert and retrieve unit', () async {
      // Your database tests here
    });
  });
}
```

## Continuous Integration

Add to `.github/workflows/test.yml`:
```yaml
name: Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
```

## Debugging Tests

### Run with Verbose Output
```bash
flutter test --verbose
```

### Run Single Test
```bash
flutter test test/simulation/dice_test.dart --name "Dice rolls are within valid range"
```

### Debug in VS Code
Add to `.vscode/launch.json`:
```json
{
  "name": "Flutter Tests",
  "type": "dart",
  "request": "launch",
  "program": "test/"
}
```

## Resources

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Package:test Documentation](https://pub.dev/packages/test)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Unit Testing](https://docs.flutter.dev/cookbook/testing/unit/introduction)
