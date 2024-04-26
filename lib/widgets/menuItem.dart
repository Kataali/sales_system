import 'package:flutter/material.dart';

class menuItem extends StatefulWidget {
  String name ="";
  Icon icon =Icon(Icons.home);
   menuItem({
    required String name,
    required Icon icon ,
    super.key});
  
  @override
  State<menuItem> createState() => _menuItemState();
}

class _menuItemState extends State<menuItem> {
  
  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return ListTile(
          shape:RoundedRectangleBorder(),     
              iconColor:Colors.black  ,
              textColor: Colors.black,
              focusColor: color.primary,
              hoverColor: color.primary,
              selectedColor: color.primary,
             
      title:  Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.icon,              
                    
                     Text(widget.name,style: TextStyle(fontSize: 12,color: Colors.black),),
                  ],
                ),


    );
  }
}





class SideNavTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  SideNavTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }
}
