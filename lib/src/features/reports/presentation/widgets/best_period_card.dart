import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/src/features/reports/domain/entities/report_entity.dart';

class BestPeriodCard extends StatelessWidget {
  final RevenueReportEntity report;
  const BestPeriodCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final periodWord =
        report.period.isHourly ? 'hour' : 'day';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ExtraColors.darkBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ExtraColors.link),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: ExtraColors.yellow.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(FluentIcons.trophy2,
                color: ExtraColors.yellow, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best $periodWord',
                  style: const TextStyle(
                      color: ExtraColors.darkGrey, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  report.bestPeriod.label,
                  style: const TextStyle(
                    color: ExtraColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currencyFormat.format(report.bestPeriod.revenue),
                style: const TextStyle(
                  color: ExtraColors.yellow,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                'peak revenue',
                style: TextStyle(
                    color: ExtraColors.darkGrey, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
