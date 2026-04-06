// Domain entity definitions for the sales reports feature.

enum ReportPeriod { today, yesterday, custom, weekly, monthly }

extension ReportPeriodX on ReportPeriod {
  String get param => switch (this) {
        ReportPeriod.today => 'today',
        ReportPeriod.yesterday => 'yesterday',
        ReportPeriod.custom => 'custom',
        ReportPeriod.weekly => 'weekly',
        ReportPeriod.monthly => 'monthly',
      };

  String get label => switch (this) {
        ReportPeriod.today => 'Today',
        ReportPeriod.yesterday => 'Yesterday',
        ReportPeriod.custom => 'Custom Date',
        ReportPeriod.weekly => 'This Week',
        ReportPeriod.monthly => 'This Month',
      };

  bool get isHourly => this == ReportPeriod.today ||
      this == ReportPeriod.yesterday ||
      this == ReportPeriod.custom;
}

class RevenueDataPoint {
  final String label;
  final double revenue;
  final int transactions;

  const RevenueDataPoint({
    required this.label,
    required this.revenue,
    required this.transactions,
  });

  factory RevenueDataPoint.fromJson(Map<String, dynamic> json) {
    return RevenueDataPoint(
      label: json['label'] as String,
      revenue: (json['revenue'] as num).toDouble(),
      transactions: (json['transactions'] as num).toInt(),
    );
  }
}

class BestPeriod {
  final String label;
  final double revenue;

  const BestPeriod({
    required this.label,
    required this.revenue,
  });

  factory BestPeriod.fromJson(Map<String, dynamic> json) {
    return BestPeriod(
      label: json['label'] as String,
      revenue: (json['revenue'] as num).toDouble(),
    );
  }
}

class RevenueReportEntity {
  final ReportPeriod period;
  final String date;
  final double totalRevenue;
  final int totalTransactions;
  final double averageOrderValue;
  final BestPeriod bestPeriod;
  final double comparisonRevenue;
  final String comparisonLabel;
  final List<RevenueDataPoint> dataPoints;

  const RevenueReportEntity({
    required this.period,
    required this.date,
    required this.totalRevenue,
    required this.totalTransactions,
    required this.averageOrderValue,
    required this.bestPeriod,
    required this.comparisonRevenue,
    required this.comparisonLabel,
    required this.dataPoints,
  });

  double? get deltaPercent {
    if (comparisonRevenue == 0) return null;
    return ((totalRevenue - comparisonRevenue) / comparisonRevenue) * 100;
  }

  bool get isUp => (deltaPercent ?? 0) >= 0;
}

class RevenueReportParams {
  final ReportPeriod period;
  final DateTime? customDate;

  const RevenueReportParams({
    required this.period,
    this.customDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RevenueReportParams &&
          other.period == period &&
          other.customDate == customDate;

  @override
  int get hashCode => Object.hash(period, customDate);
}
