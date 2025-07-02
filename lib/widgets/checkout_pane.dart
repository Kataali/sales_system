import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_system/core/shared/empty_screen.dart';
import 'package:sales_system/core/utils/dialog.dart';
import 'package:sales_system/widgets/elevated_button.dart';

import '../providers/cart_provider.dart';
import 'product_checkout_card.dart';

class CheckoutPane extends StatefulWidget {
  const CheckoutPane({super.key, required this.width});
  final double width;

  @override
  State<CheckoutPane> createState() => _CheckoutPaneState();
}

class _CheckoutPaneState extends State<CheckoutPane> {
  void clearCart() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    final cart = Provider.of<CartProvider>(context, listen: true);

    return Container(
      width: widget.width,
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
          Consumer<CartProvider>(
            builder: (BuildContext context, CartProvider value, Widget? child) {
              return Expanded(
                child: value.checkedoutProductsLength == 0
                    ? const EmptyScreen()
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        itemBuilder: (context, index) {
                          return ProductCheckoutCard(
                            name: value.checkedoutProducts[index].name!,
                            price: value.checkedoutProducts[index].price!,
                            size: value.checkedoutProducts[index].size!,
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
            padding: const EdgeInsets.only(bottom: 5),
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: color.tertiary),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                      Text(
                        cart.total.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
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
                      child: CustomElevatedButton(
                        // Background must be red
                        buttonText: "Cancel",
                        onPressed: () {
                          // Clear cart/Checkout
                          clearCart();
                        },
                        leading: const Icon(
                          Icons.cancel,
                          size: 30,
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      width: 10,
                      thickness: 0.01,
                    ),
                    Expanded(
                      child: CustomElevatedButton(
                          // Background must be green
                          leading: const Icon(
                            Icons.check_circle_outline,
                            size: 30,
                          ),
                          buttonText: "Proceed",
                          onPressed: () {
                            CustomDialog.showPopUp(
                                context,
                                "Test Alert",
                                "This is just a test to show the dialog.",
                                "ok",
                                'null', () {
                              Navigator.pop(context);
                            }, () {
                              Navigator.pop(context);
                            });
                          }),
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
