import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/ui/loading_overlay.dart';
import 'package:sales_system/shared/presentation/ui/empty_screen.dart';
import 'dart:math';
import 'package:sales_system/src/features/products/domain/entities/product.dart';
import 'package:sales_system/src/features/products/presentation/providers/products_provider.dart';
import 'package:sales_system/src/features/products/presentation/views/product_grid_card.dart';
import 'checkout_pane.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProductsView extends ConsumerStatefulWidget {
  const ProductsView({super.key});

  @override
  ConsumerState<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<ProductsView> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> _applySearch(List<Product> products) {
    if (_query.isEmpty) return products;

    final query = _query.toLowerCase();
    return products.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.sku.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsControllerProvider);
    final deviceWidth = MediaQuery.sizeOf(context).width;
    final searchSurface = ExtraColors.white;
    final borderColor = ExtraColors.linkLight;

    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: searchSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        color: ExtraColors.black,
                        fontSize: 14,
                      ),
                      onChanged: (value) => setState(() => _query = value),
                      decoration: InputDecoration(
                        hintText: 'Search by name or SKU…',
                        hintStyle: const TextStyle(
                          color: ExtraColors.darkGrey,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: ExtraColors.grey,
                          size: 20,
                        ),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: ExtraColors.darkGrey,
                                  size: 18,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _query = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: productsState.when(
                    data: (products) {
                      if (products.isEmpty) {
                        return const EmptyScreen();
                      }

                      final filteredProducts = _applySearch(products);
                      if (filteredProducts.isEmpty) {
                        return const EmptyScreen();
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: deviceWidth < 1150 ? 2 : 3,
                          childAspectRatio:
                              deviceWidth < 1150 ? 1 / 1 : 6 / 7,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ProductGridCard(
                            product: product,
                            ref: ref,
                            onTap: () {
                              // Add to checkout logic here if needed
                            },
                          )
                              .animate()
                              .fade(
                                duration: 400.ms,
                                delay: (40 * min(index, 20)).ms,
                              )
                              .scaleXY(
                                begin: 0.9,
                                duration: 400.ms,
                                curve: Curves.easeOutBack,
                              );
                        },
                      );
                    },
                    loading: () => const Center(child: LoadingOverlay()),
                    error: (err, _) => Center(child: Text(err.toString())),
                  ),
                ),
              ],
            ),
          ),
          if (deviceWidth > 900)
            const CheckoutPane().animate().slideX(
              begin: 1,
              duration: 500.ms,
              curve: Curves.easeOutCubic,
            ),
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
