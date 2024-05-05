import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_system/providers/products_provider.dart';

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
            thickness: 1,
          ),
          Consumer<ProductsProvider>(
            builder:
                (BuildContext context, ProductsProvider value, Widget? child) {
              return Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  itemBuilder: (context, index) {
                    return ProductCheckoutCard(
                      name: value.checkedoutProducts[index].name,
                      price: value.checkedoutProducts[index].price,
                      size: value.checkedoutProducts[index].size,
                      deleteCheckedOutProduct: () {
                        value.removeCheckedoutProduct(
                            value.checkedoutProducts[index]);
                      },
                    );
                  },
                  itemCount: value.checkedoutProductsLength,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      height: 10,
                      thickness: 0.001,
                    );
                  },
                ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: color.tertiary),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                      Text(
                        "200",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15),
                      )
                    ],
                  ),
                ),
                const Divider(
                  height: 8,
                  thickness: 0.01,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: color.onBackground,
                          foregroundColor: color.secondary,
                        ),
                        onPressed: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.cancel),
                            Text("Cancel"),
                          ],
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      width: 10,
                      thickness: 0.01,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: color.onSecondary,
                          foregroundColor: color.secondary,
                        ),
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
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
