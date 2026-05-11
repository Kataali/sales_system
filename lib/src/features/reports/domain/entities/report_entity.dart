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
  final double deposits;
  final double cashflow;
  final int transactions;

  const RevenueDataPoint({
    required this.label,
    required this.revenue,
    required this.deposits,
    required this.cashflow,
    required this.transactions,
  });

  factory RevenueDataPoint.fromJson(Map<String, dynamic> json) {
    final revenue = double.tryParse(json['revenue']?.toString() ?? '') ?? 0.0;
    final deposits = double.tryParse(json['deposits']?.toString() ?? '') ?? 0.0;
    final cashflow =
        double.tryParse(json['cashflow']?.toString() ?? '') ?? (revenue + deposits);
    
    return RevenueDataPoint(
      label: json['label']?.toString() ?? '',
      revenue: revenue,
      deposits: deposits,
      cashflow: cashflow,
      transactions: int.tryParse(json['transactions']?.toString() ?? '') ?? 0,
    );
  }
}

class BestPeriod {
  final String label;
  final double cashflow;

  const BestPeriod({
    required this.label,
    required this.cashflow,
  });

  factory BestPeriod.fromJson(Map<String, dynamic> json) {
    final revenue = double.tryParse(json['revenue']?.toString() ?? '') ?? 0.0;
    final deposits = double.tryParse(json['deposits']?.toString() ?? '') ?? 0.0;
    final cashflow =
        double.tryParse(json['cashflow']?.toString() ?? '') ?? (revenue + deposits);

    return BestPeriod(
      label: json['label']?.toString() ?? '',
      cashflow: cashflow,
    );
  }
}

class RevenueReportEntity {
  final ReportPeriod period;
  final String date;
  final double totalRevenue;
  final double totalDeposits;
  final double totalCashflow;
  final int totalTransactions;
  final double averageOrderValue;
  final BestPeriod bestPeriod;
  final double comparisonRevenue;
  final double comparisonDeposits;
  final double comparisonCashflow;
  final String comparisonLabel;
  final List<RevenueDataPoint> dataPoints;

  const RevenueReportEntity({
    required this.period,
    required this.date,
    required this.totalRevenue,
    required this.totalDeposits,
    required this.totalCashflow,
    required this.totalTransactions,
    required this.averageOrderValue,
    required this.bestPeriod,
    required this.comparisonRevenue,
    required this.comparisonDeposits,
    required this.comparisonCashflow,
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
