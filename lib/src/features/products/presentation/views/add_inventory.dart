import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_iconly_plus/flutter_iconly_plus.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/src/features/products/domain/entities/product.dart';
import 'package:sales_system/src/features/products/presentation/providers/products_provider.dart';
import 'package:sales_system/widgets/app_text_field.dart';

class AddInventoryView extends ConsumerStatefulWidget {
  static const routeName = '/add-inventory';

  const AddInventoryView({super.key});

  @override
  ConsumerState<AddInventoryView> createState() => _AddInventoryViewState();
}

class _AddInventoryViewState extends ConsumerState<AddInventoryView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController(text: 'PRD-001');
  final List<_VariantDraft> _variants = [_VariantDraft()];
  bool _isSaving = false;
  bool _skuEditedManually = false;
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;

  @override
  void initState() {
    super.initState();
    _skuController.text = _generateSku(_nameController.text);
    _nameController.addListener(_handleNameChanged);
    _skuController.addListener(_handleSkuChanged);
  }

  int get _totalStock =>
      _variants.fold(0, (sum, item) => sum + item.stockValue);

  @override
  void dispose() {
    _nameController.removeListener(_handleNameChanged);
    _skuController.removeListener(_handleSkuChanged);
    _nameController.dispose();
    _skuController.dispose();
    for (final variant in _variants) {
      variant.dispose();
    }
    super.dispose();
  }

  String _generateSku(String name) {
    final base = name
        .trim()
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');

    if (base.isEmpty) return 'PRD-001';
    return 'PRD-$base';
  }

  void _handleNameChanged() {
    if (_skuEditedManually) return;

    final generatedSku = _generateSku(_nameController.text);
    if (_skuController.text == generatedSku) return;

    _skuController.value = TextEditingValue(
      text: generatedSku,
      selection: TextSelection.collapsed(offset: generatedSku.length),
    );
  }

  void _handleSkuChanged() {
    final generatedSku = _generateSku(_nameController.text);
    final current = _skuController.text.trim();
    _skuEditedManually = current.isNotEmpty && current != generatedSku;
  }

  void _addVariant() {
    setState(() => _variants.add(_VariantDraft()));
  }

  void _removeVariant(int index) {
    if (_variants.length == 1) return;
    setState(() {
      _variants[index].dispose();
      _variants.removeAt(index);
    });
  }

  Future<void> _pickImage() async {
    try {
      const imageTypeGroup = XTypeGroup(
        label: 'images',
        extensions: ['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'],
      );
      final file = await openFile(acceptedTypeGroups: [imageTypeGroup]);
      if (file == null) return;

      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) return;

      setState(() {
        _selectedImageBytes = bytes;
        _selectedImageName = file.name;
      });
    } catch (e) {
      if (!mounted) return;
      final errorText = e.toString();
      final platformHint = errorText.toLowerCase().contains('linux')
          ? ' Ensure this is running in a desktop session with file-dialog support.'
          : '';
      showAppTopSnackBar(
        ref.read(navigatorKey),
        'Could not open image picker: $errorText.$platformHint',
        type: 'error',
      );
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImageBytes = null;
      _selectedImageName = null;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final navKey = ref.read(navigatorKey);
    final variants = _variants
        .map(
          (variant) => ProductVariant(
            size: variant.sizeController.text.trim(),
            price: double.parse(variant.priceController.text.trim()),
            stock: int.parse(variant.stockController.text.trim()),
          ),
        )
        .toList();

    setState(() => _isSaving = true);

    try {
      await ref.read(productsControllerProvider.notifier).createProduct(
            name: _nameController.text.trim(),
            imageBytes: _selectedImageBytes,
            imageName: _selectedImageName,
            sku: _skuController.text.trim(),
            variants: variants,
            totalStock: _totalStock,
          );
      await ref.read(productsControllerProvider.notifier).fetchProducts();

      if (!mounted) return;
      showAppTopSnackBar(navKey, 'Product added successfully');
      context.pop();
    } catch (e) {
      if (!mounted) return;
      showAppTopSnackBar(navKey, e.toString(), type: 'error');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String? _requiredValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }

  String? _priceValidator(String? value) {
    final required = _requiredValidator(value, 'Price');
    if (required != null) return required;
    final parsed = double.tryParse(value!.trim());
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid price';
    }
    return null;
  }

  String? _stockValidator(String? value) {
    final required = _requiredValidator(value, 'Stock');
    if (required != null) return required;
    final parsed = int.tryParse(value!.trim());
    if (parsed == null || parsed < 0) {
      return 'Enter a valid stock value';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: PageHeader(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: IconButton(
            icon: const Icon(FluentIcons.back, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        title: const Text('Add New Product'),
      ),
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 760),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(
                  title: 'Product Details',
                  subtitle:
                      'Capture the product information from your backend model.',
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _nameController,
                  label: 'Product Name',
                  hint: 'Enter product name',
                  prefixIcon: const Icon(IconlyLight.bag),
                  validator: (value) =>
                      _requiredValidator(value, 'Product name'),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _skuController,
                  label: 'SKU',
                  hint: 'Auto-generated, but editable',
                  prefixIcon: const Icon(IconlyLight.ticket),
                  validator: (value) => _requiredValidator(value, 'SKU'),
                ),
                const SizedBox(height: 20),
                InfoLabel(
                  label: 'Product Image',
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: FluentTheme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: FluentTheme.of(context)
                            .resources
                            .dividerStrokeColorDefault,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(FluentIcons.photo2),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedImageName ?? 'No image selected',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Button(
                          onPressed: _pickImage,
                          child: const Text('Choose Image'),
                        ),
                        if (_selectedImageBytes != null) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(FluentIcons.chrome_close),
                            onPressed: _clearImage,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    const Expanded(
                      child: _SectionTitle(
                        title: 'Variants',
                        subtitle:
                            'Add each size option with its price and stock.',
                      ),
                    ),
                    Button(
                      onPressed: _addVariant,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(FluentIcons.add),
                          SizedBox(width: 8),
                          Text('Add Variant'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...List.generate(
                  _variants.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _VariantCard(
                      index: index,
                      variant: _variants[index],
                      canRemove: _variants.length > 1,
                      onRemove: () => _removeVariant(index),
                      sizeValidator: (value) =>
                          _requiredValidator(value, 'Variant size'),
                      priceValidator: _priceValidator,
                      stockValidator: _stockValidator,
                      onChanged: () => setState(() {}),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _SummaryCard(
                    totalStock: _totalStock, variantCount: _variants.length),
                const SizedBox(height: 28),
                SizedBox(
                  width: 220,
                  child: FilledButton(
                    onPressed: _isSaving ? null : _submit,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: ProgressRing(),
                            )
                          : const Text('Save Product'),
                    ),
                  ),
                ),
              ].animate(interval: 40.ms).fade().slideX(begin: 0.04),
            ),
          ),
        ),
      ],
    );
  }
}

