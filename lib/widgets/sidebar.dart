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
    int isSelected =0;
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
