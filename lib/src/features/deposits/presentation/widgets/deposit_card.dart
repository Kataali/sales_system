import 'package:flutter/material.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/src/features/deposits/domain/entities/deposit.dart';

class DepositCard extends StatelessWidget {
  final Deposit deposit;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DepositCard({
    super.key,
    required this.deposit,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  Color _getStatusColor(DepositStatus status) {
    switch (status) {
      case DepositStatus.active:
        return Colors.green;
      case DepositStatus.used:
        return Colors.blue;
      case DepositStatus.refunded:
        return Colors.orange;
      case DepositStatus.expired:
        return Colors.red;
    }
  }

  String _formatCurrency(double amount) {
    return 'GHS ${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: ExtraColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ExtraColors.linkLight),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      deposit.customerName,
                      style: const TextStyle(
                        color: ExtraColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(deposit.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(deposit.status),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      deposit.status.toString().split('.').last.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(deposit.status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildAmountInfo(
                      'Amount',
                      _formatCurrency(deposit.amount),
                      ExtraColors.black,
                    ),
                  ),
                  Expanded(
                    child: _buildAmountInfo(
                      'Remaining',
                      _formatCurrency(deposit.remainingAmount),
                      deposit.remainingAmount > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  Expanded(
                    child: _buildAmountInfo(
                      'Used',
                      _formatCurrency(deposit.usedAmount),
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              if (deposit.customerEmail != null || deposit.customerPhone != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (deposit.customerEmail != null) ...[
                      const Icon(
                        Icons.email,
                        color: ExtraColors.darkGrey,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          deposit.customerEmail!,
                          style: const TextStyle(
                            color: ExtraColors.darkGrey,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    if (deposit.customerPhone != null) ...[
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.phone,
                        color: ExtraColors.darkGrey,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        deposit.customerPhone!,
                        style: const TextStyle(
                          color: ExtraColors.darkGrey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              if (deposit.expiryDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: ExtraColors.darkGrey,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Expires: ${_formatDate(deposit.expiryDate!)}',
                      style: const TextStyle(
                        color: ExtraColors.darkGrey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
              if (deposit.description != null && deposit.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  deposit.description!,
                  style: const TextStyle(
                    color: ExtraColors.black,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                'Created: ${_formatDate(deposit.createdAt)}',
                style: const TextStyle(
                  color: ExtraColors.darkGrey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onEdit != null)
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, color: ExtraColors.link, size: 20),
                      tooltip: 'Edit Deposit',
                    ),
                  if (onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                      tooltip: 'Delete Deposit',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountInfo(String label, String amount, Color amountColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: ExtraColors.darkGrey,
            fontSize: 12,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: amountColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
