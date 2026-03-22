// import 'package:fluent_ui/fluent_ui.dart'; // Only if needed for legacy code
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:sales_system/src/core/constants/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Custom error handling using Fluent UI
  ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
        body: Center(
          child: Text(
            details.exception.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ),
      );

  // Initialize your local database
  // await DBService.initializeDatabase();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Food Sales System',
      // theme: FluentThemeData(),
      // darkTheme: AppTheme.darkThemeMode, // Optional
      routerConfig: router,
      // home: const SideBar(),
      // home: LoginView(),
    
    );
  }
}
