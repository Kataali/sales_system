import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/ui/loading_overlay.dart';
import 'package:sales_system/src/features/employees/presentation/providers/employee_provider.dart';
import 'package:sales_system/src/features/employees/presentation/widgets/employee_empty_state.dart';
import 'package:sales_system/src/features/sales/domain/entities/sale_entity.dart';

class EmployeeSalesView extends ConsumerStatefulWidget {
  const EmployeeSalesView({super.key});

  @override
  ConsumerState<EmployeeSalesView> createState() => _EmployeeSalesViewState();
}

class _EmployeeSalesViewState extends ConsumerState<EmployeeSalesView> {
  final _searchController = TextEditingController();
  String _query = '';
  bool? _isCollectedFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SaleEntity> _applyFilters(List<SaleEntity> sales) {
    return sales.where((sale) {
      if (_isCollectedFilter != null &&
          sale.isCollected != _isCollectedFilter) {
        return false;
      }

      final query = _query.trim().toLowerCase();
      if (query.isEmpty) return true;

      final itemText = sale.items
          .map((item) => '${item.productId} ${item.selectedSize}')
          .join(' ')
          .toLowerCase();

      return sale.id.toString().contains(query) ||
          (sale.customerName?.toLowerCase().contains(query) ?? false) ||
          (sale.customerPhone?.toLowerCase().contains(query) ?? false) ||
          itemText.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final salesState = ref.watch(employeeSalesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh sales',
            onPressed: () =>
                ref.read(employeeSalesControllerProvider.notifier).fetchSales(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ExtraColors.white,
                      hintText: 'Search sale ID, customer, or item...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: ExtraColors.linkLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: ExtraColors.linkLight),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<bool?>(
                  value: _isCollectedFilter,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All')),
                    DropdownMenuItem(value: true, child: Text('Collected')),
                    DropdownMenuItem(value: false, child: Text('Pending')),
                  ],
                  onChanged: (value) =>
                      setState(() => _isCollectedFilter = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: salesState.when(
              loading: () => const Center(child: LoadingOverlay()),
              error: (error, _) => Center(child: Text(error.toString())),
              data: (sales) {
                if (sales.isEmpty) {
                  return const EmployeeEmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'No sales yet',
                    message: 'Sales you complete will show up here.',
                  );
                }

                final filteredSales = _applyFilters(sales);
                if (filteredSales.isEmpty) {
                  return const EmployeeEmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No matching sales',
                    message: 'Try a different search or collection filter.',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => ref
                      .read(employeeSalesControllerProvider.notifier)
                      .fetchSales(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredSales.length,
                    itemBuilder: (context, index) => _EmployeeSaleCard(
                      sale: filteredSales[index],
                    )
                        .animate()
                        .fade(
                          duration: 350.ms,
                          delay: (25 * min(index, 16)).ms,
                        )
                        .slideY(begin: 0.08, duration: 350.ms),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmployeeSaleCard extends StatelessWidget {
  final SaleEntity sale;

  const _EmployeeSaleCard({required this.sale});

  @override
  Widget build(BuildContext context) {
    final collectionColor =
        sale.isCollected ? ExtraColors.emerald : ExtraColors.goldenrod;

    return Card(
      color: ExtraColors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: ExtraColors.linkLight),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Sale #${sale.id}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              'GHS ${sale.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              _MiniLabel(value: _formatDateTime(sale.createdAt)),
              _MiniLabel(
                value: sale.isCollected ? 'Collected' : 'Pending pick-up',
                color: collectionColor,
              ),
              _MiniLabel(
                value: sale.customerName?.trim().isNotEmpty == true
                    ? sale.customerName!
                    : 'Walk-in customer',
              ),
            ],
          ),
        ),
        children: [
          if (sale.items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'No items were returned for this sale.',
                style: TextStyle(color: ExtraColors.darkGrey),
              ),
            )
          else
            ...sale.items.map(
              (item) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text('Product #${item.productId}'),
                subtitle:
                    Text('Size ${item.selectedSize} | Qty ${item.quantity}'),
                trailing: Text(
                  'GHS ${item.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _MiniLabel extends StatelessWidget {
  final String value;
  final Color color;

  const _MiniLabel({required this.value, this.color = ExtraColors.darkGrey});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
    );
  }
}
