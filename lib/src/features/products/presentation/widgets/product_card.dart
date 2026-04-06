import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/src/features/products/domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdjust;

  const ProductCard({super.key, required this.product, required this.onAdjust});

  Color get _stockColor {
    if (product.totalStock == 0) return ExtraColors.crimson;
    if (product.totalStock <= 10) return ExtraColors.yellow;
    return ExtraColors.emerald;
  }

  String get _stockLabel {
    if (product.totalStock == 0) return 'Out of stock';
    if (product.totalStock <= 10) return 'Low stock';
    return 'In stock';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ExtraColors.darkBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ExtraColors.link),
      ),
      child: Column(
        children: [
          // ── Main row ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 64,
                      height: 64,
                      color: ExtraColors.link,
                      child: const Icon(Icons.image_outlined,
                          color: ExtraColors.darkGrey, size: 24),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: ExtraColors.plum.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.inventory_2_outlined,
                          color: ExtraColors.plum, size: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + stock badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                color: ExtraColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _stockColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _stockLabel,
                              style: TextStyle(
                                color: _stockColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // SKU
                      Text(
                        product.sku,
                        style: const TextStyle(
                          color: ExtraColors.darkGrey,
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Total stock + variant count
                      Row(
                        children: [
                          Icon(Icons.layers_rounded,
                              color: _stockColor, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${product.totalStock} units total',
                            style: TextStyle(
                                color: _stockColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                                color: ExtraColors.darkGrey,
                                shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${product.variants.length} size${product.variants.length != 1 ? 's' : ''}',
                            style: const TextStyle(
                                color: ExtraColors.darkGrey,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Variant strip ──────────────────────────────────────────────────
          if (product.variants.isNotEmpty) ...[
            const Divider(
                color: ExtraColors.link, height: 1, indent: 14, endIndent: 14),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: product.variants.map((v) {
                          final isOut = v.stock == 0;
                          final isLow = !isOut && v.stock <= 10;
                          final chipColor = isOut
                              ? ExtraColors.crimson
                              : isLow
                                  ? ExtraColors.yellow
                                  : ExtraColors.emerald;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: chipColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: chipColor.withValues(alpha: 0.25)),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(v.size,
                                      style: const TextStyle(
                                          color: ExtraColors.darkGrey,
                                          fontSize: 10)),
                                  Text(
                                    '${v.stock}',
                                    style: TextStyle(
                                      color: chipColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Adjust button
                  GestureDetector(
                    onTap: onAdjust,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: ExtraColors.plum.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: ExtraColors.plum.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.tune_rounded,
                              color: ExtraColors.plum, size: 14),
                          SizedBox(width: 4),
                          Text('Adjust',
                              style: TextStyle(
                                  color: ExtraColors.plum,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
