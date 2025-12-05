import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/unit_stats.dart';
import '../models/weapon_stats.dart';



late Database database;

const tableUnits = 'units';
const tableWeapons = 'weapons';


Future<void> initDatabase() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'mathhammer.db');
  database = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      // create units table
      await db.execute('''
        CREATE TABLE $tableUnits ( 
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          imagePath TEXT,
          movement INTEGER NOT NULL,
          toughness INTEGER NOT NULL,
          save INTEGER NOT NULL,
          wounds INTEGER NOT NULL,
          leadership INTEGER NOT NULL,
          objectiveControl INTEGER NOT NULL,
          modelCount INTEGER NOT NULL
        )
      ''');
      // create weapons table
      await db.execute('''
        CREATE TABLE $tableWeapons (
          id TEXT PRIMARY KEY,
          unitId TEXT NOT NULL,
          name TEXT NOT NULL,
          attacks INTEGER NOT NULL,
          strength INTEGER NOT NULL,
          ap INTEGER NOT NULL,
          range INTEGER NOT NULL,
          damage INTEGER NOT NULL,
          FOREIGN KEY (unitId) REFERENCES $tableUnits (id) ON DELETE CASCADE
        )
      ''');
    },
  );
}

// CRUD OPs

Future<void> insertUnit(Unit unit) async {
  print('Inserting unit: ${unit.name}'); // debug

  await database.insert(
    tableUnits,
    unit.toMap(),
  );

  for (var weapon in unit.rangedWeapons) {
    await database.insert(
      tableWeapons,
      weapon.toMap(unit.id),
    );
  }

  for (var weapon in unit.meleeWeapons) {
    await database.insert(
      tableWeapons,
      weapon.toMap(unit.id),
    );
  }

  print('Unit inserted: ${unit.name}'); // debug

}

Future<List<Unit>> getAllUnits() async {
  print ('Fetching all units from database'); // debug

  final List<Map<String, dynamic>> unitMaps = await database.query(tableUnits);
  print('Found Units, total count: ${unitMaps.length}'); // debug

  List<Unit> units = [];

  for (var unitMap in unitMaps) {
    final String unitId = unitMap['id'];
    final List<Map<String, dynamic>> weaponMap = await database.query(
      tableWeapons,
      where: 'unitId = ?',
      whereArgs: [unitId],
    );

    List<Weapons> allWeapons = weaponMap.map((weaponMap) => Weapons.fromMap(weaponMap)).toList();

    units.add(Unit.fromMap(
      unitMap,
      allWeapons, // only ranged weapons for now but the i got the structure to separate them later
      [],
    ));
  }
  print('Total units fetched: ${units.length}'); // debug
  return units;
}

// get an individual unit by name
Future<Unit?> getUnitByName(String name) async {
  print('Fetching unit by name: $name'); // debug

  final List<Map<String, dynamic>> unitMaps = await database.query(
    tableUnits,
    where: 'name = ?',
    whereArgs: [name],
  );

  // check if its there
  if (unitMaps.isEmpty) {
    print('No unit found with name: $name'); // debug
    return null;
  }
  final unitMap = unitMaps.first;
  final List<Map<String, dynamic>> weaponMap = await database.query(
    tableWeapons,
    where: 'unitId = ?',
    whereArgs: [unitMap['id']],
  );
  List<Weapons> allWeapons = weaponMap
      .map((weaponMap) => Weapons.fromMap(weaponMap))
      .toList();

  print('Unit found: ${unitMap['name']}'); // debug
  return Unit.fromMap(
    unitMap,
    allWeapons, 
    [],
  );
}

// update unit
Future<void> updateUnit(Unit unit) async {
  print('Updating unit: ${unit.name}'); // debug

  await database.update(
    tableUnits,
    unit.toMap(),
    where: 'id = ?',
    whereArgs: [unit.id],
  );

  await database.delete(
    tableWeapons,
    where: 'unitId = ?',
    whereArgs: [unit.id],
  );
  for (var weapon in unit.rangedWeapons) {
    await database.insert(
      tableWeapons,
      weapon.toMap(unit.id),
    );
  }
  for (var weapon in unit.meleeWeapons) {
    await database.insert(
      tableWeapons,
      weapon.toMap(unit.id),
    );
  }
  print('Unit updated: ${unit.name}'); // debug
}

// delete unit
Future<void> deleteUnit(String id) async {
  print('Deleting unit with id: $id'); // debug

  await database.delete(
    tableUnits,
    where: 'id = ?',
    whereArgs: [id],
  );

  await database.delete(
    tableWeapons,
    where: 'unitId = ?',
    whereArgs: [id],
  );

  print('Unit deleted with id: $id'); // debug
}




// query units in alphabetical order
Future<List<Unit>> getUnitsAlphabetical() async {
  print('Fetching units in alphabetical order'); // debug

  final List<Map<String, dynamic>> unitMaps = await database.query(
    tableUnits,
    orderBy: 'name ASC',
  );
  print('Found Units, total count: ${unitMaps.length}'); // debug

  List<Unit> units = [];

  for (var unitMap in unitMaps) {
    final String unitId = unitMap['id'];
    final List<Map<String, dynamic>> weaponMap = await database.query(
      tableWeapons,
      where: 'unitId = ?',
      whereArgs: [unitId],
    );

    List<Weapons> allWeapons = weaponMap
        .map((weaponMap) => Weapons.fromMap(weaponMap))
        .toList();

    units.add(Unit.fromMap(
      unitMap,
      allWeapons, 
      [],
    ));
  }
  print('Total units fetched: ${units.length}'); // debug
  return units;
}





// query units in reverse alphabetical order
Future<List<Unit>> getUnitsReverseAlphabetical() async {
  print('Fetching units in reverse alphabetical order'); // debug

  final List<Map<String, dynamic>> unitMaps = await database.query(
    tableUnits,
    orderBy: 'name DESC',
  );
  print('Found Units, total count: ${unitMaps.length}'); // debug

  List<Unit> units = [];

  for (var unitMap in unitMaps) {
    final String unitId = unitMap['id'];
    final List<Map<String, dynamic>> weaponMap = await database.query(
      tableWeapons,
      where: 'unitId = ?',
      whereArgs: [unitId],
    );

    List<Weapons> allWeapons = weaponMap
        .map((weaponMap) => Weapons.fromMap(weaponMap))
        .toList();

    units.add(Unit.fromMap(
      unitMap,
      allWeapons, 
      [],
    ));
  }
  print('Total units fetched: ${units.length}'); // debug
  return units;
}