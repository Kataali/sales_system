import 'package:sales_system/src/features/reports/domain/entities/report_entity.dart';

abstract class ReportsRepository {
  Future<RevenueReportEntity> getRevenueReport(RevenueReportParams params);
}
