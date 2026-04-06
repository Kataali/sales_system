import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';

class HomeView extends ConsumerWidget {
  final Widget child;

  const HomeView({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final userRole = ref.watch(authControllerProvider.select((s) => s.value?.role)) ?? 'employee';
    final isAdmin = userRole == 'admin';

    // Define all possible items
    final List<_NavItem> allItems = [
      _NavItem(
        path: '/',
        icon: IconlyLight.home,
        title: 'Home',
      ),
      if (isAdmin) ...[
        _NavItem(
          path: '/dashboard',
          icon: IconlyLight.category,
          title: 'Dashboard',
        ),
        _NavItem(
          path: '/manage-inventory',
          icon: IconlyLight.bag_2,
          title: 'Manage Products',
        ),
      ],
      _NavItem(
        path: '/revenue',
        icon: IconlyLight.wallet,
        title: 'Revenue',
      ),
      _NavItem(
        path: '/settings',
        icon: IconlyLight.setting,
        title: 'Settings',
      ),
    ];

    // Find current index based on location
    int selectedIndex = 0;
    for (int i = 0; i < allItems.length; i++) {
      if (location == allItems[i].path || 
          (allItems[i].path != '/' && location.startsWith(allItems[i].path))) {
        selectedIndex = i;
        break;
      }
    }

    return NavigationView(
      appBar: const NavigationAppBar(
        automaticallyImplyLeading: false,
      ),
      pane: NavigationPane(
        selected: selectedIndex,
        onChanged: (index) {
          context.go(allItems[index].path);
        },
        displayMode: PaneDisplayMode.open,
        items: <PaneItem>[
          for (final item in allItems)
            PaneItem(
              icon: Icon(item.icon, size: 24),
              title: Text(item.title, style: const TextStyle(fontSize: 16)),
              body: child,
            ),
        ],
        footerItems: <PaneItem>[],
      ),
    );
  }
}

class _NavItem {
  final String path;
  final IconData icon;
  final String title;

  _NavItem({required this.path, required this.icon, required this.title});
}
