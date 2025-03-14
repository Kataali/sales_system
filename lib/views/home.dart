import 'package:flutter/material.dart';
import 'package:sales_system/views/dashboard_view.dart';
import 'package:sales_system/views/not_found_view.dart';
import 'package:sales_system/views/products.dart';
import 'package:sales_system/views/manage_inventory_view.dart';
import 'package:sales_system/views/revenue.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int _selectedIndex = 0;

  final List<NavigationRailDestination> _destinations = [
    const NavigationRailDestination(
      padding: EdgeInsets.symmetric(vertical: 20),
      icon: Icon(
        Icons.home_outlined,
      ),
      label: Text("Home"),
      selectedIcon: Icon(
        Icons.home,
      ),
    ),
    const NavigationRailDestination(
      padding: EdgeInsets.symmetric(vertical: 20),
      icon: Icon(Icons.dashboard_outlined),
      label: Text("Dashboard"),
      selectedIcon: Icon(Icons.dashboard),
    ),
    const NavigationRailDestination(
      padding: EdgeInsets.symmetric(vertical: 20),
      icon: Icon(Icons.inventory_outlined),
      label: Text("Manage Products"),
      selectedIcon: Icon(Icons.inventory),
    ),
    const NavigationRailDestination(
      padding: EdgeInsets.symmetric(vertical: 20),
      icon: Icon(Icons.monetization_on_outlined),
      label: Text("Revenue"),
      selectedIcon: Icon(Icons.monetization_on),
    ),
    const NavigationRailDestination(
      padding: EdgeInsets.symmetric(vertical: 20),
      icon: Icon(Icons.settings_outlined),
      label: Text("Settings"),
      selectedIcon: Icon(Icons.settings),
    ),
  ];

  Widget changeDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        return const HomeView();
      case 1:
        return const DashboardView();
      case 2:
        return const ManageInventoryView();
      case 3:
        return const RevenueView();
      default:
        return const NotFoundView();
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return Row(
      children: [
        NavigationRail(
          destinations: _destinations,
          selectedIndex: _selectedIndex,
          indicatorColor: color.onPrimary,
          onDestinationSelected: changeDestination,
          useIndicator: false,
          labelType: NavigationRailLabelType.all,
          elevation: 5,
          selectedIconTheme: IconThemeData(color: color.onSecondary, size: 40),
          selectedLabelTextStyle: TextStyle(color: color.onSecondary),
          minWidth: 100,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(width: 2, color: color.onSecondary),
          ),
        ),
        Expanded(
          child: changeDestination(_selectedIndex),
        ),
      ],
    );
  }
}
