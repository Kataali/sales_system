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
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: color.onPrimary),
      child: Column(
        children: [
          Image.asset(widget.image),
          Text(
            widget.name,
            style: const TextStyle(fontSize: 18, color: Colors.black38),
          ),
          Text(
            "GHC${widget.price}",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
