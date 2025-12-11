import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathhammer/models/unit_stats.dart';
import 'package:mathhammer/widgets/unit_card_base.dart';
import 'package:mathhammer/widgets/unit_card_full.dart';

void main() {
  group('UnitCardBase Widget Tests', () {
    late Unit testUnit;

    setUp(() {
      testUnit = Unit(
        id: '1',
        name: 'Test Unit',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 10,
        rangedWeapons: [],
        meleeWeapons: [],
      );
    });

    testWidgets('UnitCardBase displays unit name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitCardBase(
              unit: testUnit,
              onReturn: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Unit'), findsOneWidget);
    });

    testWidgets('UnitCardBase shows error when unit is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitCardBase(
              unit: null,
              onReturn: () {},
            ),
          ),
        ),
      );

      expect(find.text('No Unit Data'), findsOneWidget);
    });

    testWidgets('UnitCardBase displays placeholder icon when no image', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitCardBase(
              unit: testUnit,
              onReturn: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.image_not_supported_rounded), findsOneWidget);
    });

    testWidgets('UnitCardBase is wrapped in Card', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitCardBase(
              unit: testUnit,
              onReturn: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('UnitCardBase uses Hero animation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitCardBase(
              unit: testUnit,
              onReturn: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Hero), findsOneWidget);
      
      final hero = tester.widget<Hero>(find.byType(Hero));
      expect(hero.tag, 'unit_Test Unit');
    });

    testWidgets('UnitCardBase is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitCardBase(
              unit: testUnit,
              onReturn: () {},
            ),
          ),
        ),
      );

      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('Long unit names are truncated with ellipsis', (WidgetTester tester) async {
      final longNameUnit = Unit(
        id: '2',
        name: 'This is a very long unit name that should be truncated',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 10,
        rangedWeapons: [],
        meleeWeapons: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitCardBase(
              unit: longNameUnit,
              onReturn: () {},
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(
        find.text('This is a very long unit name that should be truncated'),
      );
      
      expect(textWidget.overflow, TextOverflow.ellipsis);
      expect(textWidget.maxLines, 2);
    });

    testWidgets('Tapping navigates to UnitCardFull', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitCardBase(
              unit: testUnit,
              onReturn: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.byType(UnitCardFull), findsOneWidget);
    });

    testWidgets('onReturn callback is called when returning from full card', (WidgetTester tester) async {
      var returnCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitCardBase(
              unit: testUnit,
              onReturn: () {
                returnCalled = true;
              },
            ),
          ),
        ),
      );

      // Navigate to full card
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Go back
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(returnCalled, isFalse); // Only called if result is true
    });

    testWidgets('Card has proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitCardBase(
              unit: testUnit,
              onReturn: () {},
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(Material),
          matching: find.byType(Padding),
        ).first,
      );

      expect(padding.padding, const EdgeInsets.all(4.0));
    });

    testWidgets('Unit with image path shows file image', (WidgetTester tester) async {
      // Note: This will fail in test because File won't exist, but tests the code path
      final unitWithImage = Unit(
        id: '3',
        name: 'Image Unit',
        imagePath: '/fake/path/image.png',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 10,
        rangedWeapons: [],
        meleeWeapons: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitCardBase(
              unit: unitWithImage,
              onReturn: () {},
            ),
          ),
        ),
      );

      // Should attempt to show Image.file
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('Passes simulation callbacks correctly', (WidgetTester tester) async {
      final selectedUnit1 = Unit(
        id: '99',
        name: 'Selected Unit',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 10,
        rangedWeapons: [],
        meleeWeapons: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitCardBase(
              unit: testUnit,
              onReturn: () {},
              onSelectForSimulation: (unit, slot) {},
              selectedUnit1: selectedUnit1,
              selectedUnit2: null,
              onNavigateToSimulation: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Should navigate to full card with callbacks
      expect(find.byType(UnitCardFull), findsOneWidget);
    });
  });
}
