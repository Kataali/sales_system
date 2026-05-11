import 'package:sales_system/src/features/reports/domain/entities/report_entity.dart';

class RevenueReportModel extends RevenueReportEntity {
  const RevenueReportModel({
    required super.period,
    required super.date,
    required super.totalRevenue,
    required super.totalDeposits,
    required super.totalCashflow,
    required super.totalTransactions,
    required super.averageOrderValue,
    required super.bestPeriod,
    required super.comparisonRevenue,
    required super.comparisonDeposits,
    required super.comparisonCashflow,
    required super.comparisonLabel,
    required super.dataPoints,
  });

  factory RevenueReportModel.fromJson(
    Map<String, dynamic> json,
    ReportPeriod fallbackPeriod,
  ) {
    final report = _reportMap(json);
    final totalRevenue =
        double.tryParse(report['totalRevenue']?.toString() ?? '') ?? 0.0;
    final totalDeposits =
        double.tryParse(report['totalDeposits']?.toString() ?? '') ?? 0.0;
    final comparisonRevenue =
        double.tryParse(report['comparisonRevenue']?.toString() ?? '') ?? 0.0;
    final comparisonDeposits =
        double.tryParse(report['comparisonDeposits']?.toString() ?? '') ?? 0.0;

    return RevenueReportModel(
      period: _parsePeriod(report['period']) ?? fallbackPeriod,
      date: report['date']?.toString() ?? '',
      totalRevenue: totalRevenue,
      totalDeposits: totalDeposits,
      totalCashflow:
          double.tryParse(report['totalCashflow']?.toString() ?? '') ??
              (totalRevenue + totalDeposits),
      totalTransactions:
          int.tryParse(report['totalTransactions']?.toString() ?? '') ?? 0,
      averageOrderValue:
          double.tryParse(report['averageOrderValue']?.toString() ?? '') ?? 0.0,
      bestPeriod: BestPeriod.fromJson(_asMap(report['bestPeriod'])),
      comparisonRevenue: comparisonRevenue,
      comparisonDeposits: comparisonDeposits,
      comparisonCashflow:
          double.tryParse(report['comparisonCashflow']?.toString() ?? '') ??
              (comparisonRevenue + comparisonDeposits),
      comparisonLabel: report['comparisonLabel']?.toString() ?? '',
      dataPoints: (report['dataPoints'] as List? ?? const [])
          .map((e) => RevenueDataPoint.fromJson(_asMap(e)))
          .toList(),
    );
  }
}

Map<String, dynamic> _reportMap(Map<String, dynamic> json) {
  final report = json['report'];
  return report is Map<String, dynamic> ? report : json;
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map(
      (key, entryValue) => MapEntry(key.toString(), entryValue),
    );
  }
  return <String, dynamic>{};
}

ReportPeriod? _parsePeriod(Object? raw) {
  switch (raw?.toString().toLowerCase()) {
    case 'today':
      return ReportPeriod.today;
    case 'yesterday':
      return ReportPeriod.yesterday;
    case 'custom':
      return ReportPeriod.custom;
    case 'weekly':
      return ReportPeriod.weekly;
    case 'monthly':
      return ReportPeriod.monthly;
    default:
      return null;
  }
}
