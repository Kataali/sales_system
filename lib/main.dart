import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_system/core/constants/app_routes.dart';
// import 'package:sales_system/models/productModel.dart';

import 'package:sales_system/services/db/db_initializer.dart';
import 'package:sales_system/providers/products_provider.dart';
import 'package:sales_system/views/home.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'core/constants/app_theme.dart';

void main() async {
  await DBInitializer.initializeDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductsProvider>(
      create: (BuildContext context) => ProductsProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food Sales System.',
        theme: themeData(),
        routes: AppRoutes().getRoutes(),
        home: const SideBar(),
      ),
    );
  }
}


// import 'dart:io';

// import 'package:path/path.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Future main() async {
//   // Init ffi loader if needed.
//   sqfliteFfiInit();

//   var databaseFactory = databaseFactoryFfi;
//   // Pick a path on your file system
//   var path = normalize(absolute(join('.dart_tool', 'sqflite_common_ffi',
//       'databases', 'sqflite_ffi_example.db')));
//   // Create parent directory
//   await Directory(dirname(path)).create(recursive: true);
//   var db = await databaseFactory.openDatabase(path,
//       options: OpenDatabaseOptions(
//           version: 1,
//           onCreate: (db, version) async {
//             await db.execute('''
//     CREATE TABLE Product (
//          id INTEGER PRIMARY KEY AUTOINCREMENT,
//             name TEXT,
//             price REAL,
//             quantity INTEGER,
//             category TEXT,
//             size TEXT
//     )
//     ''');
//           }));

//   // Each time you run the example, a new record is added with a different timestamp.
//   await db.insert(
//       'Product', <String, Object?>{'title': 'Product ${DateTime.now()}'});

//   var result = await db.query('Product');

//   for (var row in result) {
//     print(row);
//   }
//   await db.close();
// }