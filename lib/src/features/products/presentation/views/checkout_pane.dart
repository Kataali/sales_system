import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/theme/dark_theme.dart';
import 'package:sales_system/shared/presentation/theme/light_theme.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';
import 'package:sales_system/shared/presentation/utils/confirmation_dialog.dart';
import 'package:sales_system/src/core/constants/image_constants.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/src/features/cart/domain/entities/cart.dart';
import 'package:sales_system/src/features/cart/presentation/providers/cart_provider.dart';
import 'package:sales_system/src/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:sales_system/src/features/employees/presentation/providers/employee_provider.dart';
import 'package:sales_system/src/features/products/presentation/providers/products_provider.dart';
import 'package:sales_system/src/features/products/presentation/utils/receipt_pdf_saver.dart';
import 'package:sales_system/src/features/reports/presentation/providers/revenue_report_provider.dart';
import 'package:sales_system/src/features/sales/presentation/providers/sales_provider.dart';

class CheckoutPane extends ConsumerStatefulWidget {
  const CheckoutPane({super.key});

  @override
  ConsumerState<CheckoutPane> createState() => _CheckoutPaneState();
}

class _CheckoutPaneState extends ConsumerState<CheckoutPane> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  bool _isCollected = true;

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    super.dispose();
  }

  String _fitLine(String left, String right, {int width = 32}) {
    final cleanLeft = left.trim();
    final cleanRight = right.trim();
    final spaces = width - cleanLeft.length - cleanRight.length;

    if (spaces >= 1) {
      return '$cleanLeft${' ' * spaces}$cleanRight';
    }

    return '$cleanLeft\n${' ' * (width - cleanRight.length).clamp(0, width)}$cleanRight';
  }

  String _divider([int width = 32]) => '-' * width;

  String _buildCheckoutSummary(
    List<CartItem> items,
    double total, {
    required bool isCollected,
    String? customerName,
    String? customerPhone,
  }) {
    final buffer = StringBuffer('Please confirm this sale:\n\nItems:\n');

    for (final item in items) {
      buffer.writeln(
        '- ${item.product.name} (${item.variant.size}) x${item.quantity} | '
        'GHS${item.totalPrice.toStringAsFixed(2)}',
      );
    }

    buffer
      ..writeln(
          '\nCollection Status: ${isCollected ? 'Collected' : 'Pending pick-up'}')
      ..write('Total: GHS${total.toStringAsFixed(2)}');

    if (!isCollected) {
      buffer
        ..writeln()
        ..writeln('Customer: ${customerName ?? ''}')
        ..write('Phone: ${customerPhone ?? ''}');
    }

    return buffer.toString();
  }

  String _buildReceipt(
    List<CartItem> items,
    double total, {
    required bool isCollected,
    String? customerName,
    String? customerPhone,
  }) {
    final now = DateTime.now();
    final buffer = StringBuffer()
      ..writeln('SALE RECEIPT')
      ..writeln(_divider())
      ..writeln(
          'Date: ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}')
      ..writeln('Status: ${isCollected ? 'Collected' : 'Pending pick-up'}')
      ..writeln(_divider())
      ..writeln('Items')
      ..writeln(_divider());

    for (final item in items) {
      final unitPrice = item.variant.price.toStringAsFixed(2);
      final lineTotal = item.totalPrice.toStringAsFixed(2);

      buffer
        ..writeln(item.product.name)
        ..writeln('  ${item.variant.size} x${item.quantity} @ GHS$unitPrice')
        ..writeln(_fitLine('', 'GHS$lineTotal'));
    }

    buffer
      ..writeln(_divider())
      ..writeln(_fitLine('TOTAL', 'GHS${total.toStringAsFixed(2)}'))
      ..writeln(_divider())
      ..writeln('Customer: ${customerName ?? 'Walk-in Customer'}');

    if (!isCollected &&
        customerPhone != null &&
        customerPhone.trim().isNotEmpty) {
      buffer.writeln('Phone: $customerPhone');
    }

    buffer
      ..writeln(_divider())
      ..write('Thank you');

    return buffer.toString();
  }

  Future<Uint8List> _buildReceiptPdf(
    List<CartItem> items,
    double total, {
    required bool isCollected,
    String? customerName,
    String? customerPhone,
  }) async {
    final doc = pw.Document();
    final now = DateTime.now();
    const receiptWidth = 80 * PdfPageFormat.mm;
    final estimatedHeight =
        (140 + (items.length * 26)).toDouble() * PdfPageFormat.mm;

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(
          receiptWidth,
          estimatedHeight,
          marginAll: 6 * PdfPageFormat.mm,
        ),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'SALE RECEIPT',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                'Date: ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                style: const pw.TextStyle(fontSize: 9),
              ),
              pw.Text(
                'Status: ${isCollected ? 'Collected' : 'Pending pick-up'}',
                style: const pw.TextStyle(fontSize: 9),
              ),
              pw.SizedBox(height: 6),
              pw.Divider(),
              ...items.expand(
                (item) => [
                  pw.Text(
                    item.product.name,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          '${item.variant.size} x${item.quantity} @ GHS${item.variant.price.toStringAsFixed(2)}',
                          style: const pw.TextStyle(fontSize: 9),
                        ),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Text(
                        'GHS${item.totalPrice.toStringAsFixed(2)}',
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 6),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL',
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'GHS${total.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Customer: ${customerName ?? 'Walk-in Customer'}',
                style: const pw.TextStyle(fontSize: 9),
              ),
              if (!isCollected &&
                  customerPhone != null &&
                  customerPhone.trim().isNotEmpty)
                pw.Text(
                  'Phone: $customerPhone',
                  style: const pw.TextStyle(fontSize: 9),
                ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'Thank you',
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  Future<String?> _saveReceiptPdf(
    List<CartItem> items,
    double total, {
    required bool isCollected,
    String? customerName,
    String? customerPhone,
  }) async {
    final pdfData = await _buildReceiptPdf(
      items,
      total,
      isCollected: isCollected,
      customerName: customerName,
      customerPhone: customerPhone,
    );
    return saveReceiptPdf(pdfData);
  }

  Future<void> _printReceipt(
    List<CartItem> items,
    double total, {
    required bool isCollected,
    String? customerName,
    String? customerPhone,
  }) async {
    final pdfData = await _buildReceiptPdf(
      items,
      total,
      isCollected: isCollected,
      customerName: customerName,
      customerPhone: customerPhone,
    );
    await Printing.layoutPdf(
      onLayout: (_) async => pdfData,
      name: 'sale_receipt',
    );
  }

  Future<void> _showReceiptDialog(
    BuildContext context,
    List<CartItem> items,
    double total, {
    required bool isCollected,
    String? customerName,
    String? customerPhone,
  }) async {
    final receipt = _buildReceipt(
      items,
      total,
      isCollected: isCollected,
      customerName: customerName,
      customerPhone: customerPhone,
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => fluent.ContentDialog(
        title:
            Text(isCollected ? 'Sale Completed' : 'Pending Pick-up Recorded'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: SelectableText(
              receipt,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ),
        actions: [
          fluent.Button(
            child: const Text('Close'),
            onPressed: () => Navigator.pop(dialogContext),
          ),
          fluent.FilledButton(
            child: const Text('Print Receipt'),
            onPressed: () async {
              Navigator.pop(dialogContext);
              final navKey = ref.read(navigatorKey);
              final receiptText = _buildReceipt(
                items,
                total,
                isCollected: isCollected,
                customerName: customerName,
                customerPhone: customerPhone,
              );
              try {
                await _printReceipt(
                  items,
                  total,
                  isCollected: isCollected,
                  customerName: customerName,
                  customerPhone: customerPhone,
                );
              } on MissingPluginException catch (_) {
                final savedPath = await _saveReceiptPdf(
                  items,
                  total,
                  isCollected: isCollected,
                  customerName: customerName,
                  customerPhone: customerPhone,
                );
                if (savedPath != null) {
                  showAppTopSnackBar(
                    navKey,
                    'Print service unavailable. Receipt saved to $savedPath',
                    type: 'info',
                  );
                } else {
                  await Clipboard.setData(ClipboardData(text: receiptText));
                  showAppTopSnackBar(
                    navKey,
                    'Print service unavailable. Receipt copied to clipboard instead.',
                    type: 'info',
                  );
                }
              } on PlatformException catch (_) {
                final savedPath = await _saveReceiptPdf(
                  items,
                  total,
                  isCollected: isCollected,
                  customerName: customerName,
                  customerPhone: customerPhone,
                );
                if (savedPath != null) {
                  showAppTopSnackBar(
                    navKey,
                    'Printing is unavailable right now. Receipt saved to $savedPath',
                    type: 'info',
                  );
                } else {
                  await Clipboard.setData(ClipboardData(text: receiptText));
                  showAppTopSnackBar(
                    navKey,
                    'Printing is unavailable on this device right now. Receipt copied to clipboard instead.',
                    type: 'info',
                  );
                }
              } catch (e) {
                showAppTopSnackBar(
                  navKey,
                  'Failed to print receipt: $e',
                  type: 'error',
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _refreshSaleDependentData() async {
    await ref.read(productsControllerProvider.notifier).fetchProducts();

    ref
      ..invalidate(dashboardControllerProvider)
      ..invalidate(reportsControllerProvider)
      ..invalidate(salesControllerProvider)
      ..invalidate(employeeSummaryControllerProvider)
      ..invalidate(employeeSalesControllerProvider)
      ..invalidate(employeeInventoryControllerProvider);
  }

  void _checkOut(List<CartItem> items, double total) async {
    if (!_formKey.currentState!.validate()) return;

    final receiptItems = items
        .map(
          (item) => CartItem(
            product: item.product,
            variant: item.variant,
            quantity: item.quantity,
          ),
        )
        .toList();
    final customerName = _customerNameController.text.trim();
    final customerPhone = _customerPhoneController.text.trim();

    // Ask for user confirmation before checkout
    final confirmed = await showCustomDialog(
      context: context,
      title: 'Confirm Sale',
      content: _buildCheckoutSummary(
        receiptItems,
        total,
        isCollected: _isCollected,
        customerName: customerName.isEmpty ? null : customerName,
        customerPhone: customerPhone.isEmpty ? null : customerPhone,
      ),
      type: DialogType.confirmation,
    );

    if (confirmed != true) return; // User canceled
    if (!mounted) return;

    try {
      // Trigger checkout via controller
      final result = await ref.read(cartControllerProvider.notifier).checkout(
            isCollected: _isCollected,
            customerName: customerName.isEmpty ? null : customerName,
            customerPhone: customerPhone.isEmpty ? null : customerPhone,
          );
      await _refreshSaleDependentData();
      if (!mounted) return;

      await _showReceiptDialog(
        context,
        receiptItems,
        result.totalAmount,
        isCollected: result.isCollected,
        customerName: result.customerName,
        customerPhone: result.customerPhone,
      );
    } catch (e) {
      if (!mounted) return;
      // Handle errors with an error dialog
      await showCustomDialog(
        context: context,
        title: 'Sale Failed',
        content: e.toString(),
        type: DialogType.error,
        confirmText: 'OK',
      );
    }
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: ExtraColors.darkGrey),
      hintText: hint,
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
    );
  }

  Widget _collectionOption({
    required String title,
    required String subtitle,
    required bool value,
  }) {
    final isSelected = _isCollected == value;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? ExtraColors.link : ExtraColors.darkGrey,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          setState(() {
            _isCollected = value;
            if (_isCollected) {
              _customerNameController.clear();
              _customerPhoneController.clear();
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected ? ExtraColors.link : ExtraColors.darkGrey,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartControllerProvider);
    final isDarkMode =
        fluent.FluentTheme.of(context).brightness == Brightness.dark;
    final materialTheme = isDarkMode ? darkTheme : lightTheme;
    final fieldTextColor = isDarkMode ? ExtraColors.white : ExtraColors.black;

    return Theme(
      data: materialTheme,
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isDarkMode ? ExtraColors.darkGrey : ExtraColors.black,
            ),
          ),
        ),
        child: cartState.when(
          data: (items) {
            if (items.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      ImageAssets.nothing,
                    ),
                  ),
                  const Text("Cart is empty"),
                ],
              );
            }

            final total = items.fold(
              0.0,
              (sum, item) => sum + item.totalPrice,
            );

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            "Checkout",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: ExtraColors.darkGrey),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'COLLECTION STATUS',
                                  style: TextStyle(
                                    color: ExtraColors.darkGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _collectionOption(
                                  title: 'Collected now',
                                  subtitle:
                                      'Items are being handed to the customer immediately.',
                                  value: true,
                                ),
                                _collectionOption(
                                  title: 'Collect later',
                                  subtitle:
                                      'Save this sale as a pending pick-up and verify the customer.',
                                  value: false,
                                ),
                              ],
                            ),
                          ),
                          if (!_isCollected) ...[
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: ExtraColors.link),
                              ),
                              child: const Text(
                                'Customer verification is required for pending pick-ups.',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _customerNameController,
                              cursorColor: fieldTextColor,
                              style: TextStyle(color: fieldTextColor),
                              decoration: _inputDecoration(
                                'Customer Name *',
                                'Enter customer full name',
                              ),
                              validator: (value) {
                                if (_isCollected) return null;
                                if (value == null || value.trim().isEmpty) {
                                  return 'Customer name is required';
                                }
                                if (value.trim().length < 2) {
                                  return 'Customer name must be at least 2 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _customerPhoneController,
                              cursorColor: fieldTextColor,
                              style: TextStyle(color: fieldTextColor),
                              decoration: _inputDecoration(
                                'Customer Phone *',
                                'Enter customer phone number',
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (_isCollected) return null;
                                if (value == null || value.trim().isEmpty) {
                                  return 'Customer phone is required';
                                }
                                return null;
                              },
                            ),
                          ],
                          const SizedBox(height: 20),

                          /// CART ITEMS
                          ListView.builder(
                            itemCount: items.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = items[index];

                              return Card(
                                child: ListTile(
                                  title: Text(item.product.name),
                                  subtitle: Text(
                                      "${item.variant.size} | GHS${item.variant.price}"),

                                  /// quantity controls
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          final newQuantity = item.quantity - 1;
                                          ref
                                              .read(cartControllerProvider
                                                  .notifier)
                                              .updateQuantity(
                                                item,
                                                newQuantity,
                                              );
                                          // UX feedback with snack bar
                                          final navKey = ref.read(navigatorKey);
                                          showAppTopSnackBar(
                                            navKey,
                                            newQuantity > 0
                                                ? "${item.product.name} | ${item.variant.size} Quantity decreased to $newQuantity"
                                                : "${item.product.name} | ${item.variant.size} removed from cart",
                                            type: 'error',
                                          );
                                        },
                                      ),
                                      Text("${item.quantity}"),
                                      IconButton(
                                        icon: const Icon(IconlyBroken.plus),
                                        onPressed: () {
                                          final newQuantity = item.quantity + 1;
                                          ref
                                              .read(cartControllerProvider
                                                  .notifier)
                                              .updateQuantity(
                                                item,
                                                newQuantity,
                                              );
                                          // UX feedback with snack bar
                                          final navKey = ref.read(navigatorKey);
                                          showAppTopSnackBar(
                                            navKey,
                                            "${item.product.name} added to cart",
                                            type: 'success',
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(),

                  /// TOTAL
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "GHS${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// CHECKOUT BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _checkOut(items, total);
                      },
                      child: Text(
                        _isCollected ? "Complete Sale" : "Save Pending Pick-up",
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) {
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
