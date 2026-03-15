import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:sales_system/src/features/authentication/presentation/views/login_view.dart';
import 'package:sales_system/src/features/authentication/presentation/views/signup_view.dart';
import 'package:sales_system/src/features/products/presentation/views/add_inventory.dart';
import 'package:sales_system/src/features/products/presentation/views/manage_inventory_view.dart';
import 'package:sales_system/src/features/products/presentation/views/products.dart';
import 'package:sales_system/views/dashboard_view.dart';
import 'package:sales_system/views/home.dart';
import 'package:sales_system/views/not_found_view.dart';
import 'package:sales_system/views/revenue.dart';

final routerProvider = Provider((ref) {
  final authState = ref.watch(authControllerProvider); // Listen to your auth logic
  final rootNavigatorKey = ref.watch(navigatorKey);
  
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    // refreshListenable: MyRiverpodListenable(ref), // Custom helper
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login';

      if (authState.value == null) {
        return '/login'; // Force login if not authenticated
      }
      if (loggingIn) {
        return '/'; // Go home if they try to visit login while logged in
      }
      return null; // No redirect needed
    },
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
    ),
    // GoRoute(
    //   path: '/details/:id', // Path parameter
    //   builder: (context, state) {
    //     final id = state.pathParameters['id']!;
    //     return DetailsScreen(id: id);
    //   },
    // ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardView(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginView(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupView(),
    ),
    GoRoute(
      path: '/revenue',
      builder: (context, state) => const RevenueView(),
    ),
    GoRoute(
      path: '/add-inventory',
      builder: (context, state) => const AddInventoryView(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductsView(),
    ),
    GoRoute(
      path: '/manage-inventory',
      builder: (context, state) => const ManageInventoryView(),
    ),
  ],
  errorBuilder: (context, state) => const NotFoundView(),
);
});
