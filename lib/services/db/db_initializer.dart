import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';

class DBInitializer {

  static final DBInitializer _instance = DBInitializer._internal();

  factory DBInitializer() {
    return _instance;
  }

  DBInitializer._internal();

  static bool _initialized = false;
  static Database? _database;

static Future<void> initializeDatabase() async {
  if (!_initialized) {
    try {
      

      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      var path = normalize(absolute(join('.dart_tool', 'sqflite_common_ffi', 'databases', 'sqflite_ffi_salesdb.db')));
      await Directory(dirname(path)).create(recursive: true);
      _database = await databaseFactory.openDatabase(path,
          options: OpenDatabaseOptions(
              version: 1,
              onCreate: (db, version) async {
                await db.execute('''
                  CREATE TABLE IF NOT EXISTS Product (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT,
                    price REAL,
                    quantity INTEGER,
                    category TEXT,
                    size TEXT
                  )
                ''');
              }
          )
      );
     
      _initialized = true;
    } catch (e) {
      // Handle the exception
      print('Database initialization failed: $e');
    }
  }
}


  static Future<void> insertProduct(String name, double price, int quantity, String category, String size) async {
    if (_database == null) {
      throw Exception('Database not initialized');
    }
    await _database!.insert(
      'Product',
      {
        'name': name,
        'price': price,
        'quantity': quantity,
        'category': category,
        'size': size,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    if (_database == null) {
      throw Exception('Database not initialized');
    }
    
    return await _database!.query('Product');
  }
}
