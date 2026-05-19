import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/ui/loading_overlay.dart';
import 'package:sales_system/src/features/employees/domain/entities/employee_inventory_item.dart';
import 'package:sales_system/src/features/employees/presentation/providers/employee_provider.dart';
import 'package:sales_system/src/features/employees/presentation/widgets/employee_empty_state.dart';
import 'package:sales_system/src/features/employees/presentation/widgets/employee_inventory_card.dart';

class EmployeeInventoryView extends ConsumerStatefulWidget {
  const EmployeeInventoryView({super.key});

  @override
  ConsumerState<EmployeeInventoryView> createState() =>
      _EmployeeInventoryViewState();
}

class _EmployeeInventoryViewState extends ConsumerState<EmployeeInventoryView> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<EmployeeInventoryItem> _applyFilters(List<EmployeeInventoryItem> items) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return items;

    return items.where((item) {
      return item.productName.toLowerCase().contains(query) ||
          item.productId.toString().contains(query) ||
          item.variant.size.toLowerCase().contains(query) ||
          item.status.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeeInventoryControllerProvider);

    return Scaffold(
      backgroundColor: ExtraColors.skyBlue,
      appBar: AppBar(
        title: const Text('My Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh inventory',
            onPressed: () => ref
                .read(employeeInventoryControllerProvider.notifier)
                .fetchInventory(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                filled: true,
                fillColor: ExtraColors.white,
                hintText: 'Search product, ID, size, or status...',
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
                  borderSide: const BorderSide(color: ExtraColors.linkLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: ExtraColors.linkLight),
                ),
              ),
            ),
          ),
          Expanded(
            child: state.when(
              loading: () => const Center(child: LoadingOverlay()),
              error: (error, _) => Center(child: Text(error.toString())),
              data: (items) {
                if (items.isEmpty) {
                  return const EmployeeEmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'No inventory alerts',
                    message:
                        'Products assigned to your inventory view will appear here.',
                  );
                }

                final filtered = _applyFilters(items);
                if (filtered.isEmpty) {
                  return const EmployeeEmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No matching products',
                    message: 'Try another product name, ID, size, or status.',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => ref
                      .read(employeeInventoryControllerProvider.notifier)
                      .fetchInventory(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => EmployeeInventoryCard(
                      item: filtered[index],
                    )
                        .animate()
                        .fade(
                          duration: 350.ms,
                          delay: (30 * min(index, 16)).ms,
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
