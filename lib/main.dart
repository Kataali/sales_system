import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sales_system/src/core/constants/app_router.dart';
import 'package:sales_system/src/core/providers/theme_provider.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HardwareKeyboard.instance.syncKeyboardState();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Could not load .env file: $e');
  }

  // Custom error handling using Fluent UI
  ErrorWidget.builder = (FlutterErrorDetails details) => ScaffoldPage(
        content: Center(
          child: Text(
            details.exception.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF0000),
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
    final themeMode = ref.watch(themeProvider);

    return FluentApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Food Sales System',
      theme: FluentThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: ExtraColors.lightGrey,
        cardColor: ExtraColors.white,
      ),
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ExtraColors.darkBlue,
        cardColor: ExtraColors.grey,
      ),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
