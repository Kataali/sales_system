import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'chart_indicator.dart';

class IncomePieChart extends StatelessWidget {
  const IncomePieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: sections(),
              centerSpaceRadius: 68.0,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Indicator(
                title: "Chicken",
                color: Colors.blue,
                spaceOccupied: 40,
              ),
              Indicator(
                title: "Gizzard",
                color: Colors.red,
                spaceOccupied: 30,
              ),
              Indicator(
                title: "Sausage",
                color: Colors.cyan,
                spaceOccupied: 10,
              ),
              Indicator(
                title: "Fish",
                color: Colors.purple,
                spaceOccupied: 20,
              )
            ],
          ),
        )
      ],
    );
  }

  List<PieChartSectionData> sections() {
    return List.generate(4, (index) {
      const double radius = 30;
      const double fontSize = 16;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (index) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 40,
            radius: radius,
            showTitle: false,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: 30,
            radius: radius,
            showTitle: false,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: 20,
            showTitle: false,
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.cyan,
            value: 10,
            showTitle: false,
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
