import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/ui/loading_overlay.dart';
import 'package:sales_system/src/features/products/domain/entities/product.dart';
import 'package:sales_system/src/features/products/presentation/providers/products_provider.dart';
import 'package:sales_system/src/features/products/presentation/widgets/empty_state.dart';
import 'package:sales_system/src/features/products/presentation/widgets/error_state.dart';
import 'dart:math';
import 'package:sales_system/src/features/products/presentation/widgets/product_card.dart';
import 'package:sales_system/src/features/products/presentation/widgets/stock_adjust_sheet.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FILTER ENUM
// ─────────────────────────────────────────────────────────────────────────────

enum StockFilter { all, healthy, low, out }

extension StockFilterX on StockFilter {
  String get label => switch (this) {
        StockFilter.all => 'All',
        StockFilter.healthy => 'Healthy',
        StockFilter.low => 'Low Stock',
        StockFilter.out => 'Out of Stock',
      };

  Color get color => switch (this) {
        StockFilter.all => ExtraColors.plum,
        StockFilter.healthy => ExtraColors.emerald,
        StockFilter.low => ExtraColors.yellow,
        StockFilter.out => ExtraColors.crimson,
      };

  bool matches(Product p) => switch (this) {
        StockFilter.all => true,
        StockFilter.healthy => p.totalStock > 10,
        StockFilter.low => p.totalStock > 0 && p.totalStock <= 10,
        StockFilter.out => p.totalStock == 0,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN VIEW
// ─────────────────────────────────────────────────────────────────────────────

class InventoryView extends ConsumerStatefulWidget {
  static const routeName = '/inventory';
  const InventoryView({super.key});

  @override
  ConsumerState<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends ConsumerState<InventoryView> {
  final _searchController = TextEditingController();
  String _query = '';
  StockFilter _filter = StockFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> _applyFilters(List<Product> products) {
    return products.where((p) {
      final matchesFilter = _filter.matches(p);
      final matchesSearch = _query.isEmpty ||
          p.name.toLowerCase().contains(_query.toLowerCase()) ||
          p.sku.toLowerCase().contains(_query.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _openStockSheet(Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ExtraColors.transparent,
      builder: (_) => StockAdjustSheet(
        product: product,
        onSaved: () {
          // TODO: call your update provider here, then refresh the list
          // ref.read(productsControllerProvider.notifier).updateStock(...)
          ref.invalidate(productsControllerProvider);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productsControllerProvider);

    return Scaffold(
      backgroundColor: ExtraColors.blue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Inventory',
                          style: TextStyle(
                            color: ExtraColors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                        state.when(
                          data: (products) => Text(
                            '${products.length} products',
                            style: const TextStyle(
                                color: ExtraColors.darkGrey, fontSize: 13),
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  // Add product button
                  GestureDetector(
                    onTap: () {
                      // TODO: navigate to add product screen
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [ExtraColors.plum, ExtraColors.turquoise],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: ExtraColors.plum.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: ExtraColors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Search bar ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: ExtraColors.darkBlue,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ExtraColors.link),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                      color: ExtraColors.white, fontSize: 14),
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search by name or SKU…',
                    hintStyle: const TextStyle(
                        color: ExtraColors.darkGrey, fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: ExtraColors.darkGrey, size: 20),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded,
                                color: ExtraColors.darkGrey, size: 18),
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

            const SizedBox(height: 14),

            // ── Filter chips ─────────────────────────────────────────────────
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: StockFilter.values.map((f) {
                  final selected = _filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _filter = f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected
                              ? f.color.withValues(alpha: 0.18)
                              : ExtraColors.darkBlue,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? f.color.withValues(alpha: 0.5)
                                : ExtraColors.link,
                          ),
                        ),
                        child: Text(
                          f.label,
                          style: TextStyle(
                            color: selected
                                ? f.color
                                : ExtraColors.darkGrey,
                            fontSize: 12,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // ── Product list ─────────────────────────────────────────────────
            Expanded(
              child: state.when(
                data: (products) {
                  final filtered = _applyFilters(products);

                  if (filtered.isEmpty) {
                    return EmptyState(
                      query: _query,
                      filter: _filter,
                      onClear: () => setState(() {
                        _query = '';
                        _filter = StockFilter.all;
                        _searchController.clear();
                      }),
                    );
                  }

                  return RefreshIndicator(
                    color: ExtraColors.plum,
                    backgroundColor: ExtraColors.darkBlue,
                    onRefresh: () async =>
                        ref.invalidate(productsControllerProvider),
                    child: ListView.separated(
                      padding:
                          const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (_, i) => ProductCard(
                        product: filtered[i],
                        onAdjust: () => _openStockSheet(filtered[i]),
                      ).animate().fade(duration: 400.ms, delay: (50 * min(i, 10)).ms).slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOutCubic),
                    ),
                  );
                },
                loading: () => const Center(child: LoadingOverlay()),
                error: (e, _) => ErrorState(
                  error: e.toString(),
                  onRetry: () =>
                      ref.invalidate(productsControllerProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
