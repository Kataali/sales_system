import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_system/core/constants/app_routes.dart';
import 'package:sales_system/core/constants/theme.dart';
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
        title: 'Food Sales System',
        theme: themeData(),
        // darkTheme: AppTheme.darkThemeMode,
        routes: AppRoutes().getRoutes(),
        home: const SideBar(),
      ),
    );
  }
}
