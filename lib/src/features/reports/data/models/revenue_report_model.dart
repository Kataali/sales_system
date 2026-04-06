import 'package:sales_system/src/features/reports/domain/entities/report_entity.dart';

class RevenueReportModel extends RevenueReportEntity {
  const RevenueReportModel({
    required super.period,
    required super.date,
    required super.totalRevenue,
    required super.totalTransactions,
    required super.averageOrderValue,
    required super.bestPeriod,
    required super.comparisonRevenue,
    required super.comparisonLabel,
    required super.dataPoints,
  });

  factory RevenueReportModel.fromJson(
    Map<String, dynamic> json,
    ReportPeriod period,
  ) {
    return RevenueReportModel(
      period: period,
      date: json['date'] as String,
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalTransactions: (json['totalTransactions'] as num).toInt(),
      averageOrderValue: (json['averageOrderValue'] as num).toDouble(),
      bestPeriod: BestPeriod.fromJson(json['bestPeriod'] as Map<String, dynamic>),
      comparisonRevenue: (json['comparisonRevenue'] as num).toDouble(),
      comparisonLabel: json['comparisonLabel'] as String,
      dataPoints: (json['dataPoints'] as List)
          .map((e) => RevenueDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

