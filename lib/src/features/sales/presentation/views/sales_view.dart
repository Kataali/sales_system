import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/ui/empty_screen.dart';
import 'package:sales_system/shared/presentation/ui/loading_overlay.dart';
import 'package:sales_system/src/features/sales/domain/entities/sale_entity.dart';
import 'package:sales_system/src/features/sales/presentation/providers/sales_provider.dart';

class SalesView extends ConsumerStatefulWidget {
  const SalesView({super.key});

  @override
  ConsumerState<SalesView> createState() => _SalesViewState();
}

class _SalesViewState extends ConsumerState<SalesView> {
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
      final matchesCollection = _isCollectedFilter == null ||
          sale.isCollected == _isCollectedFilter;

      if (!matchesCollection) return false;

      if (_query.trim().isEmpty) return true;

      final query = _query.toLowerCase();
      final saleId = sale.id.toString();
      final customerName = sale.customerName?.toLowerCase() ?? '';
      final customerPhone = sale.customerPhone?.toLowerCase() ?? '';
      final userName = sale.userName?.toLowerCase() ?? '';
      final itemNames = sale.items
          .map((item) => '${item.productName ?? ''} ${item.productSku ?? ''}')
          .join(' ')
          .toLowerCase();

      return saleId.contains(query) ||
          customerName.contains(query) ||
          customerPhone.contains(query) ||
          userName.contains(query) ||
          itemNames.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final salesState = ref.watch(salesControllerProvider);
    final inputSurface = ExtraColors.white;
    final borderColor = ExtraColors.linkLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh sales',
            onPressed: _refreshSales,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: inputSurface,
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
                        hintText: 'Search by sale ID, customer, staff, or item…',
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
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: inputSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                  ),
                  child: DropdownButton<bool?>(
                    value: _isCollectedFilter,
                    hint: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Filter by collection',
                        style: TextStyle(
                          color: ExtraColors.darkGrey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    dropdownColor: ExtraColors.white,
                    style: const TextStyle(
                      color: ExtraColors.black,
                      fontSize: 14,
                    ),
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem<bool?>(
                        value: null,
                        child: Text('All Sales'),
                      ),
                      DropdownMenuItem<bool?>(
                        value: true,
                        child: Text('Collected'),
                      ),
                      DropdownMenuItem<bool?>(
                        value: false,
                        child: Text('Pending Pick-up'),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => _isCollectedFilter = value),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: salesState.when(
              data: (sales) {
                if (sales.isEmpty) {
                  return const EmptyScreen();
                }

                final filteredSales = _applyFilters(sales);
                if (filteredSales.isEmpty) {
                  return const EmptyScreen();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: filteredSales.length,
                  itemBuilder: (context, index) {
                    final sale = filteredSales[index];
                    return _SaleCard(sale: sale)
                        .animate()
                        .fade(
                          duration: 400.ms,
                          delay: (20 * min(index, 20)).ms,
                        )
                        .slideY(
                          begin: 0.1,
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
    );
  }

  void _refreshSales() {
    ref.read(salesControllerProvider.notifier).fetchSales();
  }
}

class _SaleCard extends StatelessWidget {
  final SaleEntity sale;

  const _SaleCard({required this.sale});

  @override
  Widget build(BuildContext context) {
    final collectionColor = sale.isCollected ? Colors.green : Colors.orange;
    final customerLabel = sale.customerName?.trim().isNotEmpty == true
        ? sale.customerName!
        : 'Walk-in Customer';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: ExtraColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ExtraColors.linkLight),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: ExtraColors.black,
          collapsedIconColor: ExtraColors.black,
          title: Row(
            children: [
              Expanded(
                child: Text(
                  'Sale #${sale.id}',
                  style: const TextStyle(
                    color: ExtraColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: collectionColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: collectionColor),
                ),
                child: Text(
                  sale.isCollected ? 'COLLECTED' : 'PENDING',
                  style: TextStyle(
                    color: collectionColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 24,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                      label: 'Amount',
                      value: 'GHS ${sale.totalAmount.toStringAsFixed(2)}',
                      valueColor: ExtraColors.black,
                    ),
                    _InfoChip(
                      label: 'Staff',
                      value: sale.userName ?? 'Unknown',
                    ),
                    _InfoChip(
                      label: 'Customer',
                      value: customerLabel,
                    ),
                    _InfoChip(
                      label: 'Date',
                      value: _formatDateTime(sale.createdAt),
                    ),
                  ],
                ),
                if (!sale.isCollected &&
                    (sale.customerPhone?.trim().isNotEmpty == true)) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Verification Phone: ${sale.customerPhone}',
                    style: const TextStyle(
                      color: ExtraColors.darkGrey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: ExtraColors.lightGrey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ExtraColors.linkLight),
                ),
              child: sale.items.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No sale items found for this sale.',
                        style: TextStyle(
                          color: ExtraColors.darkGrey,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : Column(
                      children: sale.items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        final isLast = index == sale.items.length - 1;

                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              title: Text(
                                item.productName ?? 'Unknown Product',
                                style: const TextStyle(
                                  color: ExtraColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${item.productSku ?? 'No SKU'} | ${item.selectedSize} | Qty ${item.quantity}',
                                style: const TextStyle(
                                  color: ExtraColors.darkGrey,
                                  fontSize: 12,
                                ),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'GHS ${item.totalAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: ExtraColors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  ),
                                  Text(
                                    '@ GHS ${item.unitPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: ExtraColors.darkGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!isLast)
                              Divider(
                                height: 1,
                                color: ExtraColors.link.withOpacity(0.18),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _InfoChip({
    required this.label,
    required this.value,
    this.valueColor = ExtraColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: ExtraColors.darkGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
