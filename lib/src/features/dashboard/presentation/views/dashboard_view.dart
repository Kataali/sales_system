import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_system/shared/presentation/ui/loading_overlay.dart';
import 'package:sales_system/src/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:sales_system/src/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THEME CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────

const _bg = Color(0xFF0F1117);
const _surface = Color(0xFF1A1D2E);
const _border = Color(0xFF252840);
const _textPrimary = Colors.white;
const _textSecondary = Color(0xFF8A8FA8);
const _green = Color(0xFF26D782);
const _amber = Color(0xFFF7B731);
const _red = Color(0xFFFF4D6D);
const _purple = Color(0xFF6C63FF);
const _teal = Color(0xFF3EC6E0);

// ─────────────────────────────────────────────────────────────────────────────
// MAIN VIEW
// ─────────────────────────────────────────────────────────────────────────────

class DashboardView extends ConsumerWidget {
  static const routeName = '/dashboard';
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);

    return Scaffold(
      backgroundColor: _bg,
      body: state.when(
        data: (DashboardEntity data) => CustomScrollView(
          slivers: [
            const _DashAppBar(),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _GreetingHeader(),
                  const SizedBox(height: 28),
                  const _SectionLabel('OVERVIEW'),
                  const SizedBox(height: 12),
                  _OverviewGrid(overview: data.overview),
                  const SizedBox(height: 32),
                  const _SectionLabel('INVENTORY STATUS'),
                  const SizedBox(height: 12),
                  _InventoryCard(inventory: data.inventory),
                  const SizedBox(height: 32),
                  const _SectionLabel('RECENT TRANSACTIONS'),
                  const SizedBox(height: 12),
                  _TransactionsList(transactions: data.transactions),
                  const SizedBox(height: 32),
                  const _SectionLabel('TOP PRODUCTS'),
                  const SizedBox(height: 12),
                  _TopProductsList(products: data.topProducts),
                ].animate(interval: 50.ms).fade(duration: 400.ms).slideY(begin: 0.05, duration: 400.ms, curve: Curves.easeOutCubic)),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: LoadingOverlay()),
        error: (e, _) => _ErrorView(error: e.toString()),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// APP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _DashAppBar extends StatelessWidget {
  const _DashAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: _bg,
      surfaceTintColor: Colors.transparent,
      floating: true,
      snap: true,
      elevation: 0,
      titleSpacing: 20,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_purple, _teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          const Text(
            'SalesOS',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: _textSecondary),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: _purple.withValues(alpha: 0.2),
            child: const Text(
              'A',
              style: TextStyle(
                color: _purple,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GREETING
// ─────────────────────────────────────────────────────────────────────────────

class _GreetingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting =
        hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(greeting, style: const TextStyle(color: _textSecondary, fontSize: 14)),
        const SizedBox(height: 4),
        const Text(
          "Here's your store today",
          style: TextStyle(
            color: _textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION LABEL
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: _textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OVERVIEW GRID
// ─────────────────────────────────────────────────────────────────────────────

class _OverviewGrid extends StatelessWidget {
  final Overview overview;
  const _OverviewGrid({required this.overview});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeroCard(
          label: 'Total Revenue',
          value: '\$${overview.totalRevenue}',
          subtitle: 'All-time earnings',
          icon: Icons.trending_up_rounded,
          gradient: const [Color(0xFF6C63FF), Color(0xFF9B5DE5)],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: "Today's Revenue",
                value: '\$${overview.todayRevenue}',
                icon: Icons.today_rounded,
                accent: _teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Total Sales',
                value: '${overview.totalSales}',
                icon: Icons.receipt_long_rounded,
                accent: _amber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _StatCardWide(
          label: 'Customers',
          value: '${overview.customerCount}',
          subtitle: 'Total registered',
          icon: Icons.group_rounded,
          accent: _green,
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String label, value, subtitle;
  final IconData icon;
  final List<Color> gradient;

  const _HeroCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: gradient.first.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 8))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2)),
                const SizedBox(height: 8),
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                        height: 1)),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 13)),
              ],
            ),
          ),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color accent;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(height: 12),
          Text(value,
              style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: _textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _StatCardWide extends StatelessWidget {
  final String label, value, subtitle;
  final IconData icon;
  final Color accent;

  const _StatCardWide({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border)),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: accent, size: 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.8)),
              Text('$label · $subtitle',
                  style: const TextStyle(color: _textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INVENTORY CARD  —  tappable chips → bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _InventoryCard extends StatelessWidget {
  final InventoryStatus inventory;
  const _InventoryCard({required this.inventory});

  void _openSheet(
    BuildContext context,
    String title,
    Color color,
    IconData icon,
    List<dynamic> products,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _InventoryBottomSheet(
        title: title,
        color: color,
        icon: icon,
        products: products,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lowStock = inventory.lowStock;
    final healthy = inventory.healthy;
    final outOfStock = inventory.outOfStock;
    final total = inventory.totalItems;

    final healthyCount = healthy.length;
    final lowCount = lowStock.length;
    final outCount = outOfStock.length;
    final totalCategories = healthyCount + lowCount + outCount;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Stock Health',
                  style: TextStyle(
                      color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
              Text('$total items',
                  style: const TextStyle(color: _textSecondary, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Stacked ratio bar
          if (totalCategories > 0)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 8,
                child: Row(
                  children: [
                    if (healthyCount > 0)
                      Expanded(flex: healthyCount, child: Container(color: _green)),
                    if (lowCount > 0)
                      Expanded(flex: lowCount, child: Container(color: _amber)),
                    if (outCount > 0)
                      Expanded(
                          flex: outCount.clamp(1, 100), child: Container(color: _red)),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Tappable legend chips
          Row(
            children: [
              Expanded(
                child: _StockChip(
                  label: 'Healthy',
                  count: healthyCount,
                  color: _green,
                  icon: Icons.check_circle_outline_rounded,
                  onTap: healthyCount > 0
                      ? () => _openSheet(context, 'Healthy Stock', _green,
                          Icons.check_circle_outline_rounded, healthy)
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StockChip(
                  label: 'Low Stock',
                  count: lowCount,
                  color: _amber,
                  icon: Icons.warning_amber_rounded,
                  onTap: lowCount > 0
                      ? () => _openSheet(context, 'Low Stock', _amber,
                          Icons.warning_amber_rounded, lowStock)
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StockChip(
                  label: 'Out',
                  count: outCount,
                  color: _red,
                  icon: Icons.remove_circle_outline_rounded,
                  onTap: outCount > 0
                      ? () => _openSheet(context, 'Out of Stock', _red,
                          Icons.remove_circle_outline_rounded, outOfStock)
                      : null,
                ),
              ),
            ],
          ),

          // Warning banner
          if (lowCount > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _amber.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _amber.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: _amber, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$lowCount variant${lowCount != 1 ? 's' : ''} running low — tap Low Stock to review',
                      style: const TextStyle(color: _amber, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STOCK CHIP
// ─────────────────────────────────────────────────────────────────────────────

class _StockChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const _StockChip({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: enabled ? 0.10 : 0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: enabled ? 0.30 : 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color.withValues(alpha: enabled ? 1.0 : 0.4), size: 16),
                if (enabled)
                  Icon(Icons.chevron_right_rounded,
                      color: color.withValues(alpha: 0.5), size: 14),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '$count',
              style: TextStyle(
                color: enabled ? color : color.withValues(alpha: 0.4),
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: enabled ? color.withValues(alpha: 0.8) : color.withValues(alpha: 0.3),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INVENTORY BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _InventoryBottomSheet extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final List<dynamic> products;

  const _InventoryBottomSheet({
    required this.title,
    required this.color,
    required this.icon,
    required this.products,
  });

  /// Normalises both list shapes the API returns into a unified display model.
  ///
  /// lowStock  → flat variant rows: { productName, variant: { size, price, stock } }
  /// healthy / outOfStock → product objects: { name, imageUrl, sku, variants:[...], totalStock }
  List<_ProductDisplayItem> _normalise() {
    final items = <_ProductDisplayItem>[];

    for (final p in products) {
      final map = p is Map ? p : null;

      // ── Flat variant row (lowStock shape) ──────────────────────────────────
      if (map != null && map.containsKey('productName') && map.containsKey('variant')) {
        final v = map['variant'] as Map;
        items.add(_ProductDisplayItem(
          name: map['productName'] as String,
          sku: '',
          imageUrl: null,
          totalStock: (v['stock'] as num).toInt(),
          variants: [
            _VariantRow(
              size: v['size'].toString(),
              price: v['price'] as num,
              stock: (v['stock'] as num).toInt(),
            )
          ],
        ));
        continue;
      }

      // ── Full product row (healthy / outOfStock shape) ──────────────────────
      final name = (map?['name'] ?? '') as String;
      final sku = (map?['sku'] ?? '') as String;
      final imageUrl = map?['imageUrl'] as String?;
      final totalStock = (map?['totalStock'] as num?)?.toInt() ?? 0;
      final rawVariants = (map?['variants'] as List?) ?? [];

      items.add(_ProductDisplayItem(
        name: name,
        sku: sku,
        imageUrl: imageUrl,
        totalStock: totalStock,
        variants: rawVariants.map((v) {
          final vm = v as Map;
          return _VariantRow(
            size: vm['size'].toString(),
            price: vm['price'] as num,
            stock: (vm['stock'] as num).toInt(),
          );
        }).toList(),
      ));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _normalise();

    return DraggableScrollableSheet(
      initialChildSize: 0.70,
      minChildSize: 0.40,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: _border, borderRadius: BorderRadius.circular(2)),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12)),
                          child: Icon(icon, color: color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: const TextStyle(
                                    color: _textPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            Text(
                              '${items.length} product${items.length != 1 ? 's' : ''}',
                              style:
                                  const TextStyle(color: _textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: _textSecondary),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: _border, height: 1),
                  ],
                ),
              ),

              // List
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icon, color: color.withValues(alpha: 0.3), size: 48),
                            const SizedBox(height: 12),
                            const Text('No products in this category',
                                style:
                                    TextStyle(color: _textSecondary, fontSize: 14)),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) =>
                            _ProductSheetCard(item: items[i], accent: color),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRODUCT SHEET CARD
// ─────────────────────────────────────────────────────────────────────────────

class _VariantRow {
  final String size;
  final num price;
  final int stock;
  const _VariantRow({required this.size, required this.price, required this.stock});
}

class _ProductDisplayItem {
  final String name, sku;
  final String? imageUrl;
  final List<_VariantRow> variants;
  final int totalStock;

  const _ProductDisplayItem({
    required this.name,
    required this.sku,
    required this.imageUrl,
    required this.variants,
    required this.totalStock,
  });
}

class _ProductSheetCard extends StatefulWidget {
  final _ProductDisplayItem item;
  final Color accent;
  const _ProductSheetCard({required this.item, required this.accent});

  @override
  State<_ProductSheetCard> createState() => _ProductSheetCardState();
}

class _ProductSheetCardState extends State<_ProductSheetCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final hasMultipleVariants = item.variants.length > 1;

    return Container(
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          // Main row
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: item.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: item.imageUrl!,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              _ImgPlaceholder(color: widget.accent),
                          errorWidget: (_, __, ___) =>
                              _ImgPlaceholder(color: widget.accent),
                        )
                      : _ImgPlaceholder(color: widget.accent),
                ),
                const SizedBox(width: 12),

                // Name + SKU
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: const TextStyle(
                              color: _textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      if (item.sku.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(item.sku,
                            style: const TextStyle(
                                color: _textSecondary,
                                fontSize: 11,
                                fontFamily: 'monospace')),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Total stock + expand toggle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.totalStock > 0
                            ? '${item.totalStock} units'
                            : 'Out',
                        style: TextStyle(
                            color: widget.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (hasMultipleVariants) ...[
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _expanded = !_expanded),
                        child: Row(
                          children: [
                            Text(
                              _expanded
                                  ? 'Less'
                                  : '${item.variants.length} sizes',
                              style: TextStyle(
                                  color: widget.accent.withValues(alpha: 0.8),
                                  fontSize: 11),
                            ),
                            Icon(
                              _expanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: widget.accent.withValues(alpha: 0.8),
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Variant breakdown
          if (item.variants.isNotEmpty &&
              (_expanded || !hasMultipleVariants)) ...[
            const Divider(color: _border, height: 1, indent: 14, endIndent: 14),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                children: item.variants.map((v) {
                  final isOut = v.stock == 0;
                  final isLow = !isOut && v.stock <= 10;
                  final chipColor = isOut ? _red : isLow ? _amber : _green;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _surface,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: _border),
                          ),
                          child: Text(v.size,
                              style: const TextStyle(
                                  color: _textSecondary, fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        Text('\$${v.price}',
                            style: const TextStyle(
                                color: _textSecondary, fontSize: 12)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: chipColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isOut ? 'Out of stock' : '${v.stock} left',
                            style: TextStyle(
                                color: chipColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ImgPlaceholder extends StatelessWidget {
  final Color color;
  const _ImgPlaceholder({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.inventory_2_outlined,
          color: color.withValues(alpha: 0.5), size: 22),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TRANSACTIONS LIST
// ─────────────────────────────────────────────────────────────────────────────

class _TransactionsList extends StatelessWidget {
  final List<TransactionEntity> transactions;
  const _TransactionsList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _border)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: transactions.asMap().entries.map((entry) {
          final i = entry.key;
          final t = entry.value;  // typed as TransactionEntity
          final isLast = i == transactions.length - 1;
          final isPaid = t.totalAmount > 0;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isPaid
                            ? _green.withValues(alpha: 0.12)
                            : _textSecondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isPaid
                            ? Icons.arrow_downward_rounded
                            : Icons.remove_rounded,
                        color: isPaid ? _green : _textSecondary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.productName,           // ✓ TransactionEntity.productName
                              style: const TextStyle(
                                  color: _textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text(
                            'Qty ${t.quantity}',        // ✓ no t.id (not in entity)
                            style: const TextStyle(
                                color: _textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      isPaid
                          ? '\$${t.totalAmount.toStringAsFixed(2)}'  // ✓ double
                          : '—',
                      style: TextStyle(
                          color: isPaid ? _green : _textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(height: 1, color: _border, indent: 68),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP PRODUCTS
// ─────────────────────────────────────────────────────────────────────────────

class _TopProductsList extends StatelessWidget {
  final List<TopProductEntity> products;
  const _TopProductsList({required this.products});

  @override
  Widget build(BuildContext context) {
    // ✓ TopProductEntity.revenue is already a double — no string parsing needed
    final maxRevenue = products.fold<double>(
        0, (max, p) => p.revenue > max ? p.revenue : max);

    const rankColors = [_amber, _textSecondary, Color(0xFFCD7F32)];

    return Column(
      children: products.asMap().entries.map((entry) {
        final rank = entry.key + 1;
        final p = entry.value;  // typed as TopProductEntity
        final ratio = maxRevenue > 0 ? p.revenue / maxRevenue : 0.0;
        final rankColor = rank <= 3 ? rankColors[rank - 1] : _textSecondary;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _border)),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: rankColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text('#$rank',
                            style: TextStyle(
                                color: rankColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name,                 // ✓ TopProductEntity.name
                              style: const TextStyle(
                                  color: _textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis),
                          Text('${p.salesCount} sold', // ✓ TopProductEntity.salesCount
                              style: const TextStyle(
                                  color: _textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(
                      '\$${p.revenue.toStringAsFixed(2)}', // ✓ TopProductEntity.revenue
                      style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 4,
                    backgroundColor: _border,
                    valueColor: AlwaysStoppedAnimation<Color>(rankColor),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String error;
  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                color: _red.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: const Icon(Icons.error_outline_rounded, color: _red, size: 32),
          ),
          const SizedBox(height: 16),
          const Text('Something went wrong',
              style: TextStyle(
                  color: _textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(error,
              style: const TextStyle(color: _textSecondary, fontSize: 13),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
