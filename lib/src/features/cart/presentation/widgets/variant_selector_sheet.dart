import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/src/features/cart/presentation/providers/cart_provider.dart';
import 'package:sales_system/src/features/products/domain/entities/product.dart';

class VariantSelectorSheet extends ConsumerWidget {
  final Product product;

  const VariantSelectorSheet({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            product.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          ...product.variants.map((variant) {
            return Card(
              child: ListTile(
                title: Text(variant.size),
                subtitle: Text("\$${variant.price}"),
                trailing: Text("Stock: ${variant.stock}"),
                onTap: () {
                  ref.read(cartControllerProvider.notifier).addItem(
                        product,
                        variant,
                      );
                  // UX feedback with snack bar
                  final navKey = ref.read(navigatorKey);
                  showAppTopSnackBar(
                    navKey,
                    "${product.name} | ${variant.size} added to cart",
                    type: 'success',
                  );
                  Navigator.pop(context);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
