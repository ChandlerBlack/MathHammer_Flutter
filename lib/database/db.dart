import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/unit_stats.dart';



late Database database;

const tableUnits = 'units';


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
          modelCount INTEGER NOT NULL,
          invulnerableSave INTEGER DEFAULT 7
        )
      ''');
    },
  );
}

// CRUD OPs

Future<void> insertUnit(Unit unit) async {
  await database.insert(
    tableUnits,
    unit.toMap(),
  );
}

Future<void> updateUnit(Unit unit) async {
  await database.update(
    tableUnits,
    unit.toMap(),
    where: 'id = ?',
    whereArgs: [unit.id],
  );
}

Future<void> deleteUnit(String id) async {
  await database.delete(
    tableUnits,
    where: 'id = ?',
    whereArgs: [id],
  );
}

// query units in alphabetical order
Future<List<Unit>> getUnitsAlphabetical() async {
  final List<Map<String, dynamic>> unitMaps = await database.query(
    tableUnits,
    orderBy: 'name ASC',
  );

  List<Unit> units = [];

  for (var unitMap in unitMaps) {
    units.add(Unit.fromMap(unitMap));
  }
  return units;
}

// query units in reverse alphabetical order
Future<List<Unit>> getUnitsReverseAlphabetical() async {
  final List<Map<String, dynamic>> unitMaps = await database.query(
    tableUnits,
    orderBy: 'name DESC',
  );

  List<Unit> units = [];

  for (var unitMap in unitMaps) {
    units.add(Unit.fromMap(unitMap));
  }
  return units;
}