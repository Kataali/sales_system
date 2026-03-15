import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/src/features/cart/presentation/providers/cart_provider.dart';
import 'package:sales_system/src/features/cart/presentation/widgets/variant_selector_sheet.dart';
import '../../domain/entities/product.dart';

class ProductGridCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final WidgetRef ref;

  const ProductGridCard({
    super.key,
    required this.product,
    this.onTap,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: ExtraColors.lightGrey,
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Image.asset(
                    'assets/fallback.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Remove from checkout button

                // Product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "SKU: ${product.sku}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        "Stock: ${product.totalStock}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (product.variants.isNotEmpty)
                        Text(
                          "GHS${product.variants.first.price}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),
                // Add to Cart Button
                IconButton(
                  icon: const Icon(
                    IconlyLight.plus,
                    size: 50,
                  ),
                  onPressed: () {
                    // Handle add to cart logic
                    if (product.variants.length == 1) {
                      ref.read(cartControllerProvider.notifier).addItem(
                            product,
                            product.variants.first,
                          );
                      // UX feedback with snack bar
                      final navKey = ref.read(navigatorKey);
                      showAppTopSnackBar(
                        navKey,
                        "${product.name} | ${product.variants.first.size} added to cart",
                        type: 'success',
                      );
                    } else {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => VariantSelectorSheet(product: product),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
