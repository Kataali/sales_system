import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key, required this.currentIndex});
  final int currentIndex;

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

  late int _selectedIndex;

  void changeDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        Navigator.pushNamed(context, "/home");
      case 1:
        Navigator.pushNamed(context, '/dashboard');
      case 2:
        Navigator.pushNamed(context, '/manage_inventory');
      case 3:
        Navigator.pushNamed(context, '/revenue');
    }
  }

  @override
  // void initState() {
  //   setState(() {
  //     _selectedIndex = widget.currentIndex;
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    _selectedIndex = widget.currentIndex;

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
