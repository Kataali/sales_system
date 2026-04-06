import 'package:flutter/material.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/src/features/products/presentation/views/inventory_view.dart';


class EmptyState extends StatelessWidget {
  final String query;
  final StockFilter filter;
  final VoidCallback onClear;

  const EmptyState({
    super.key,
    required this.query,
    required this.filter,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isSearch = query.isNotEmpty;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: ExtraColors.plum.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSearch
                    ? Icons.search_off_rounded
                    : Icons.inventory_2_outlined,
                color: ExtraColors.plum.withValues(alpha: 0.5),
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isSearch
                  ? 'No results for "$query"'
                  : 'No ${filter.label.toLowerCase()} products',
              style: const TextStyle(
                  color: ExtraColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your search or filter',
              style: TextStyle(color: ExtraColors.darkGrey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onClear,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: ExtraColors.plum.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ExtraColors.plum.withValues(alpha: 0.3)),
                ),
                child: const Text('Clear filters',
                    style: TextStyle(
                        color: ExtraColors.plum,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
