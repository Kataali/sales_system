import 'package:flutter/material.dart';

class ProductGridCard extends StatefulWidget {
  const ProductGridCard(
      {super.key,
      required this.image,
      required this.name,
      required this.price});
  final String image;
  final String name;
  final double price;

  @override
  State<ProductGridCard> createState() => _ProductGridCardState();
}

class _ProductGridCardState extends State<ProductGridCard> {
  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;

    return Container(
      // height: 100,
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: color.tertiary),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 120,
            backgroundImage: AssetImage(widget.image),
            // child: Image.asset(widget.image),
          ),
          Text(
            widget.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "GHC ${widget.price}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );

    // return GridTile(
    //   header: Text(widget.name),
    //   footer: Text("GHC${widget.price}"),
    //   child: Image.asset(widget.image),
    // );
  }
}
