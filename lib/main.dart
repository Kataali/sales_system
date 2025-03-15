import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_system/core/constants/app_routes.dart';
import 'package:sales_system/providers/cart_provider.dart';

import 'package:sales_system/services/db/db_service.dart';
import 'package:sales_system/providers/products_provider.dart';
import 'package:sales_system/views/home.dart';

import 'core/constants/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Custom error handling
  ErrorWidget.builder = (FlutterErrorDetails details) => Material(
        color: Colors.teal,
        child: Center(
          child: Text(
            details.exception.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      );

  // Impotant: Initialize Database
  await DBService.initializeDatabase();

  // print(await DBService.seeTables());
  // await DBService.insertProduct('Sausage', 20, 40, 'Chicken', 'large',
  //     imgUrl: 'assets/sausages.jpg');
  // await DBService.insertProduct('Chicken', 20, 40, 'Chicken', 'large',
  //     imgUrl: 'assets/full-chicken.jpg');
  // await DBService.insertProduct('Gizzard', 20, 40, 'Chicken', 'large',
  //     imgUrl: 'assets/gizard.webp');
  // await DBService.insertProduct('Liver', 20, 40, 'Beef', 'large',
  //     imgUrl: 'assets/liver.jpg');
  // await DBService.insertProduct('Sausage', 20, 40, 'Sausage', 'large',
  //     imgUrl: 'assets/sausages.jpg');
  // await DBService.insertProduct('Fish', 20, 40, 'Fish', 'large',
  //     imgUrl: 'assets/fish.jpg');

  // print(await DBService.getProducts());
  // Clear Database
  // await DBService.clearDataBase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductsProvider>(
            create: (_) => ProductsProvider()),
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
      ],
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