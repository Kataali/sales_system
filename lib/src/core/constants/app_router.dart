import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/shared/presentation/ui/not_authorized_view.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:sales_system/src/features/authentication/presentation/views/login_view.dart';
import 'package:sales_system/src/features/authentication/presentation/views/signup_view.dart';
import 'package:sales_system/src/features/products/presentation/views/add_inventory.dart';
import 'package:sales_system/src/features/products/presentation/views/products.dart';
import 'package:sales_system/src/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:sales_system/src/features/reports/presentation/views/revenue_report_view.dart';
import 'package:sales_system/views/home.dart';
import 'package:sales_system/src/features/products/presentation/views/inventory_view.dart';
import 'package:sales_system/views/not_found_view.dart';
import 'package:sales_system/src/features/settings/presentation/views/settings_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:sales_system/src/features/authentication/presentation/views/profile_view.dart';
import 'package:sales_system/src/features/authentication/presentation/views/change_password_view.dart';
import 'package:sales_system/src/features/authentication/presentation/views/add_employee_view.dart';
import 'package:sales_system/src/features/authentication/presentation/views/manage_employees_view.dart';
import 'package:sales_system/src/features/deposits/presentation/views/deposits_view.dart';
import 'package:sales_system/src/features/employees/presentation/views/employee_dashboard_view.dart';
import 'package:sales_system/src/features/employees/presentation/views/employee_inventory_view.dart';
import 'package:sales_system/src/features/employees/presentation/views/employee_sales_view.dart';
import 'package:sales_system/src/features/procurements/presentation/views/procurements_view.dart';
import 'package:sales_system/src/features/sales/presentation/views/sales_view.dart';

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.02),
            end: Offset.zero,
          ).animate(CurveTween(curve: Curves.easeOutCubic).animate(animation)),
          child: child,
        ),
      );
    },
  );
}

final routerProvider = Provider((ref) {
  // Watch only properties that trigger a redirect to avoid full app rebuilds during loading/error
  final isLoggedIn =
      ref.watch(authControllerProvider.select((s) => s.value != null));
  final mustChange = ref.watch(authControllerProvider
      .select((s) => s.value?.mustChangePassword ?? false));
  final role = ref
      .watch(authControllerProvider.select((s) => s.value?.role ?? 'employee'));

  final rootNavigatorKey = ref.watch(navigatorKey);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    // Redirect to login if user isn't authenticated, or prevent going to login if they are
    redirect: (context, state) {
      final isGoingToLogin = state.matchedLocation == '/login';

      // PUBLIC ROUTES (No auth needed)
      if (isGoingToLogin || state.matchedLocation == '/signup') return null;

      // AUTH CHECK
      if (!isLoggedIn) return '/login';

      // FORCED PASSWORD CHANGE
      if (mustChange && state.matchedLocation != '/change-password') {
        return '/change-password';
      }

      // RBAC CHECK
      final isAdmin = role == 'admin';
      final location = state.matchedLocation;

      // SPECIFIC ALLOWANCES
      // These routes are ALWAYS allowed for anyone logged in
      if (location == '/' ||
          location == '/revenue' ||
          location == '/employee-dashboard' ||
          location == '/employee-inventory' ||
          location == '/employee-sales' ||
          location == '/settings' ||
          location == '/profile' ||
          location == '/change-password' ||
          location == '/unauthorized') {
        return null;
      }

      // ADMIN-ONLY ROUTES
      final adminOnlyRoutes = [
        '/dashboard',
        '/manage-inventory',
        '/add-inventory',
        '/manage-employees',
        '/add-employee',
        '/deposits',
        '/procurements',
        '/sales',
      ];

      // If they are trying to reach an admin-only route and are NOT an admin
      bool isTargetingAdminRoute = false;
      for (final route in adminOnlyRoutes) {
        if (location == route || location.startsWith('$route/')) {
          isTargetingAdminRoute = true;
          break;
        }
      }

      if (isTargetingAdminRoute && !isAdmin) {
        print("RBAC: Redirecting employee from $location to unauthorized");
        return '/unauthorized';
      }

      return null;
    },

    initialLocation: '/',
    routes: [
      // GoRoute(
      //   path: '/',
      //   builder: (context, state) => const HomeView(),
      // ),
      // GoRoute(
      //   path: '/details/:id', // Path parameter
      //   builder: (context, state) {
      //     final id = state.pathParameters['id']!;
      //     return DetailsScreen(id: id);
      //   },
      // ),
      ShellRoute(
        builder: (context, state, child) {
          return HomeView(child: child); // inject routed page
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context, state: state, child: const ProductsView()),
          ),
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context, state: state, child: const DashboardView()),
          ),
          GoRoute(
            path: '/employee-dashboard',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const EmployeeDashboardView(),
            ),
          ),
          GoRoute(
            path: '/revenue',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const RevenueReportView()),
          ),
          GoRoute(
            path: '/products',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context, state: state, child: const ProductsView()),
          ),
          GoRoute(
            path: '/manage-inventory',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context, state: state, child: const InventoryView()),
          ),
          GoRoute(
            path: '/employee-inventory',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const EmployeeInventoryView(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context, state: state, child: const SettingsView()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context, state: state, child: const ProfileView()),
          ),
          GoRoute(
            path: '/change-password',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const ChangePasswordView()),
          ),
          GoRoute(
            path: '/add-employee',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context, state: state, child: const AddEmployeeView()),
          ),
          GoRoute(
            path: '/manage-employees',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const ManageEmployeesView()),
          ),
          GoRoute(
            path: '/deposits',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context, state: state, child: const DepositsView()),
          ),
          GoRoute(
            path: '/procurements',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const ProcurementsView(),
            ),
          ),
          GoRoute(
            path: '/sales',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const SalesView(),
            ),
          ),
          GoRoute(
            path: '/employee-sales',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const EmployeeSalesView(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/unauthorized',
        builder: (context, state) => const UnauthorizedScreen(),
      ),
      //   GoRoute(
      //   path: '/dashboard',
      //   builder: (context, state) => const DashboardView(),
      // ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context, state: state, child: const LoginView()),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupView(),
      ),
      // GoRoute(
      //   path: '/revenue',
      //   builder: (context, state) => const RevenueView(),
      // ),
      GoRoute(
        path: '/add-inventory',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context, state: state, child: const AddInventoryView()),
      ),
      // GoRoute(
      //   path: '/products',
      //   builder: (context, state) => const ProductsView(),
      // ),
      // GoRoute(
      //   path: '/manage-inventory',
      //   builder: (context, state) => const ManageInventoryView(),
      // ),
    ],
    errorBuilder: (context, state) => const NotFoundView(),
  );
});
