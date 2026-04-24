import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/ui/loading_overlay.dart';
import 'package:sales_system/shared/presentation/ui/empty_screen.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'dart:math';
import 'package:sales_system/src/features/deposits/domain/entities/deposit.dart';
import 'package:sales_system/src/features/deposits/presentation/providers/deposits_provider.dart';
import 'package:sales_system/src/features/deposits/presentation/widgets/create_deposit_dialog.dart';
import 'package:sales_system/src/features/deposits/presentation/widgets/deposit_card.dart';
import 'package:sales_system/src/features/deposits/presentation/widgets/edit_deposit_dialog.dart';

class DepositsView extends ConsumerStatefulWidget {
  const DepositsView({super.key});

  @override
  ConsumerState<DepositsView> createState() => _DepositsViewState();
}

class _DepositsViewState extends ConsumerState<DepositsView> {
  final _searchController = TextEditingController();
  String _query = '';
  String? _statusFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Deposit> _applySearch(List<Deposit> deposits) {
    if (_query.isEmpty && _statusFilter == null) return deposits;

    return deposits.where((deposit) {
      final matchesQuery = _query.isEmpty ||
          deposit.customerName.toLowerCase().contains(_query.toLowerCase());

      final matchesStatus = _statusFilter == null ||
          deposit.status.toString().split('.').last == _statusFilter;

      return matchesQuery && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final depositsState = ref.watch(depositsControllerProvider);
    final inputSurface = ExtraColors.white;
    final cardBorder = ExtraColors.linkLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Deposits"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh deposits',
            onPressed: _refreshDeposits,
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
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
                            border: Border.all(color: cardBorder),
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(
                              color: ExtraColors.black,
                              fontSize: 14,
                            ),
                            onChanged: (value) => setState(() => _query = value),
                            decoration: InputDecoration(
                              hintText: 'Search by customer name…',
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
                          border: Border.all(color: cardBorder),
                        ),
                        child: DropdownButton<String?>(
                          value: _statusFilter,
                          hint: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Filter by status',
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
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('All Status'),
                            ),
                            ...DepositStatus.values.map((status) {
                              return DropdownMenuItem<String?>(
                                value: status.toString().split('.').last,
                                child: Text(status.toString().split('.').last),
                              );
                            }),
                          ],
                          onChanged: (value) => setState(() => _statusFilter = value),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: depositsState.when(
                    data: (deposits) {
                      if (deposits.isEmpty) {
                        return const EmptyScreen();
                      }

                      final filteredDeposits = _applySearch(deposits);
                      if (filteredDeposits.isEmpty) {
                        return const EmptyScreen();
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: filteredDeposits.length,
                        itemBuilder: (context, index) {
                          final deposit = filteredDeposits[index];
                          return DepositCard(
                            deposit: deposit,
                            onTap: () => _showDepositActions(context, deposit),
                            onEdit: () => _showEditDepositDialog(context, deposit),
                            onDelete: () => _showDeleteDepositDialog(context, deposit),
                          )
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDepositDialog(context),
        backgroundColor: ExtraColors.link,
        child: const Icon(Icons.add, color: ExtraColors.white),
      ),
    );
  }

  void _showDepositActions(BuildContext context, Deposit deposit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ExtraColors.white,
        title: const Text(
          'Deposit Actions',
          style: TextStyle(color: ExtraColors.black),
        ),
        content: Text(
          'What would you like to do with ${deposit.customerName}\'s deposit?',
          style: const TextStyle(color: ExtraColors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: ExtraColors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showEditDepositDialog(context, deposit);
            },
            child: const Text('Edit', style: TextStyle(color: ExtraColors.link)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showDeleteDepositDialog(context, deposit);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCreateDepositDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateDepositDialog(),
    );
  }

  void _showEditDepositDialog(BuildContext context, Deposit deposit) {
    showDialog(
      context: context,
      builder: (context) => EditDepositDialog(deposit: deposit),
    );
  }

  void _showDeleteDepositDialog(BuildContext context, Deposit deposit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ExtraColors.white,
        title: const Text(
          'Delete Deposit',
          style: TextStyle(color: ExtraColors.black),
        ),
        content: Text(
          'Are you sure you want to delete the deposit for ${deposit.customerName}? This action cannot be undone.',
          style: const TextStyle(color: ExtraColors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: ExtraColors.black)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(depositsControllerProvider.notifier).deleteDeposit(deposit.id);
                if (context.mounted) {
                  showAppTopSnackBar(ref.read(navigatorKey), 'Deposit deleted successfully');
                }
              } catch (e) {
                if (context.mounted) {
                  showAppTopSnackBar(ref.read(navigatorKey), 'Failed to delete deposit: $e', type: 'error');
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _refreshDeposits() {
    ref.read(depositsControllerProvider.notifier).fetchDeposits();
  }
}
