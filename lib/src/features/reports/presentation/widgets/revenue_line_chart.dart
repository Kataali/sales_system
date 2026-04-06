import 'package:fl_chart/fl_chart.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/src/features/reports/domain/entities/report_entity.dart';

class RevenueLineChart extends StatefulWidget {
  final RevenueReportEntity report;
  const RevenueLineChart({super.key, required this.report});

  @override
  State<RevenueLineChart> createState() => RevenueLineChartState();
}

class RevenueLineChartState extends State<RevenueLineChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final points = widget.report.dataPoints;
    if (points.isEmpty) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: ExtraColors.darkBlue,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ExtraColors.link),
        ),
        child: const Center(
          child: Text('No data for this period',
              style: TextStyle(color: ExtraColors.darkGrey, fontSize: 14)),
        ),
      );
    }

    final maxY =
        points.map((p) => p.revenue).fold<double>(0, (a, b) => a > b ? a : b);

    // Build spots — skip zero-revenue points for a cleaner line,
    // but always include first and last to anchor the chart.
    final spots = <FlSpot>[];
    for (int i = 0; i < points.length; i++) {
      spots.add(FlSpot(i.toDouble(), points[i].revenue));
    }

    // Determine label decimation — show fewer labels when many points
    final labelStep = points.length > 20
        ? 4
        : points.length > 12
            ? 3
            : points.length > 7
                ? 1
                : 0; // 0 = show all

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 24, 16, 12),
      decoration: BoxDecoration(
        color: ExtraColors.darkBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ExtraColors.link),
      ),
      child: SizedBox(
        height: 220,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: maxY == 0 ? 100 : maxY * 1.25,
            clipData: const FlClipData.all(),

            // ── Touch tooltip ───────────────────────────────────────────────
            lineTouchData: LineTouchData(
              touchCallback: (event, response) {
                setState(() {
                  _touchedIndex = response?.lineBarSpots?.first.spotIndex;
                });
              },
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => ExtraColors.link,
                tooltipRoundedRadius: 10,
                tooltipPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                getTooltipItems: (spots) {
                  return spots.map((spot) {
                    final i = spot.spotIndex;
                    final p = points[i];
                    return LineTooltipItem(
                      '\$${p.revenue.toStringAsFixed(2)}\n',
                      const TextStyle(
                        color: ExtraColors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text:
                              '${p.label}  ·  ${p.transactions} sale${p.transactions != 1 ? 's' : ''}',
                          style: const TextStyle(
                            color: ExtraColors.darkGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
            ),

            // ── Grid ────────────────────────────────────────────────────────
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxY == 0 ? 25 : (maxY * 1.25) / 4,
              getDrawingHorizontalLine: (_) => FlLine(
                color: ExtraColors.link.withValues(alpha: 0.6),
                strokeWidth: 1,
                dashArray: [4, 4],
              ),
            ),

            // ── Border ──────────────────────────────────────────────────────
            borderData: FlBorderData(show: false),

            // ── Axes ────────────────────────────────────────────────────────
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 46,
                  interval: maxY == 0 ? 25 : (maxY * 1.25) / 4,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return const SizedBox.shrink();
                    final label = value >= 1000
                        ? '\$${(value / 1000).toStringAsFixed(1)}k'
                        : '\$${value.toInt()}';
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Text(label,
                          style: const TextStyle(
                              color: ExtraColors.darkGrey, fontSize: 10)),
                    );
                  },
                ),
              ),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final i = value.toInt();
                    if (i < 0 || i >= points.length) {
                      return const SizedBox.shrink();
                    }
                    // Decimate labels to avoid crowding
                    if (labelStep > 0 && i % labelStep != 0) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        points[i].label,
                        style: const TextStyle(
                            color: ExtraColors.darkGrey, fontSize: 9),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ── Line ────────────────────────────────────────────────────────
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.35,
                color: ExtraColors.plum,
                barWidth: 2.5,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  checkToShowDot: (spot, barData) {
                    // Only show dot for touched point or non-zero values
                    // when there are few data points
                    if (spot.x.toInt() == _touchedIndex) return true;
                    if (points.length <= 10 && spot.y > 0) return true;
                    return false;
                  },
                  getDotPainter: (spot, _, __, index) {
                    final isTouched = index == _touchedIndex;
                    return FlDotCirclePainter(
                      radius: isTouched ? 6 : 3.5,
                      color: isTouched ? ExtraColors.white : ExtraColors.plum,
                      strokeWidth: isTouched ? 2.5 : 1.5,
                      strokeColor: ExtraColors.plum,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ExtraColors.plum.withValues(alpha: 0.25),
                      ExtraColors.plum.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
}
