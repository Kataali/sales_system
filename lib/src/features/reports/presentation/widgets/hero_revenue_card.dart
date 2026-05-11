import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/src/features/reports/domain/entities/report_entity.dart';

class HeroRevenueCard extends StatelessWidget {
  final RevenueReportEntity report;

  const HeroRevenueCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final delta = report.deltaPercent;
    final isUp = report.isUp;
    final deltaColor = isUp ? ExtraColors.emerald : ExtraColors.crimson;
    final currencyFormat =
        NumberFormat.currency(symbol: 'GHS ', decimalDigits: 2);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ExtraColors.plum,
            ExtraColors.plum.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ExtraColors.plum.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                report.period.label.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                ),
              ),
              Text(
                'TOTAL CASHFLOW',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(report.totalCashflow),
            style: const TextStyle(
              color: ExtraColors.white,
              fontSize: 38,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _HeroBreakdownItem(
                label: 'Sales Revenue',
                value: currencyFormat.format(report.totalRevenue),
              ),
              const SizedBox(width: 24),
              _HeroBreakdownItem(
                label: 'New Deposits',
                value: currencyFormat.format(report.totalDeposits),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Delta badge
          if (delta != null)
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: deltaColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isUp
                            ? FluentIcons.caret_up_solid8
                            : FluentIcons.caret_down_solid8,
                        color: deltaColor,
                        size: 8,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${delta.abs().toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: deltaColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'vs ${report.comparisonLabel} '
                  '(${currencyFormat.format(report.comparisonCashflow)})',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ],
            )
          else
            const Text(
              'No comparison data available',
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
        ],
      ),
    );
  }
}

class _HeroBreakdownItem extends StatelessWidget {
  final String label;
  final String value;

  const _HeroBreakdownItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
