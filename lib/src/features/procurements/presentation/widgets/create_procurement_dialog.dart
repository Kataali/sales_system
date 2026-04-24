import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/ui/loading_overlay.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/src/features/products/domain/entities/product.dart';
import 'package:sales_system/src/features/products/presentation/providers/products_provider.dart';
import 'package:sales_system/src/features/procurements/presentation/providers/procurements_provider.dart';

class CreateProcurementDialog extends ConsumerStatefulWidget {
  const CreateProcurementDialog({super.key});

  @override
  ConsumerState<CreateProcurementDialog> createState() =>
      _CreateProcurementDialogState();
}

class _CreateProcurementDialogState
    extends ConsumerState<CreateProcurementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _supplierNameController = TextEditingController();
  final _referenceNumberController = TextEditingController();
  final _productSearchController = TextEditingController();
  final List<_DraftProcurementItem> _selectedItems = [];
  String _productQuery = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _supplierNameController.dispose();
    _referenceNumberController.dispose();
    _productSearchController.dispose();
    for (final item in _selectedItems) {
      item.dispose();
    }
    super.dispose();
  }

  void _addProduct(Product product, String size) {
    final existingIndex = _selectedItems.indexWhere(
      (item) => item.product.id == product.id && item.selectedSize == size,
    );

    if (existingIndex != -1) {
      final current =
          int.tryParse(_selectedItems[existingIndex].quantityController.text) ?? 1;
      _selectedItems[existingIndex].quantityController.text =
          (current + 1).toString();
    } else {
      _selectedItems.add(
        _DraftProcurementItem(
          product: product,
          selectedSize: size,
        ),
      );
    }

    _productSearchController.clear();
    setState(() => _productQuery = '');
  }

  void _removeItem(int index) {
    _selectedItems[index].dispose();
    setState(() => _selectedItems.removeAt(index));
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedItems.isEmpty) {
      showAppTopSnackBar(
        ref.read(navigatorKey),
        'Add at least one product to this procurement',
        type: 'error',
      );
      return;
    }

    final payload = <Map<String, dynamic>>[];

    for (final item in _selectedItems) {
      final quantity = int.tryParse(item.quantityController.text.trim());
      final unitCost = double.tryParse(item.unitCostController.text.trim());

      if (quantity == null || quantity <= 0) {
        showAppTopSnackBar(
          ref.read(navigatorKey),
          'Each procurement item must have a quantity greater than 0',
          type: 'error',
        );
        return;
      }

      if (unitCost == null || unitCost < 0) {
        showAppTopSnackBar(
          ref.read(navigatorKey),
          'Each procurement item must have a valid unit cost',
          type: 'error',
        );
        return;
      }

      payload.add({
        'productId': item.product.id,
        'selectedSize': item.selectedSize,
        'quantity': quantity,
        'unitCost': unitCost,
      });
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(procurementsControllerProvider.notifier).createProcurement(
            supplierName: _supplierNameController.text.trim().isEmpty
                ? null
                : _supplierNameController.text.trim(),
            referenceNumber: _referenceNumberController.text.trim().isEmpty
                ? null
                : _referenceNumberController.text.trim(),
            items: payload,
          );

      await ref.read(procurementsControllerProvider.notifier).fetchProcurements();
      await ref.read(productsControllerProvider.notifier).fetchProducts();

      if (mounted) {
        Navigator.of(context).pop();
        showAppTopSnackBar(
          ref.read(navigatorKey),
          'Procurement recorded successfully',
        );
      }
    } catch (e) {
      if (mounted) {
        showAppTopSnackBar(
          ref.read(navigatorKey),
          'Failed to record procurement: $e',
          type: 'error',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsControllerProvider);

    final Color backgroundColor = Theme.of(context).brightness == Brightness.light
        ? ExtraColors.lightBackground
        : ExtraColors.darkBackground;
    final Color textColor = Theme.of(context).brightness == Brightness.light
        ? ExtraColors.darkGrey
        : ExtraColors.lightGrey;

    return Dialog(
      backgroundColor: backgroundColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: ExtraColors.linkLight, width: 1),
      ),
      child: Container(
        width: 900,
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Record Procurement',
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Register inbound stock from a supplier and increase live inventory.',
                style: TextStyle(color: ExtraColors.darkGrey, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SUPPLIER DETAILS',
                              style: TextStyle(
                                color: ExtraColors.darkGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _supplierNameController,
                              style: const TextStyle(color: ExtraColors.black),
                              decoration: _inputDecoration(
                                'Supplier Name',
                                'Enter supplier name (optional)',
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _referenceNumberController,
                              style: const TextStyle(color: ExtraColors.black),
                              decoration: _inputDecoration(
                                'Reference Number',
                                'Invoice or receipt number (optional)',
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'ADD PRODUCTS',
                              style: TextStyle(
                                color: ExtraColors.darkGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _productSearchController,
                              style: const TextStyle(color: ExtraColors.black),
                              onChanged: (value) =>
                                  setState(() => _productQuery = value),
                              decoration: _inputDecoration(
                                'Search Products',
                                'Search by name or SKU…',
                              ).copyWith(
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: ExtraColors.darkGrey,
                                ),
                                suffixIcon: _productQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: ExtraColors.darkGrey,
                                        ),
                                        onPressed: () {
                                          _productSearchController.clear();
                                          setState(() => _productQuery = '');
                                        },
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (_productQuery.isNotEmpty)
                              Container(
                                constraints: const BoxConstraints(maxHeight: 260),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  border: Border.all(color: ExtraColors.linkLight),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: productsState.when(
                                  data: (products) {
                                    final filtered = products
                                        .where(
                                          (product) =>
                                              product.name.toLowerCase().contains(
                                                _productQuery.toLowerCase(),
                                              ) ||
                                              product.sku.toLowerCase().contains(
                                                _productQuery.toLowerCase(),
                                              ),
                                        )
                                        .toList();

                                    if (filtered.isEmpty) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                          'No products found',
                                          style: TextStyle(
                                            color: ExtraColors.darkGrey,
                                          ),
                                        ),
                                      );
                                    }

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: filtered.length,
                                      itemBuilder: (context, index) {
                                        final product = filtered[index];
                                        return ListTile(
                                          title: Text(
                                            product.name,
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${product.sku} | ${product.totalStock} in stock',
                                            style: const TextStyle(
                                              color: ExtraColors.darkGrey,
                                              fontSize: 12,
                                            ),
                                          ),
                                          onTap: () {
                                            if (product.variants.length == 1) {
                                              _addProduct(
                                                product,
                                                product.variants.first.size,
                                              );
                                            } else {
                                              _showVariantPicker(product);
                                            }
                                          },
                                        );
                                      },
                                    );
                                  },
                                  loading: () =>
                                      const Center(child: LoadingOverlay()),
                                  error: (error, _) => Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      error.toString(),
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    const VerticalDivider(color: ExtraColors.link, thickness: 0.5),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PROCUREMENT ITEMS',
                            style: TextStyle(
                              color: ExtraColors.darkGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: _selectedItems.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.local_shipping_outlined,
                                          size: 48,
                                          color:
                                              ExtraColors.link.withOpacity(0.35),
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'No procurement items added yet',
                                          style: TextStyle(
                                            color: ExtraColors.darkGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: _selectedItems.length,
                                    itemBuilder: (context, index) {
                                      final item = _selectedItems[index];
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color:
                                              ExtraColors.lightGrey,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: ExtraColors.linkLight,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        item.product.name,
                                                        style: const TextStyle(
                                                          color:
                                                              ExtraColors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${item.product.sku} | Size: ${item.selectedSize}',
                                                        style: const TextStyle(
                                                          color: ExtraColors.darkGrey,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () =>
                                                      _removeItem(index),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    controller:
                                                        item.quantityController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    style: const TextStyle(
                                                      color: ExtraColors.black,
                                                    ),
                                                    decoration:
                                                        _inputDecoration(
                                                      'Quantity *',
                                                      '0',
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: TextFormField(
                                                    controller:
                                                        item.unitCostController,
                                                    keyboardType:
                                                        const TextInputType
                                                            .numberWithOptions(
                                                      decimal: true,
                                                    ),
                                                    style: const TextStyle(
                                                      color: ExtraColors.black,
                                                    ),
                                                    decoration:
                                                        _inputDecoration(
                                                      'Unit Cost (GHS) *',
                                                      '0.00',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 16,
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: LoadingOverlay(),
                          )
                        : const Text('Record Procurement'),
                  ),
                ],
              ),
            ],
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
    );
  }

  void _showVariantPicker(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ExtraColors.white,
        title: Text(
          'Select Size for ${product.name}',
          style: const TextStyle(color: ExtraColors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: product.variants
              .map(
                (variant) => ListTile(
                  title: Text(
                    variant.size,
                    style: const TextStyle(color: ExtraColors.black),
                  ),
                  subtitle: Text(
                    'Current stock: ${variant.stock}',
                    style: const TextStyle(color: ExtraColors.darkGrey),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() => _addProduct(product, variant.size));
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _DraftProcurementItem {
  final Product product;
  final String selectedSize;
  final TextEditingController quantityController;
  final TextEditingController unitCostController;

  _DraftProcurementItem({
    required this.product,
    required this.selectedSize,
  })  : quantityController = TextEditingController(text: '1'),
        unitCostController = TextEditingController();

  void dispose() {
    quantityController.dispose();
    unitCostController.dispose();
  }
}
