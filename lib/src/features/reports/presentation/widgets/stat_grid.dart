import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/src/features/reports/domain/entities/report_entity.dart';
import 'package:sales_system/src/features/reports/presentation/widgets/mini_stat_card.dart';

class StatGrid extends StatelessWidget {
  final RevenueReportEntity report;
  const StatGrid({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(symbol: 'GHS ', decimalDigits: 2);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MiniStatCard(
                icon: FluentIcons.receipt_forward,
                label: 'Transactions',
                value: '${report.totalTransactions}',
                accent: ExtraColors.turquoise,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MiniStatCard(
                icon: FluentIcons.shopping_cart,
                label: 'Avg Order',
                value: currencyFormat.format(report.averageOrderValue),
                accent: ExtraColors.yellow,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: MiniStatCard(
                icon: FluentIcons.savings,
                label: 'Period Deposits',
                value: currencyFormat.format(report.totalDeposits),
                accent: ExtraColors.emerald,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MiniStatCard(
                icon: FluentIcons.money,
                label: 'Period Cashflow',
                value: currencyFormat.format(report.totalCashflow),
                accent: ExtraColors.plum,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
