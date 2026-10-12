import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/src/features/products/domain/entities/product.dart';
import 'package:sales_system/src/features/products/presentation/widgets/step_button.dart';

class StockAdjustSheet extends ConsumerStatefulWidget {
  final Product product;
  final VoidCallback onSaved;

  const StockAdjustSheet(
      {super.key, required this.product, required this.onSaved});

  @override
  ConsumerState<StockAdjustSheet> createState() => StockAdjustSheetState();
}

class StockAdjustSheetState extends ConsumerState<StockAdjustSheet> {
  late final List<TextEditingController> _controllers;
  late final List<int> _original;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _original = widget.product.variants.map((v) => v.stock).toList();
    _controllers = widget.product.variants
        .map((v) => TextEditingController(text: v.stock.toString()))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  int _getValue(int i) => int.tryParse(_controllers[i].text) ?? _original[i];

  int get _totalNew =>
      _controllers.fold(0, (sum, c) => sum + (int.tryParse(c.text) ?? 0));

  bool get _hasChanges {
    for (int i = 0; i < _original.length; i++) {
      if (_getValue(i) != _original[i]) return true;
    }
    return false;
  }

  void _increment(int i) => setState(() {
        _controllers[i].text = (_getValue(i) + 1).toString();
      });

  void _decrement(int i) => setState(() {
        final cur = _getValue(i);
        if (cur > 0) _controllers[i].text = (cur - 1).toString();
      });

  Future<void> _save() async {
    // Build the payload you'd send to your API:
    // List<{ size, newStock }> for each variant
    // ignore: unused_local_variable
    final updates = List.generate(
      widget.product.variants.length,
      (i) => {
        'size': widget.product.variants[i].size,
        'stock': _getValue(i),
      },
    );

    setState(() => _saving = true);

    // TODO: call your update method here, e.g.:
    // await ref.read(productsControllerProvider.notifier)
    //     .updateStock(productId: widget.product.id, variants: updates);

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _saving = false);

    if (mounted) {
      Navigator.pop(context);
      widget.onSaved();
      showAppTopSnackBar(ref.read(navigatorKey), 'Stock updated successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    final variants = widget.product.variants;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: ExtraColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // ── Sheet header ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: ExtraColors.link,
                          borderRadius: BorderRadius.circular(2)),
                    ),
                    const SizedBox(height: 20),

                    // Product info row
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: widget.product.imageUrl.trim().isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: widget.product.imageUrl,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Container(
                                    width: 48,
                                    height: 48,
                                    color: ExtraColors.plum.withValues(alpha: 0.08),
                                    child: const Icon(Icons.inventory_2_outlined,
                                        color: ExtraColors.plum, size: 20),
                                  ),
                                )
                              : Container(
                                  width: 48,
                                  height: 48,
                                  color:
                                      ExtraColors.plum.withValues(alpha: 0.08),
                                  child: const Icon(Icons.inventory_2_outlined,
                                      color: ExtraColors.plum, size: 20),
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.name,
                                style: const TextStyle(
                                    color: ExtraColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                              Row(
                                children: [
                                  Text(widget.product.sku,
                                      style: const TextStyle(
                                          color: ExtraColors.darkGrey,
                                          fontSize: 11,
                                          fontFamily: 'monospace')),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 3,
                                    height: 3,
                                    decoration: const BoxDecoration(
                                        color: ExtraColors.darkGrey,
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'New total: $_totalNew units',
                                    style: const TextStyle(
                                        color: ExtraColors.plum,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: ExtraColors.darkGrey),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const Row(
                      children: [
                        Text(
                          'ADJUST STOCK BY SIZE',
                          style: TextStyle(
                              color: ExtraColors.darkGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: ExtraColors.link, height: 1),
                  ],
                ),
              ),

              // ── Variant rows ───────────────────────────────────────────────
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  itemCount: variants.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final v = variants[i];
                    final current = _getValue(i);
                    final diff = current - _original[i];
                    final isOut = current == 0;
                    final isLow = !isOut && current <= 10;
                    final stockColor = isOut
                        ? ExtraColors.crimson
                        : isLow
                            ? ExtraColors.yellow
                            : ExtraColors.emerald;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: ExtraColors.lightGrey,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: ExtraColors.linkLight),
                      ),
                      child: Row(
                        children: [
                          // Size + price + diff badge
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(v.size,
                                    style: const TextStyle(
                                        color: ExtraColors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      '\$${v.price.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                          color: ExtraColors.darkGrey,
                                          fontSize: 12),
                                    ),
                                    if (diff != 0) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: diff > 0
                                              ? ExtraColors.emerald
                                                  .withValues(alpha: 0.12)
                                              : ExtraColors.crimson
                                                  .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          '${diff > 0 ? '+' : ''}$diff',
                                          style: TextStyle(
                                            color: diff > 0
                                                ? ExtraColors.emerald
                                                : ExtraColors.crimson,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Stepper
                          Row(
                            children: [
                              StepButton(
                                icon: Icons.remove_rounded,
                                onTap: () => _decrement(i),
                                enabled: current > 0,
                              ),
                              const SizedBox(width: 8),

                              // Input
                              SizedBox(
                                width: 56,
                                child: TextField(
                                  controller: _controllers[i],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  style: TextStyle(
                                    color: stockColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  onChanged: (_) => setState(() {}),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: stockColor.withValues(alpha: 0.4)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: stockColor.withValues(alpha: 0.3)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: stockColor),
                                    ),
                                    filled: true,
                                    fillColor: stockColor.withValues(alpha: 0.06),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              StepButton(
                                icon: Icons.add_rounded,
                                onTap: () => _increment(i),
                                enabled: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ── Save button ────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                    20, 12, 20, MediaQuery.of(context).viewInsets.bottom + 20),
                child: Column(
                  children: [
                    if (_hasChanges)
                      GestureDetector(
                        onTap: () => setState(() {
                          for (int i = 0; i < _original.length; i++) {
                            _controllers[i].text = _original[i].toString();
                          }
                        }),
                        child: const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            'Reset to original',
                            style: TextStyle(
                              color: ExtraColors.darkGrey,
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                              decorationColor: ExtraColors.darkGrey,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: AnimatedOpacity(
                        opacity: _hasChanges ? 1.0 : 0.4,
                        duration: const Duration(milliseconds: 200),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _hasChanges
                                  ? [
                                      ExtraColors.plum,
                                      ExtraColors.plum.withValues(alpha: 0.7)
                                    ]
                                  : [
                                      ExtraColors.darkGrey,
                                      ExtraColors.darkGrey
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: _hasChanges
                                ? [
                                    BoxShadow(
                                        color:
                                            ExtraColors.plum.withValues(alpha: 0.35),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6))
                                  ]
                                : [],
                          ),
                          child: TextButton(
                            onPressed: _hasChanges && !_saving ? _save : null,
                            child: _saving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        color: ExtraColors.white,
                                        strokeWidth: 2),
                                  )
                                : const Text(
                                    'Save Changes',
                                    style: TextStyle(
                                        color: ExtraColors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
