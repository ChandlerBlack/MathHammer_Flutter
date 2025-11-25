import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/utils/utils.dart';


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

