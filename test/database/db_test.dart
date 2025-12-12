import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mathhammer/database/db.dart';
import 'package:mathhammer/models/unit_stats.dart';

void main() {
  // Initialize FFI for desktop testing
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Database Tests', () {
    late Database testDb;

    setUp(() async {
      // Create fresh in-memory database for each test
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
          },
        ),
      );
      database = testDb; // Set the global database variable
    });

    tearDown(() async {
      await testDb.close();
    });

    test('Insert and retrieve unit', () async {
      final unit = Unit(
        id: '1',
        name: 'Space Marine',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 10,
      );

      await insertUnit(unit);
      final units = await getUnitsAlphabetical();

      expect(units, hasLength(1));
      expect(units.first.name, 'Space Marine');
      expect(units.first.id, '1');
      expect(units.first.movement, 6);
      expect(units.first.toughness, 4);
    });

    test('Update unit', () async {
      final unit = Unit(
        id: '4',
        name: 'Scout',
        movement: 6,
        toughness: 4,
        save: 4,
        wounds: 1,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 10,
      );

      await insertUnit(unit);

      final updatedUnit = Unit(
        id: '4',
        name: 'Veteran Scout',
        movement: 7,
        toughness: 4,
        save: 3,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 10,
      );

      await updateUnit(updatedUnit);
      final units = await getUnitsAlphabetical();
      final retrieved = units.firstWhere((u) => u.id == '4');

      expect(retrieved.name, 'Veteran Scout');
      expect(retrieved.movement, 7);
      expect(retrieved.save, 3);
      expect(retrieved.wounds, 2);
    });

    test('Delete unit', () async {
      final unit = Unit(
        id: '5',
        name: 'To Delete',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 10,
      );

      await insertUnit(unit);
      var units = await getUnitsAlphabetical();
      expect(units, hasLength(1));

      await deleteUnit('5');
      units = await getUnitsAlphabetical();
      expect(units, isEmpty);
    });

    test('Get units alphabetically', () async {
      final units = [
        Unit(
          id: '7',
          name: 'Zeta Squad',
          movement: 6,
          toughness: 4,
          save: 3,
          wounds: 2,
          leadership: 6,
          objectiveControl: 2,
          modelCount: 10,
        ),
        Unit(
          id: '8',
          name: 'Alpha Squad',
          movement: 6,
          toughness: 4,
          save: 3,
          wounds: 2,
          leadership: 6,
          objectiveControl: 2,
          modelCount: 10,
        ),
        Unit(
          id: '9',
          name: 'Beta Squad',
          movement: 6,
          toughness: 4,
          save: 3,
          wounds: 2,
          leadership: 6,
          objectiveControl: 2,
          modelCount: 10,
        ),
      ];

      for (final unit in units) {
        await insertUnit(unit);
      }

      final sorted = await getUnitsAlphabetical();
      expect(sorted, hasLength(3));
      expect(sorted[0].name, 'Alpha Squad');
      expect(sorted[1].name, 'Beta Squad');
      expect(sorted[2].name, 'Zeta Squad');
    });

    test('Get units reverse alphabetically', () async {
      final units = [
        Unit(
          id: '10',
          name: 'Alpha Squad',
          movement: 6,
          toughness: 4,
          save: 3,
          wounds: 2,
          leadership: 6,
          objectiveControl: 2,
          modelCount: 10,
        ),
        Unit(
          id: '11',
          name: 'Zeta Squad',
          movement: 6,
          toughness: 4,
          save: 3,
          wounds: 2,
          leadership: 6,
          objectiveControl: 2,
          modelCount: 10,
        ),
      ];

      for (final unit in units) {
        await insertUnit(unit);
      }

      final sorted = await getUnitsReverseAlphabetical();
      expect(sorted, hasLength(2));
      expect(sorted[0].name, 'Zeta Squad');
      expect(sorted[1].name, 'Alpha Squad');
    });

    test('Insert multiple units', () async {
      final units = List.generate(
        5,
        (i) => Unit(
          id: 'multi_$i',
          name: 'Unit $i',
          movement: 6,
          toughness: 4,
          save: 3,
          wounds: 2,
          leadership: 6,
          objectiveControl: 2,
          modelCount: 10,
        ),
      );

      for (final unit in units) {
        await insertUnit(unit);
      }

      final retrieved = await getUnitsAlphabetical();
      expect(retrieved, hasLength(5));
    });

    test('Unit with invulnerable save', () async {
      final unit = Unit(
        id: '12',
        name: 'Storm Shield Terminator',
        movement: 5,
        toughness: 5,
        save: 2,
        wounds: 3,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 5,
        invulnerableSave: 4,
      );

      await insertUnit(unit);
      final units = await getUnitsAlphabetical();
      final retrieved = units.firstWhere((u) => u.id == '12');

      expect(retrieved.invulnerableSave, 4);
    });

    test('Unit with image path', () async {
      final unit = Unit(
        id: '13',
        name: 'Captain with Image',
        imagePath: '/path/to/image.png',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 5,
        leadership: 6,
        objectiveControl: 1,
        modelCount: 1,
      );

      await insertUnit(unit);
      final units = await getUnitsAlphabetical();
      final retrieved = units.firstWhere((u) => u.id == '13');

      expect(retrieved.imagePath, '/path/to/image.png');
    });

    test('Empty database returns empty list', () async {
      final units = await getUnitsAlphabetical();
      expect(units, isEmpty);
    });

    test('Alphabetical sort with empty database', () async {
      final units = await getUnitsAlphabetical();
      expect(units, isEmpty);
    });
  });
}
