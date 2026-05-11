import 'package:fluent_ui/fluent_ui.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/src/features/reports/domain/entities/report_entity.dart';
import 'package:sales_system/src/features/reports/presentation/widgets/best_period_card.dart';
import 'package:sales_system/src/features/reports/presentation/widgets/hero_revenue_card.dart';
import 'package:sales_system/src/features/reports/presentation/widgets/revenue_line_chart.dart';
import 'package:sales_system/src/features/reports/presentation/widgets/stat_grid.dart';

class ReportBody extends StatelessWidget {
  final RevenueReportEntity report;
  const ReportBody({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero revenue + delta ───────────────────────────────────────────
          HeroRevenueCard(report: report),

          const SizedBox(height: 16),

          // ── Stat grid ─────────────────────────────────────────────────────
          StatGrid(report: report),

          const SizedBox(height: 24),

          // ── Chart label ───────────────────────────────────────────────────
          Row(
            children: [
              const Text(
                'CASHFLOW TREND',
                style: TextStyle(
                  color: ExtraColors.darkGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              Text(
                report.period.isHourly ? 'Hourly' : 'Daily',
                style:
                    const TextStyle(color: ExtraColors.darkGrey, fontSize: 11),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Line chart ────────────────────────────────────────────────────
          RevenueLineChart(report: report),

          const SizedBox(height: 24),

          // ── Best period card ──────────────────────────────────────────────
          BestPeriodCard(report: report),
        ],
      ),
    );
  }
}
