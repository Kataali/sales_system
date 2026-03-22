import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:sales_system/shared/presentation/ui/loading_overlay.dart';
import 'package:sales_system/src/core/shared/empty_screen.dart';
import 'package:sales_system/src/features/products/presentation/providers/products_provider.dart';
import 'package:sales_system/src/features/products/presentation/views/product_grid_card.dart';
import 'checkout_pane.dart';

class ProductsView extends ConsumerWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsControllerProvider);
    double deviceWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: Row(
        children: [
          productsState.when(
            data: (products) => products.isEmpty
                ? const EmptyScreen()
                : Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: deviceWidth < 1150 ? 2 : 3,
                        childAspectRatio: deviceWidth < 1150 ? 1 / 1 : 6 / 7,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductGridCard(
                          product: product,
                          ref: ref,
                          onTap: () {
                            // Add to checkout logic here if needed
                          },
                        );
                      },
                    ),
                  ),
            loading: () => const Center(child: LoadingOverlay()),
            error: (err, _) => Center(child: Text(err.toString())),
          ),
          if (deviceWidth > 900) const CheckoutPane(),
        ],
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ref.read(productsControllerProvider.notifier).fetchProducts(),
        child: const Icon(IconlyBroken.time_circle),
      ),
    );
  }
}
