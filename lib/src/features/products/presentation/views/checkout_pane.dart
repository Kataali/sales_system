import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';
import 'package:sales_system/src/core/constants/image_constants.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/src/features/cart/presentation/providers/cart_provider.dart';

class CheckoutPane extends ConsumerWidget {
  const CheckoutPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);

    return Container(
      width: 350,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: ExtraColors.black)),
      ),
      child: cartState.when(
        data: (items) {
          if (items.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    ImageAssets.nothing,
                  ),
                ),
                const Text("Cart is empty"),
              ],
            );
          }

          final total = items.fold(
            0.0,
            (sum, item) => sum + item.totalPrice,
          );

          return Column(
            children: [
              const Text(
                "Checkout",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// CART ITEMS
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Card(
                      child: ListTile(
                        title: Text(item.product.name),
                        subtitle: Text("${item.variant.size} | GHS${item.variant.price}"),


                        /// quantity controls
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                final newQuantity = item.quantity - 1;
                                ref
                                    .read(cartControllerProvider.notifier)
                                    .updateQuantity(
                                      item,
                                      newQuantity,
                                    );
                                    // UX feedback with snack bar
                                    final navKey = ref.read(navigatorKey);
                                    showAppTopSnackBar(
                                      navKey,
                                      newQuantity > 0 ? 
                                      "${item.product.name} | ${item.variant.size} Quantity decreased to $newQuantity" 
                                      : "${item.product.name} | ${item.variant.size} removed from cart",
                                      type: 'error',
                                    );
                              },
                            ),
                            Text("${item.quantity}"),
                            IconButton(
                              icon: const Icon(IconlyBroken.plus),
                              onPressed: () {
                                final newQuantity = item.quantity + 1;
                                ref
                                    .read(cartControllerProvider.notifier)
                                    .updateQuantity(
                                      item,
                                      newQuantity,
                                    );
                                    // UX feedback with snack bar
                                    final navKey = ref.read(navigatorKey);
                                    showAppTopSnackBar(
                                      navKey,
                                      "${item.product.name} added to cart",
                                      type: 'success',
                                    );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Divider(),

              /// TOTAL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "\$${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// CHECKOUT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(cartControllerProvider.notifier).checkout();
                  },
                  child: const Text("Complete Sale"),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
