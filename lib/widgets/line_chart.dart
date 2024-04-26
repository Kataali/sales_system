import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesLineChart extends StatelessWidget {
  const SalesLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> data1 = const [
      FlSpot(1, 0.5),
      FlSpot(3, 1.5),
      FlSpot(5, 1.4),
      FlSpot(7, 3.4),
      FlSpot(10, 2),
      FlSpot(12, 2.2),
      FlSpot(13, 1.8),
    ];

    List<FlSpot> data2 = const [
      FlSpot(1, 1),
      FlSpot(3, 2.8),
      FlSpot(7, 1.2),
      FlSpot(10, 2.8),
      FlSpot(12, 2.6),
      FlSpot(13, 3.9),
    ];

    Widget BottomTitleWidgets(double value, TitleMeta meta) {
      const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
      String text;
      switch (value.toInt()) {
        case 1:
          text = '09:00 am';
          break;
        case 4:
          text = '12:00 pm';
          break;
        case 7:
          text = '03:00 pm';
          break;
        case 10:
          text = '06:00 pm';
          break;
        case 13:
          text = '12:00 am';
          break;
        default:
          return Container();
      }

      return Text(text, style: style, textAlign: TextAlign.center);
    }

    SideTitles bottomTitles() => SideTitles(
          getTitlesWidget: BottomTitleWidgets,
          showTitles: true,
          interval: 1,
          reservedSize: 40,
        );

    return LineChart(
      LineChartData(
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: false,
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 28,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 28,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: bottomTitles(),
          ),
        ),

        borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        minX: 0,
        maxX: 14,
        minY: 0, // Set your left axis minimum here
        maxY: 4.5, // Set your left axis maximum here

        lineBarsData: [
          LineChartBarData(
            spots: data1,
            isCurved: false,
            color: Colors.blue,
            barWidth: 4,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: data2,
            isCurved: false,
            barWidth: 4,
            color: Colors.red,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