class _VariantDraft {
  final sizeController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController(text: '0');

  int get stockValue => int.tryParse(stockController.text.trim()) ?? 0;

  void dispose() {
    sizeController.dispose();
    priceController.dispose();
    stockController.dispose();
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: FluentTheme.of(context).inactiveColor,
          ),
        ),
      ],
    );
  }
}

class _VariantCard extends StatelessWidget {
  final int index;
  final _VariantDraft variant;
  final bool canRemove;
  final VoidCallback onRemove;
  final VoidCallback onChanged;
  final String? Function(String?) sizeValidator;
  final String? Function(String?) priceValidator;
  final String? Function(String?) stockValidator;

  const _VariantCard({
    required this.index,
    required this.variant,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
    required this.sizeValidator,
    required this.priceValidator,
    required this.stockValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FluentTheme.of(context).resources.dividerStrokeColorDefault,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Variant ${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (canRemove)
                IconButton(
                  icon: const Icon(FluentIcons.delete),
                  onPressed: onRemove,
                ),
            ],
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: variant.sizeController,
            label: 'Size',
            hint: 'Small, Medium, 1L, Box of 12...',
            prefixIcon: const Icon(IconlyLight.category),
            validator: sizeValidator,
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: variant.priceController,
                  label: 'Price',
                  hint: '0.00',
                  prefixIcon: const Icon(FluentIcons.money),
                  keyboardType: TextInputType.number,
                  validator: priceValidator,
                  onChanged: (_) => onChanged(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  controller: variant.stockController,
                  label: 'Stock',
                  hint: '0',
                  prefixIcon: const Icon(IconlyLight.buy),
                  keyboardType: TextInputType.number,
                  validator: stockValidator,
                  onChanged: (_) => onChanged(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int totalStock;
  final int variantCount;

  const _SummaryCard({
    required this.totalStock,
    required this.variantCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).micaBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(FluentIcons.product_list),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$variantCount variant${variantCount == 1 ? '' : 's'} configured',
            ),
          ),
          Text(
            'Total Stock: $totalStock',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
