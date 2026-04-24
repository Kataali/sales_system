import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/ui/empty_screen.dart';
import 'package:sales_system/shared/presentation/ui/loading_overlay.dart';
import 'package:sales_system/src/features/procurements/domain/entities/procurement.dart';
import 'package:sales_system/src/features/procurements/presentation/providers/procurements_provider.dart';
import 'package:sales_system/src/features/procurements/presentation/widgets/create_procurement_dialog.dart';

class ProcurementsView extends ConsumerStatefulWidget {
  const ProcurementsView({super.key});

  @override
  ConsumerState<ProcurementsView> createState() => _ProcurementsViewState();
}

class _ProcurementsViewState extends ConsumerState<ProcurementsView> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProcurementEntity> _applySearch(List<ProcurementEntity> procurements) {
    if (_query.trim().isEmpty) return procurements;

    final query = _query.toLowerCase();
    return procurements.where((procurement) {
      final supplierName = procurement.supplierName?.toLowerCase() ?? '';
      final referenceNumber = procurement.referenceNumber?.toLowerCase() ?? '';
      final userName = procurement.userName?.toLowerCase() ?? '';
      final itemNames = procurement.items
          .map((item) => '${item.productName ?? ''} ${item.productSku ?? ''}')
          .join(' ')
          .toLowerCase();

      return procurement.id.toString().contains(query) ||
          supplierName.contains(query) ||
          referenceNumber.contains(query) ||
          userName.contains(query) ||
          itemNames.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(procurementsControllerProvider);
    final inputSurface = ExtraColors.white;
    final borderColor = ExtraColors.linkLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Procurements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh procurements',
            onPressed: _refreshProcurements,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                  hintText: 'Search by supplier, reference, staff, or item…',
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          Expanded(
            child: state.when(
              data: (procurements) {
                if (procurements.isEmpty) {
                  return const EmptyScreen();
                }

                final filtered = _applySearch(procurements);
                if (filtered.isEmpty) {
                  return const EmptyScreen();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final procurement = filtered[index];
                    return _ProcurementCard(procurement: procurement)
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
              error: (error, _) => Center(child: Text(error.toString())),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateProcurementDialog(context),
        backgroundColor: ExtraColors.link,
        child: const Icon(Icons.add, color: ExtraColors.white),
      ),
    );
  }

  void _showCreateProcurementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateProcurementDialog(),
    );
  }

  void _refreshProcurements() {
    ref.read(procurementsControllerProvider.notifier).fetchProcurements();
  }
}

class _ProcurementCard extends ConsumerStatefulWidget {
  final ProcurementEntity procurement;

  const _ProcurementCard({required this.procurement});

  @override
  ConsumerState<_ProcurementCard> createState() => _ProcurementCardState();
}

class _ProcurementCardState extends ConsumerState<_ProcurementCard> {
  bool _hasRequestedDetails = false;

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(
      procurementDetailControllerProvider(widget.procurement.id),
    );
    final detailedProcurement = detailState.value ?? widget.procurement;

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
          onExpansionChanged: (expanded) {
            if (expanded && !_hasRequestedDetails) {
              _hasRequestedDetails = true;
              ref
                  .read(
                    procurementDetailControllerProvider(widget.procurement.id)
                        .notifier,
                  )
                  .fetchProcurement(widget.procurement.id);
            }
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: ExtraColors.black,
          collapsedIconColor: ExtraColors.black,
          title: Row(
            children: [
              Expanded(
                child: Text(
                  'Procurement #${widget.procurement.id}',
                  style: const TextStyle(
                    color: ExtraColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.green),
                ),
                child: const Text(
                  'COMPLETED',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Wrap(
              spacing: 24,
              runSpacing: 8,
              children: [
                _ProcurementInfo(
                  label: 'Supplier',
                  value:
                      widget.procurement.supplierName?.trim().isNotEmpty == true
                          ? widget.procurement.supplierName!
                          : 'Unspecified',
                ),
                _ProcurementInfo(
                  label: 'Reference',
                  value:
                      widget.procurement.referenceNumber?.trim().isNotEmpty == true
                          ? widget.procurement.referenceNumber!
                          : 'None',
                ),
                _ProcurementInfo(
                  label: 'Processed By',
                  value: widget.procurement.userName ?? 'Unknown',
                ),
                _ProcurementInfo(
                  label: 'Total Cost',
                  value:
                      'GHS ${widget.procurement.totalCost.toStringAsFixed(2)}',
                  valueColor: ExtraColors.black,
                ),
                _ProcurementInfo(
                  label: 'Date',
                  value: _formatDateTime(widget.procurement.procuredAt),
                ),
              ],
            ),
          ),
          children: [
            if (detailState.isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: LoadingOverlay(),
              )
            else
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ExtraColors.lightGrey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ExtraColors.linkLight),
                ),
                child: detailedProcurement.items.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'No procurement items found.',
                          style: TextStyle(
                            color: ExtraColors.darkGrey,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : Column(
                        children: detailedProcurement.items.asMap().entries.map((
                          entry,
                        ) {
                          final index = entry.key;
                          final item = entry.value;
                          final isLast =
                              index == detailedProcurement.items.length - 1;

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
                                  '${item.productSku ?? 'No SKU'}'
                                  '${item.selectedSize != null ? ' | ${item.selectedSize}' : ''}'
                                  ' | Qty ${item.quantity}',
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
                                      'GHS ${item.totalCost.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: ExtraColors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '@ GHS ${item.unitCost.toStringAsFixed(2)}',
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

class _ProcurementInfo extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _ProcurementInfo({
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
