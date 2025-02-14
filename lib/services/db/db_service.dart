import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

class DBService {
  static final DBService _instance = DBService._internal();

  factory DBService() {
    return _instance;
  }

  DBService._internal();

  static bool _initialized = false;
  static Database? _database;

  static Future<void> initializeDatabase() async {
    if (!_initialized) {
      try {
        sqfliteFfiInit();
        var databaseFactory = databaseFactoryFfi;
        var path = normalize(absolute(join('.dart_tool', 'sqflite_common_ffi',
            'databases', 'sqflite_ffi_salesdb.db')));
        await Directory(dirname(path)).create(recursive: true);
        _database = await databaseFactory.openDatabase(
          path,
          options: OpenDatabaseOptions(
            version: 2,
            // onCreate: (db, version) async {
            //   await db.execute('''
            //       CREATE TABLE IF NOT EXISTS Products(
            //         id INTEGER PRIMARY KEY,
            //         name TEXT,
            //         price REAL,
            //         quantity INTEGER,
            //         category TEXT,
            //         imgUrl TEXT,
            //         size TEXT
            //       )
            //     ''');
            // },
            onUpgrade: (db, oldVersion, newVersion) async {
              await db.execute('DROP TABLE Product');
              await db.execute('''CREATE TABLE IF NOT EXISTS Products(
                id INTEGER PRIMARY KEY,
                name TEXT,
                price REAL,
                quantity INTEGER,
                category TEXT,
                imgUrl TEXT,
                size TEXT
              )''');
            },
          ),
        );
        _initialized = true;
        print('initialized');
        // print(_database!.database);
      } catch (e) {
        // Handle the exception
        print('Database initialization failed: $e');
      }
    }
  }

  // Insert a new product in the Products table
  static Future<void> insertProduct(
      String name, double price, int quantity, String category, String size,
      {String imgUrl = 'assets/Chicken.jpg'}) async {
    if (_database == null) {
      throw Exception('Database not initialized');
    }
    await _database!.insert(
      'Products',
      {
        'id': const Uuid().hashCode,
        'name': name,
        'price': price,
        'quantity': quantity,
        'category': category,
        'size': size,
        'imgUrl': imgUrl,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Clear all Products from th products DB
  static Future<int> clearDataBase() async {
    try {
      await _database!.delete('Products');
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 0;
  }

  // Get all products from the Products table
  static Future<List<Map<String, dynamic>>> getProducts() async {
    if (_database == null) {
      throw Exception('Database not initialized');
    }
    return await _database!.query('Products');
  }

  // Filter Products by type 
  static Future<List<Map<String, dynamic>>> getProductsByType(
      String type) async {
    if (_database == null) {
      throw Exception('Database not initialized');
    }
    return await _database!
        .query('Products', where: 'category = ?', whereArgs: [type]);
  }

  // Storage path of the DB
  static Future<String> seeTables() async {
    return _database!.toString();
  }
}
