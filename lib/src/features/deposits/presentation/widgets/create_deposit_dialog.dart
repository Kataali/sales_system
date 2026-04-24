import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/src/features/deposits/presentation/providers/deposits_provider.dart';
import 'package:sales_system/shared/presentation/ui/loading_overlay.dart';

class CreateDepositDialog extends ConsumerStatefulWidget {
  const CreateDepositDialog({super.key});

  @override
  ConsumerState<CreateDepositDialog> createState() => _CreateDepositDialogState();
}

class _CreateDepositDialogState extends ConsumerState<CreateDepositDialog> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _expiryDate;
  bool _isLoading = false;

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
      initialDate: DateTime.now().add(const Duration(days: 30)),
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
      await ref.read(depositsControllerProvider.notifier).createDeposit(
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
      );

      await ref.read(depositsControllerProvider.notifier).fetchDeposits();

      if (mounted) {
        Navigator.of(context).pop();
        showAppTopSnackBar(ref.read(navigatorKey), 'Deposit created successfully');
      }
    } catch (e) {
      if (mounted) {
        showAppTopSnackBar(ref.read(navigatorKey), 'Failed to create deposit: $e', type: 'error');
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: ExtraColors.linkLight, width: 1),
      ),
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create New Deposit',
                  style: TextStyle(
                    color: ExtraColors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create a customer credit balance that can be used on future sales.',
                  style: TextStyle(color: ExtraColors.darkGrey, fontSize: 14),
                ),
                const SizedBox(height: 24),
                const Text(
                  'CUSTOMER INFORMATION',
                  style: TextStyle(
                    color: ExtraColors.darkGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _customerNameController,
                  style: const TextStyle(color: ExtraColors.black),
                  decoration: _inputDecoration(
                    'Customer Name *',
                    'Enter customer full name',
                  ),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _customerEmailController,
                  style: const TextStyle(color: ExtraColors.black),
                  decoration: _inputDecoration(
                    'Customer Email',
                    'Enter customer email (optional)',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _customerPhoneController,
                  style: const TextStyle(color: ExtraColors.black),
                  decoration: _inputDecoration(
                    'Customer Phone',
                    'Enter customer phone (optional)',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                const Text(
                  'DEPOSIT DETAILS',
                  style: TextStyle(
                    color: ExtraColors.darkGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  style: const TextStyle(color: ExtraColors.black),
                  decoration: _inputDecoration(
                    'Deposit Amount (GHS) *',
                    'Enter deposit amount',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Required';
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) return 'Must be > 0';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _selectExpiryDate(context),
                  child: InputDecorator(
                    decoration: _inputDecoration(
                      'Expiry Date (Optional)',
                      'Select expiry date',
                    ).copyWith(
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: ExtraColors.link,
                        size: 18,
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
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(color: ExtraColors.black),
                  decoration: _inputDecoration(
                    'Description',
                    'Add an internal note (optional)',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.of(context).pop(),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: LoadingOverlay(),
                            )
                          : const Text('Create Deposit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: ExtraColors.darkGrey, fontSize: 14),
      hintText: hint,
      hintStyle: const TextStyle(color: ExtraColors.darkGrey, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: ExtraColors.link), borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: ExtraColors.link, width: 2), borderRadius: BorderRadius.circular(8)),
      errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(8)),
      focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red, width: 2), borderRadius: BorderRadius.circular(8)),
    );
  }
}
