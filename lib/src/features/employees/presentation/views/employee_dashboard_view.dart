import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/ui/loading_overlay.dart';
import 'package:sales_system/src/features/employees/presentation/providers/employee_provider.dart';
import 'package:sales_system/src/features/employees/presentation/widgets/employee_empty_state.dart';
import 'package:sales_system/src/features/employees/presentation/widgets/employee_inventory_card.dart';
import 'package:sales_system/src/features/sales/domain/entities/sale_entity.dart';

class EmployeeDashboardView extends ConsumerWidget {
  const EmployeeDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeeSummaryControllerProvider);

    return Scaffold(
      backgroundColor: ExtraColors.skyBlue,
      appBar: AppBar(
        title: const Text('My Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh dashboard',
            onPressed: () => ref
                .read(employeeSummaryControllerProvider.notifier)
                .fetchSummary(),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: LoadingOverlay()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (summary) {
          final hasNoData =
              summary.todaySales.isEmpty && summary.lowStockProducts.isEmpty;

          return RefreshIndicator(
            onRefresh: () => ref
                .read(employeeSummaryControllerProvider.notifier)
                .fetchSummary(),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 720;
                    return GridView.count(
                      crossAxisCount: isWide ? 3 : 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isWide ? 2.8 : 4.2,
                      children: [
                        _MetricCard(
                          label: 'Today Revenue',
                          value:
                              'GHS ${summary.todayRevenue.toStringAsFixed(2)}',
                          icon: Icons.payments_outlined,
                          color: ExtraColors.emerald,
                        ),
                        _MetricCard(
                          label: 'Today Sales',
                          value: '${summary.todaySales.length}',
                          icon: Icons.receipt_long_outlined,
                          color: ExtraColors.plum,
                        ),
                        _MetricCard(
                          label: 'Low Stock',
                          value: '${summary.lowStockProducts.length}',
                          icon: Icons.inventory_2_outlined,
                          color: ExtraColors.goldenrod,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                if (hasNoData)
                  const SizedBox(
                    height: 360,
                    child: EmployeeEmptyState(
                      icon: Icons.insights_outlined,
                      title: 'No activity yet today',
                      message:
                          'Sales you make today and low-stock alerts will appear here.',
                    ),
                  )
                else ...[
                  _SectionHeader(
                    title: 'Today Sales',
                    subtitle: '${summary.todaySales.length} recorded',
                  ),
                  const SizedBox(height: 10),
                  if (summary.todaySales.isEmpty)
                    const _CompactEmpty(
                      icon: Icons.receipt_long_outlined,
                      text: 'No sales recorded today.',
                    )
                  else
                    ...summary.todaySales.asMap().entries.map(
                        (entry) => _SaleTile(sale: entry.value).animate().fade(
                              duration: 350.ms,
                              delay: (40 * min(entry.key, 10)).ms,
                            )),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: 'Low Stock Products',
                    subtitle: '${summary.lowStockProducts.length} needs review',
                  ),
                  const SizedBox(height: 10),
                  if (summary.lowStockProducts.isEmpty)
                    const _CompactEmpty(
                      icon: Icons.inventory_2_outlined,
                      text: 'No low-stock products right now.',
                    )
                  else
                    ...summary.lowStockProducts.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: EmployeeInventoryCard(item: item),
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: ExtraColors.darkGrey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: ExtraColors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: ExtraColors.black,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(color: ExtraColors.darkGrey, fontSize: 13),
        ),
      ],
    );
  }
}

class _SaleTile extends StatelessWidget {
  final SaleEntity sale;

  const _SaleTile({required this.sale});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ExtraColors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: ExtraColors.linkLight),
      ),
      child: ListTile(
        leading: const Icon(Icons.receipt_long_outlined),
        title: Text(
          'Sale #${sale.id}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle:
            Text('${sale.items.length} item(s) | ${_format(sale.createdAt)}'),
        trailing: Text(
          'GHS ${sale.totalAmount.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  static String _format(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _CompactEmpty extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CompactEmpty({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ExtraColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ExtraColors.linkLight),
      ),
      child: Row(
        children: [
          Icon(icon, color: ExtraColors.darkGrey),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: ExtraColors.darkGrey)),
        ],
      ),
    );
  }
}
