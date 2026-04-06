import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';
import 'package:sales_system/src/features/reports/data/datasources/reports_remote_datasource.dart';
import 'package:sales_system/src/features/reports/data/models/revenue_report_model.dart';
import 'package:sales_system/src/features/reports/domain/entities/report_entity.dart';
import 'package:sales_system/src/features/reports/domain/repositories/reports_repository.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource dataSource;
  final AuthSecureStorage storage;

  ReportsRepositoryImpl(this.dataSource, this.storage);

  @override
  Future<RevenueReportEntity> getRevenueReport(
      RevenueReportParams params) async {
    final token = await storage.getAccessToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }

    final json = await dataSource.fetchRevenueReport(
      token,
      period: params.period,
      customDate: params.customDate,
    );

    return RevenueReportModel.fromJson(json, params.period);
  }
}
