import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathhammer/models/unit_stats.dart';
import 'package:mathhammer/widgets/unit_card_full.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mathhammer/database/db.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('UnitCardFull Widget Tests', () {
    late Unit testUnit;
    late Database testDb;

    setUp(() async {
      testUnit = Unit(
        id: '1',
        name: 'Test Marine',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 10,
        invulnerableSave: 4,
        rangedWeapons: [],
        meleeWeapons: [],
      );

      // Create test database
      testDb = await databaseFactory.openDatabase(
        inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE units ( 
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                imagePath TEXT,
                movement INTEGER NOT NULL,
                toughness INTEGER NOT NULL,
                save INTEGER NOT NULL,
                wounds INTEGER NOT NULL,
                leadership INTEGER NOT NULL,
                objectiveControl INTEGER NOT NULL,
                modelCount INTEGER NOT NULL,
                invulnerableSave INTEGER DEFAULT 7
              )
            ''');
            await db.execute('''
              CREATE TABLE weapons (
                id TEXT PRIMARY KEY,
                unitId TEXT NOT NULL,
                name TEXT NOT NULL,
                attacks INTEGER NOT NULL,
                strength INTEGER NOT NULL,
                ap INTEGER NOT NULL,
                range INTEGER NOT NULL,
                damage INTEGER NOT NULL,
                ballisticSkill INTEGER DEFAULT 3,
                type TEXT DEFAULT 'ranged',
                keywords TEXT DEFAULT '',
                FOREIGN KEY (unitId) REFERENCES units (id) ON DELETE CASCADE
              )
            ''');
          },
        ),
      );
      database = testDb;
      await insertUnit(testUnit);
    });

    tearDown(() async {
      await testDb.close();
    });

    testWidgets('Displays unit name in AppBar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      expect(find.text('Test Marine'), findsNWidgets(2)); // AppBar + Hero section
    });

    testWidgets('Displays all stat fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      expect(find.text('Movement: 6"'), findsOneWidget);
      expect(find.text('Toughness: 4'), findsOneWidget);
      expect(find.text('Save: 3+'), findsOneWidget);
      expect(find.text('Invulnerable Save: 4+'), findsOneWidget);
      expect(find.text('Wounds: 2'), findsOneWidget);
      expect(find.text('Leadership: 6'), findsOneWidget);
      expect(find.text('Objective Control: 2'), findsOneWidget);
      expect(find.text('Model Count: 10'), findsOneWidget);
    });

    testWidgets('Has delete button in AppBar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('Has select for simulation button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      expect(find.text('Select for Simulation'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Delete button shows confirmation dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Delete Unit'), findsOneWidget);
      expect(find.textContaining('Are you sure'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('Cancel button closes delete dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Unit'), findsNothing);
    });

    testWidgets('Delete button removes unit and shows snackbar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitCardFull(unit: testUnit),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.textContaining('has been deleted'), findsOneWidget);
      
      // Verify unit was deleted
      final units = await getAllUnits();
      expect(units, isEmpty);
    });

    testWidgets('Select for simulation shows slot dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(
            unit: testUnit,
            onSelectForSimulation: (unit, slot) {},
          ),
        ),
      );

      // Scroll to make button visible
      await tester.scrollUntilVisible(
        find.text('Select for Simulation'),
        200,
        scrollable: find.byType(SingleChildScrollView),
      );

      await tester.tap(find.text('Select for Simulation'));
      await tester.pumpAndSettle();

      expect(find.text('Select Slot'), findsOneWidget);
      expect(find.text('Slot 1 (Empty)'), findsOneWidget);
      expect(find.text('Slot 2 (Empty)'), findsOneWidget);
      expect(find.byIcon(Icons.filter_1), findsOneWidget);
      expect(find.byIcon(Icons.filter_2), findsOneWidget);
    });

    testWidgets('Slot dialog shows selected units', (tester) async {
      final selectedUnit = Unit(
        id: '99',
        name: 'Already Selected',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 5,
        rangedWeapons: [],
        meleeWeapons: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(
            unit: testUnit,
            onSelectForSimulation: (unit, slot) {},
            selectedUnit1: selectedUnit,
            selectedUnit2: null,
          ),
        ),
      );

      await tester.scrollUntilVisible(
        find.text('Select for Simulation'),
        200,
        scrollable: find.byType(SingleChildScrollView),
      );

      await tester.tap(find.text('Select for Simulation'));
      await tester.pumpAndSettle();

      expect(find.text('Slot 1 (Already Selected)'), findsOneWidget);
      expect(find.text('Slot 2 (Empty)'), findsOneWidget);
    });

    testWidgets('Selecting slot 1 calls callback', (tester) async {
      Unit? selectedUnit;
      int? selectedSlot;

      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(
            unit: testUnit,
            onSelectForSimulation: (unit, slot) {
              selectedUnit = unit;
              selectedSlot = slot;
            },
          ),
        ),
      );

      await tester.scrollUntilVisible(
        find.text('Select for Simulation'),
        200,
        scrollable: find.byType(SingleChildScrollView),
      );

      await tester.tap(find.text('Select for Simulation'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Slot 1 (Empty)'));
      await tester.pumpAndSettle();

      expect(selectedUnit, testUnit);
      expect(selectedSlot, 1);
      expect(find.textContaining('added to Slot 1'), findsOneWidget);
    });

    testWidgets('Selecting slot 2 calls callback', (tester) async {
      Unit? selectedUnit;
      int? selectedSlot;

      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(
            unit: testUnit,
            onSelectForSimulation: (unit, slot) {
              selectedUnit = unit;
              selectedSlot = slot;
            },
          ),
        ),
      );

      await tester.scrollUntilVisible(
        find.text('Select for Simulation'),
        200,
        scrollable: find.byType(SingleChildScrollView),
      );

      await tester.tap(find.text('Select for Simulation'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Slot 2 (Empty)'));
      await tester.pumpAndSettle();

      expect(selectedUnit, testUnit);
      expect(selectedSlot, 2);
      expect(find.textContaining('added to Slot 2'), findsOneWidget);
    });

    testWidgets('Cancel button closes slot dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(
            unit: testUnit,
            onSelectForSimulation: (unit, slot) {},
          ),
        ),
      );

      await tester.scrollUntilVisible(
        find.text('Select for Simulation'),
        200,
        scrollable: find.byType(SingleChildScrollView),
      );

      await tester.tap(find.text('Select for Simulation'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Select Slot'), findsNothing);
    });

    testWidgets('Displays placeholder icon when no image', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      expect(find.byIcon(Icons.image_not_supported_sharp), findsOneWidget);
    });

    testWidgets('Uses Hero animation with correct tag', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      final hero = tester.widget<Hero>(find.byType(Hero));
      expect(hero.tag, 'unit_Test Marine');
    });

    testWidgets('Body is scrollable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Stats are left-aligned', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(Padding),
          matching: find.byType(Column),
        ).last,
      );

      expect(column.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets('Unit name has proper text styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      final nameText = tester.widget<Text>(
        find.descendant(
          of: find.byType(Hero),
          matching: find.text('Test Marine'),
        ),
      );

      expect(nameText.maxLines, 2);
      expect(nameText.overflow, TextOverflow.ellipsis);
      expect(nameText.textAlign, TextAlign.center);
    });

    testWidgets('onNavigateToSimulation is called after slot selection', (tester) async {
      var navigateCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(
            unit: testUnit,
            onSelectForSimulation: (unit, slot) {},
            onNavigateToSimulation: () {
              navigateCalled = true;
            },
          ),
        ),
      );

      await tester.scrollUntilVisible(
        find.text('Select for Simulation'),
        200,
        scrollable: find.byType(SingleChildScrollView),
      );

      await tester.tap(find.text('Select for Simulation'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Slot 1 (Empty)'));
      await tester.pumpAndSettle();

      expect(navigateCalled, isTrue);
    });

    testWidgets('Multiple units have unique Hero tags', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      final hero = tester.widget<Hero>(find.byType(Hero));
      expect(hero.tag, 'unit_Test Marine');
    });

    testWidgets('Flexible widget wraps image correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      expect(find.byType(Flexible), findsOneWidget);
    });

    testWidgets('Container has correct width', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(Hero),
          matching: find.byType(Container),
        ),
      );

      expect(container.constraints?.maxWidth, double.infinity);
    });

    testWidgets('Column has correct cross axis alignment', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      final mainColumn = tester.widget<Column>(
        find.descendant(
          of: find.byType(SingleChildScrollView),
          matching: find.byType(Column),
        ).first,
      );

      expect(mainColumn.crossAxisAlignment, CrossAxisAlignment.center);
    });

    testWidgets('SizedBox has correct height', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      expect(sizedBoxes.any((box) => box.height == 8), isTrue);
      expect(sizedBoxes.any((box) => box.height == 16), isTrue);
    });

    testWidgets('All stat fields use correct text style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      // Verify titleMedium is used for stats
      final context = tester.element(find.byType(UnitCardFull));
      final theme = Theme.of(context);
      
      expect(find.byWidgetPredicate(
        (widget) => widget is Text && widget.style == theme.textTheme.titleMedium,
      ), findsWidgets);
    });

    testWidgets('Material has transparent color in Hero', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(Hero),
          matching: find.byType(Material),
        ),
      );

      expect(material.color, Colors.transparent);
    });

    testWidgets('Icon size is correct for placeholder', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UnitCardFull(unit: testUnit),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.image_not_supported_sharp));
      expect(icon.size, 250);
      expect(icon.color, Colors.grey);
    });
  });
}
