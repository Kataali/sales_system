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
      child: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              shape: RoundedRectangleBorder(),
              style: ListTileStyle.list,
              hoverColor: Colors.orange,
              selectedColor: Colors.blue,
              leading: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home,
                  ),
                  const Text('Dashboard'),
                ],
              ),
              onTap: () {
                //
              },
            ),
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
              shape: RoundedRectangleBorder(),
              style: ListTileStyle.list,
              hoverColor: Colors.orange,
              textColor: Colors.green,
              leading: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home,
                  ),
                  const Text('Orders'),
                ],
              ),
              onTap: () {
                //
              },
            ),
            //    ListTile(
            // shape:RoundedRectangleBorder()

            // ,
            // style: ListTileStyle.list,
            // hoverColor: Colors.orange,
            // textColor: Colors.green,

            //   leading: Column(
            //     children: [
            //       Icon(
            //         Icons.home,
            //       ),
            //       const Text('Manage Inventory'),
            //     ],
            //   ),

            //   onTap: () {
            //     //
            //   },
            // ),
            //    ListTile(
            // shape:RoundedRectangleBorder()

            // ,
            // style: ListTileStyle.list,
            // hoverColor: Colors.orange,
            // textColor: Colors.green,

            //   leading: Column(
            //     children: [
            //       Icon(
            //         Icons.home,
            //       ),
            //       const Text('Signout'),
            //     ],
            //   ),

            //   onTap: () {
            //     //
            //   },
            // ),
            //    ListTile(
            // shape:RoundedRectangleBorder()

            // ,
            // style: ListTileStyle.list,
            // hoverColor: Colors.orange,
            // textColor: Colors.green,

            //   leading: Column(
            //     children: [
            //       Icon(
            //         Icons.home,
            //       ),
            //       const Text('Settings'),
            //     ],
            //   ),

            //   onTap: () {
            //     //
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
