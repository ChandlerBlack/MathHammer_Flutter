import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/utils/utils.dart';


late Database database;

const tableUnits = 'units';
const tableWeapons = 'weapons';

