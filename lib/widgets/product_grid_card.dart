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
      height: 250,
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: color.onPrimary),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: ShapeDecoration(
              shape: const CircleBorder(
                eccentricity: 0.5,
                side: BorderSide(
                  width: 0.2,
                ),
              ),
              image: DecorationImage(
                image: AssetImage(widget.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            widget.name,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
          Text(
            "GHC ${widget.price}",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
