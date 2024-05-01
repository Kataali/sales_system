import 'package:flutter/material.dart';
import 'package:sales_system/widgets/menuItem.dart';

class sidebar extends StatefulWidget {
  const sidebar({super.key});

  @override
  State<sidebar> createState() => _sidebarState();
}

class _sidebarState extends State<sidebar> {
  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    int isSelected = 0;
    return Container(
      width: 100,
      child: ListView(
        children: [
          // menuItem(name: "Dashboard",icon: Icon(Icons.abc, ) ),
          ListTile(
            enabled: true,
            // selected: isSelected,
            shape: const RoundedRectangleBorder(),
            iconColor: Colors.black,
            textColor: Colors.black,
            focusColor: color.primary,
            hoverColor: color.primary,
            selectedColor: const Color.fromARGB(255, 26, 172, 46),
            selectedTileColor: Colors.yellow,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.home,
                  // color: color.onPrimary,
                ),
                Text(
                  'Dashboard',
                  style: TextStyle(),
                ),
              ],
            ),

            onTap: () {
              print("clicked");
              setState(() {
                // isSelected=true;
              });
            },
          ),

          ListTile(
            shape: const RoundedRectangleBorder(),
            style: ListTileStyle.list,
            iconColor: Colors.black,
            textColor: Colors.black,
            hoverColor: Colors.orange,
            selectedColor: Colors.blue,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_grocery_store_outlined,
                ),
                Text(
                  'Orders',
                  style: TextStyle(),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            onTap: () {
              //
            },
          ),

          ListTile(
            shape: const RoundedRectangleBorder(),
            style: ListTileStyle.list,
            hoverColor: Colors.orange,
            selectedColor: Colors.blue,
            iconColor: Colors.black,
            textColor: Colors.black,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_outlined,
                ),
                Text(
                  'Inventory ',
                ),
              ],
            ),
            onTap: () {
              //
            },
          ),

          ListTile(
            shape: const RoundedRectangleBorder(),
            style: ListTileStyle.list,
            hoverColor: Colors.orange,
            iconColor: Colors.black,
            textColor: Colors.black,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.monetization_on_outlined,
                ),
                Text(
                  'Revenue',
                ),
              ],
            ),
            onTap: () {
              //
            },
          ),

          ListTile(
            shape: const RoundedRectangleBorder(),
            style: ListTileStyle.list,
            hoverColor: Colors.orange,
            iconColor: Colors.black,
            textColor: Colors.black,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.settings,
                ),
                Text(
                  'Settings',
                ),
              ],
            ),
            onTap: () {
              //
            },
          ),

          ListTile(
            shape: const RoundedRectangleBorder(),
            style: ListTileStyle.list,
            hoverColor: Colors.orange,
            iconColor: Colors.black,
            textColor: Colors.black,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout_outlined,
                ),
                Text(
                  'Logout',
                ),
              ],
            ),
            onTap: () {
              //
            },
          ),
        ],
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _selectedIndex = 0;

//   List<Widget> _widgetOptions = <Widget>[
//     Text('Page 1'),
//     Text('Page 2'),
//     Text('Page 3'),
//     // Add more pages as needed
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Horizontal Side Navbar Example'),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               child: Text('Side Navbar'),
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//             ),
//             SideNavTile(
//               title: 'Page 1',
//               onTap: () {
//                 setState(() {
//                   _selectedIndex = 0;
//                   Navigator.pop(context);
//                 });
//               },
//             ),
//             SideNavTile(
//               title: 'Page 2',
//               onTap: () {
//                 setState(() {
//                   _selectedIndex = 1;
//                   Navigator.pop(context);
//                 });
//               },
//             ),
//             SideNavTile(
//               title: 'Page 3',
//               onTap: () {
//                 setState(() {
//                   _selectedIndex = 2;
//                   Navigator.pop(context);
//                 });
//               },
//             ),
//             // Add more list tiles for additional pages
//           ],
//         ),
//       ),
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//     );
//   }
// }
