import 'package:flutter/material.dart';

import 'product_checkout_card.dart';

class CheckoutPane extends StatefulWidget {
  const CheckoutPane({super.key});

  @override
  State<CheckoutPane> createState() => _CheckoutPaneState();
}

class _CheckoutPaneState extends State<CheckoutPane> {
  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;

    return Container(
      width: 400,
      color: color.onPrimary,
      child: Column(
        children: [
          const Text(
            "Product Checkout",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(
            height: 15,
            thickness: 0.001,
          ),
          // Expanded(
          //   child: ListView(
          //     children: const [
          //       ProductCheckoutCard(
          //           name: "Schezwan Egg noodles", price: 20, size: 'medium'),
          //       ProductCheckoutCard(
          //           name: "Schezwan Egg noodles", price: 20, size: 'medium'),
          //       ProductCheckoutCard(
          //           name: "Schezwan Egg noodles", price: 20, size: 'medium'),
          //       ProductCheckoutCard(
          //           name: "Schezwan Egg noodles", price: 20, size: 'medium'),
          //       ProductCheckoutCard(
          //           name: "Schezwan Egg noodles", price: 20, size: 'medium'),
          //     ],
          //   ),
          // ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Icon(Icons.cancel),
                      Text("Cancel"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_outline),
                      Text("Proceed"),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
