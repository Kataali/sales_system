import 'package:flutter/material.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/src/features/employees/domain/entities/employee_inventory_item.dart';

class EmployeeInventoryCard extends StatelessWidget {
  final EmployeeInventoryItem item;

  const EmployeeInventoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final stockColor =
        item.variant.stock <= 0 ? ExtraColors.crimson : ExtraColors.goldenrod;

    return Card(
      color: ExtraColors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: ExtraColors.linkLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: stockColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.variant.stock <= 0
                    ? Icons.remove_shopping_cart_outlined
                    : Icons.inventory_2_outlined,
                color: stockColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      color: ExtraColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Product #${item.productId} | Size ${item.variant.size}',
                    style: const TextStyle(
                      color: ExtraColors.darkGrey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${item.variant.stock} left',
                  style: TextStyle(
                    color: stockColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'GHS ${item.variant.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: ExtraColors.darkGrey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
