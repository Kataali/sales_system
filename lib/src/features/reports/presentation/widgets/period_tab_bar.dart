import 'package:flutter/material.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';
import 'package:sales_system/src/features/reports/domain/entities/report_entity.dart';

class PeriodTabBar extends StatelessWidget {
  final TabController controller;
  final List<ReportPeriod> periods;

  const PeriodTabBar({super.key, required this.controller, required this.periods});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: periods.length,
        itemBuilder: (_, i) {
          return AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              final selected = controller.index == i;
              return GestureDetector(
                onTap: () => controller.animateTo(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? ExtraColors.plum
                        : ExtraColors.darkBlue,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? ExtraColors.plum
                          : ExtraColors.link,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: ExtraColors.plum.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : [],
                  ),
                  child: Text(
                    periods[i].label,
                    style: TextStyle(
                      color: selected
                          ? ExtraColors.white
                          : ExtraColors.darkGrey,
                      fontSize: 12,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
