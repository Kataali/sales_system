import 'package:flutter/material.dart';

class sidebar extends StatelessWidget {
  const sidebar({super.key});

  @override
  Widget build(BuildContext context) {
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
