import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/src/features/deposits/domain/entities/deposit.dart';
import 'package:sales_system/src/features/deposits/presentation/providers/deposits_provider.dart';

class EditDepositDialog extends ConsumerStatefulWidget {
  final Deposit deposit;

  const EditDepositDialog({super.key, required this.deposit});

  @override
  ConsumerState<EditDepositDialog> createState() => _EditDepositDialogState();
}

class _EditDepositDialogState extends ConsumerState<EditDepositDialog> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _expiryDate;
  String? _status;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize form fields with existing deposit data
    _customerNameController.text = widget.deposit.customerName;
    _customerEmailController.text = widget.deposit.customerEmail ?? '';
    _customerPhoneController.text = widget.deposit.customerPhone ?? '';
    _amountController.text = widget.deposit.amount.toString();
    _descriptionController.text = widget.deposit.description ?? '';
    _expiryDate = widget.deposit.expiryDate;
    _status = widget.deposit.status.toString().split('.').last;
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerEmailController.dispose();
    _customerPhoneController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ExtraColors.link,
              onPrimary: ExtraColors.white,
              surface: ExtraColors.white,
              onSurface: ExtraColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _expiryDate) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(depositsControllerProvider.notifier).updateDeposit(
        id: widget.deposit.id,
        customerName: _customerNameController.text.trim(),
        customerEmail: _customerEmailController.text.trim().isEmpty
            ? null
            : _customerEmailController.text.trim(),
        customerPhone: _customerPhoneController.text.trim().isEmpty
            ? null
            : _customerPhoneController.text.trim(),
        amount: double.parse(_amountController.text),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        expiryDate: _expiryDate,
        status: _status,
      );

      await ref.read(depositsControllerProvider.notifier).fetchDeposits();

      if (mounted) {
        Navigator.of(context).pop();
        showAppTopSnackBar(ref.read(navigatorKey), 'Deposit updated successfully');
      }
    } catch (e) {
      if (mounted) {
        showAppTopSnackBar(ref.read(navigatorKey), 'Failed to update deposit: $e', type: 'error');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ExtraColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: ExtraColors.linkLight, width: 1),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Deposit',
                style: TextStyle(
                  color: ExtraColors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Customer Name
              TextFormField(
                controller: _customerNameController,
                style: const TextStyle(color: ExtraColors.black),
                decoration: InputDecoration(
                  labelText: 'Customer Name *',
                  labelStyle: const TextStyle(color: ExtraColors.darkGrey),
                  hintText: 'Enter customer full name',
                  hintStyle: const TextStyle(color: ExtraColors.darkGrey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ExtraColors.link),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ExtraColors.link, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Customer name is required';
                  }
                  if (value.trim().length < 2) {
                    return 'Customer name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Customer Email
              TextFormField(
                controller: _customerEmailController,
                style: const TextStyle(color: ExtraColors.black),
                decoration: InputDecoration(
                  labelText: 'Customer Email',
                  labelStyle: const TextStyle(color: ExtraColors.darkGrey),
                  hintText: 'Enter customer email (optional)',
                  hintStyle: const TextStyle(color: ExtraColors.darkGrey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ExtraColors.link),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ExtraColors.link, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Customer Phone
              TextFormField(
                controller: _customerPhoneController,
                style: const TextStyle(color: ExtraColors.black),
                decoration: InputDecoration(
                  labelText: 'Customer Phone',
                  labelStyle: const TextStyle(color: ExtraColors.darkGrey),
                  hintText: 'Enter customer phone (optional)',
                  hintStyle: const TextStyle(color: ExtraColors.darkGrey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ExtraColors.link),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ExtraColors.link, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountController,
                style: const TextStyle(color: ExtraColors.black),
                decoration: InputDecoration(
                  labelText: 'Deposit Amount (GHS) *',
                  labelStyle: const TextStyle(color: ExtraColors.darkGrey),
                  hintText: 'Enter deposit amount',
                  hintStyle: const TextStyle(color: ExtraColors.darkGrey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ExtraColors.link),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ExtraColors.link, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deposit amount is required';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Status
              DropdownButtonFormField<String>(
                value: _status,
                style: const TextStyle(color: ExtraColors.black),
                dropdownColor: ExtraColors.white,
                decoration: InputDecoration(
                  labelText: 'Status',
                  labelStyle: const TextStyle(color: ExtraColors.darkGrey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ExtraColors.link),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ExtraColors.link, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: DepositStatus.values.map((status) {
                  return DropdownMenuItem<String>(
                    value: status.toString().split('.').last,
                    child: Text(
                      status.toString().split('.').last.toUpperCase(),
                      style: const TextStyle(color: ExtraColors.black),
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _status = value),
              ),
              const SizedBox(height: 16),

              // Expiry Date
              InkWell(
                onTap: () => _selectExpiryDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Expiry Date (Optional)',
                    labelStyle: const TextStyle(color: ExtraColors.darkGrey),
                    hintText: 'Select expiry date',
                    hintStyle: const TextStyle(color: ExtraColors.darkGrey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: ExtraColors.link),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: ExtraColors.link, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: ExtraColors.link,
                    ),
                  ),
                  child: Text(
                    _expiryDate != null
                        ? '${_expiryDate!.month}/${_expiryDate!.day}/${_expiryDate!.year}'
                        : 'No expiry date',
                    style: const TextStyle(color: ExtraColors.black),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: ExtraColors.black),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: const TextStyle(color: ExtraColors.darkGrey),
                  hintText: 'Enter deposit description (optional)',
                  hintStyle: const TextStyle(color: ExtraColors.darkGrey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ExtraColors.link),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ExtraColors.link, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
                maxLength: 500,
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: ExtraColors.black),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ExtraColors.link,
                      foregroundColor: ExtraColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(ExtraColors.white),
                            ),
                          )
                        : const Text('Update Deposit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
