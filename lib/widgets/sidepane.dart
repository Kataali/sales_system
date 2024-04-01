import 'package:flutter/material.dart';
import 'package:sales_system/views/dashboard_view.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
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
      icon: Icon(Icons.home_outlined),
      label: Text("Dashboard"),
      selectedIcon: Icon(Icons.home),
    ),
    const NavigationRailDestination(
      padding: EdgeInsets.symmetric(vertical: 20),
      icon: Icon(Icons.home_outlined),
      label: Text("Report"),
      selectedIcon: Icon(Icons.home),
    ),
    const NavigationRailDestination(
      padding: EdgeInsets.symmetric(vertical: 20),
      icon: Icon(Icons.home_outlined),
      label: Text("Settings"),
      selectedIcon: Icon(Icons.home),
    ),
  ];

  int _selectedIndex = 0;

  void changeDestination(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 1:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DashboardView(),
            ),
          );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;

    return NavigationRail(
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
    );
  }
}
