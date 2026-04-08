import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';
import 'package:sales_system/shared/presentation/utils/confirmation_dialog.dart';
import 'package:sales_system/src/core/constants/image_constants.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/src/features/cart/domain/entities/cart.dart';
import 'package:sales_system/src/features/cart/presentation/providers/cart_provider.dart';
import 'package:sales_system/src/features/products/presentation/utils/receipt_pdf_saver.dart';
import 'package:sales_system/src/features/products/presentation/providers/products_provider.dart';

class CheckoutPane extends ConsumerWidget {
  const CheckoutPane({super.key});

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

  String _buildCheckoutSummary(List<CartItem> items, double total) {
    final buffer = StringBuffer('Please confirm this sale:\n\nItems:\n');

    for (final item in items) {
      buffer.writeln(
        '- ${item.product.name} (${item.variant.size}) x${item.quantity} | '
        'GHS${item.totalPrice.toStringAsFixed(2)}',
      );
    }

    buffer.write('\nTotal: GHS${total.toStringAsFixed(2)}');
    return buffer.toString();
  }

  String _buildReceipt(List<CartItem> items, double total) {
    final now = DateTime.now();
    final buffer = StringBuffer()
      ..writeln('SALE RECEIPT')
      ..writeln(_divider())
      ..writeln('Date: ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}')
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
      ..write('Thank you');

    return buffer.toString();
  }

  Future<Uint8List> _buildReceiptPdf(
    List<CartItem> items,
    double total,
  ) async {
    final doc = pw.Document();
    final now = DateTime.now();
    const receiptWidth = 80 * PdfPageFormat.mm;
    final estimatedHeight = (140 + (items.length * 26)).toDouble() * PdfPageFormat.mm;

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

  Future<String?> _saveReceiptPdf(List<CartItem> items, double total) async {
    final pdfData = await _buildReceiptPdf(items, total);
    return saveReceiptPdf(pdfData);
  }

  Future<void> _printReceipt(
    WidgetRef ref,
    List<CartItem> items,
    double total,
  ) async {
    final pdfData = await _buildReceiptPdf(items, total);
    await Printing.layoutPdf(
      onLayout: (_) async => pdfData,
      name: 'sale_receipt',
    );
  }

  Future<void> _showReceiptDialog(
    BuildContext context,
    WidgetRef ref,
    List<CartItem> items,
    double total,
  ) async {
    final receipt = _buildReceipt(items, total);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => fluent.ContentDialog(
        title: const Text('Sale Completed'),
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
              final receiptText = _buildReceipt(items, total);
              try {
                await _printReceipt(ref, items, total);
              } on MissingPluginException catch (_) {
                final savedPath = await _saveReceiptPdf(items, total);
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
                final savedPath = await _saveReceiptPdf(items, total);
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

  void _checkOut(
    BuildContext context,
    WidgetRef ref,
    List<CartItem> items,
    double total,
  ) async {
    final receiptItems = items
        .map(
          (item) => CartItem(
            product: item.product,
            variant: item.variant,
            quantity: item.quantity,
          ),
        )
        .toList();

    // Ask for user confirmation before checkout
    final confirmed = await showCustomDialog(
      context: context,
      title: 'Confirm Sale',
      content: _buildCheckoutSummary(receiptItems, total),
      type: DialogType.confirmation,
    );

    if (confirmed != true) return; // User canceled

    try {
      // Trigger checkout via controller
      final result = await ref.read(cartControllerProvider.notifier).checkout();
      await ref.read(productsControllerProvider.notifier).fetchProducts();

      await _showReceiptDialog(context, ref, receiptItems, result.totalAmount);
    } catch (e) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);

    return Container(
      width: 350,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: ExtraColors.black)),
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

          return Column(
            children: [
              const Text(
                "Checkout",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// CART ITEMS
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
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
                                    .read(cartControllerProvider.notifier)
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
                                    .read(cartControllerProvider.notifier)
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
                    _checkOut(context, ref, items, total);
                  },
                  child: const Text("Complete Sale"),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) {
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
