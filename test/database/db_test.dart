import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mathhammer/database/db.dart';
import 'package:mathhammer/models/unit_stats.dart';
import 'package:mathhammer/models/weapon_stats.dart';

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
        rangedWeapons: [],
        meleeWeapons: [],
      );

      await insertUnit(unit);
      final units = await getAllUnits();

      expect(units, hasLength(1));
      expect(units.first.name, 'Space Marine');
      expect(units.first.id, '1');
      expect(units.first.movement, 6);
      expect(units.first.toughness, 4);
    });

    test('Insert unit with weapons', () async {
      final weapon = Weapons(
        id: 'w1',
        name: 'Bolter',
        attacks: 2,
        strength: 4,
        ap: 0,
        range: 24,
        damage: 1,
      );

      final unit = Unit(
        id: '2',
        name: 'Tactical Marine',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 5,
        rangedWeapons: [weapon],
        meleeWeapons: [],
      );

      await insertUnit(unit);
      final units = await getAllUnits();

      expect(units, hasLength(1));
      expect(units.first.rangedWeapons, hasLength(1));
      expect(units.first.rangedWeapons.first.name, 'Bolter');
      expect(units.first.rangedWeapons.first.attacks, 2);
    });

    test('Get unit by name', () async {
      final unit = Unit(
        id: '3',
        name: 'Terminator',
        movement: 5,
        toughness: 5,
        save: 2,
        wounds: 3,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 5,
        rangedWeapons: [],
        meleeWeapons: [],
      );

      await insertUnit(unit);
      final retrieved = await getUnitByName('Terminator');

      expect(retrieved, isNotNull);
      expect(retrieved!.name, 'Terminator');
      expect(retrieved.toughness, 5);
    });

    test('Get unit by name returns null if not found', () async {
      final retrieved = await getUnitByName('NonExistent');
      expect(retrieved, isNull);
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
        rangedWeapons: [],
        meleeWeapons: [],
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
        rangedWeapons: [],
        meleeWeapons: [],
      );

      await updateUnit(updatedUnit);
      final retrieved = await getUnitByName('Veteran Scout');

      expect(retrieved, isNotNull);
      expect(retrieved!.name, 'Veteran Scout');
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
        rangedWeapons: [],
        meleeWeapons: [],
      );

      await insertUnit(unit);
      var units = await getAllUnits();
      expect(units, hasLength(1));

      await deleteUnit('5');
      units = await getAllUnits();
      expect(units, isEmpty);
    });

    test('Delete unit also deletes weapons', () async {
      final weapon = Weapons(
        id: 'w2',
        name: 'Power Sword',
        attacks: 3,
        strength: 5,
        ap: -3,
        range: 0,
        damage: 2,
      );

      final unit = Unit(
        id: '6',
        name: 'Captain',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 5,
        leadership: 6,
        objectiveControl: 1,
        modelCount: 1,
        rangedWeapons: [],
        meleeWeapons: [weapon],
      );

      await insertUnit(unit);
      
      // Verify weapon was inserted
      final weaponsBefore = await testDb.query('weapons');
      expect(weaponsBefore, hasLength(1));

      await deleteUnit('6');
      
      // Verify weapon was deleted
      final weaponsAfter = await testDb.query('weapons');
      expect(weaponsAfter, isEmpty);
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
          rangedWeapons: [],
          meleeWeapons: [],
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
          rangedWeapons: [],
          meleeWeapons: [],
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
          rangedWeapons: [],
          meleeWeapons: [],
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
          rangedWeapons: [],
          meleeWeapons: [],
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
          rangedWeapons: [],
          meleeWeapons: [],
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
          rangedWeapons: [],
          meleeWeapons: [],
        ),
      );

      for (final unit in units) {
        await insertUnit(unit);
      }

      final retrieved = await getAllUnits();
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
        rangedWeapons: [],
        meleeWeapons: [],
      );

      await insertUnit(unit);
      final retrieved = await getUnitByName('Storm Shield Terminator');

      expect(retrieved, isNotNull);
      expect(retrieved!.invulnerableSave, 4);
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
        rangedWeapons: [],
        meleeWeapons: [],
      );

      await insertUnit(unit);
      final retrieved = await getUnitByName('Captain with Image');

      expect(retrieved, isNotNull);
      expect(retrieved!.imagePath, '/path/to/image.png');
    });

    test('Update unit weapons', () async {
      final weapon1 = Weapons(
        id: 'w3',
        name: 'Bolter',
        attacks: 2,
        strength: 4,
        ap: 0,
        range: 24,
        damage: 1,
      );

      final unit = Unit(
        id: '14',
        name: 'Upgradeable Marine',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 5,
        rangedWeapons: [weapon1],
        meleeWeapons: [],
      );

      await insertUnit(unit);

      final weapon2 = Weapons(
        id: 'w4',
        name: 'Plasma Gun',
        attacks: 1,
        strength: 7,
        ap: -3,
        range: 24,
        damage: 2,
      );

      final updatedUnit = Unit(
        id: '14',
        name: 'Upgradeable Marine',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 5,
        rangedWeapons: [weapon2],
        meleeWeapons: [],
      );

      await updateUnit(updatedUnit);
      final retrieved = await getUnitByName('Upgradeable Marine');

      expect(retrieved, isNotNull);
      expect(retrieved!.rangedWeapons, hasLength(1));
      expect(retrieved.rangedWeapons.first.name, 'Plasma Gun');
      expect(retrieved.rangedWeapons.first.strength, 7);
    });

    test('Empty database returns empty list', () async {
      final units = await getAllUnits();
      expect(units, isEmpty);
    });

    test('Alphabetical sort with empty database', () async {
      final units = await getUnitsAlphabetical();
      expect(units, isEmpty);
    });
  });
}
