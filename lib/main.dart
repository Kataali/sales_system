import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_system/constants/app_routes.dart';
import 'package:sales_system/providers/products_provider.dart';
import 'package:sales_system/views/home.dart';

import 'constants/app_theme.dart';

void main() {
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
