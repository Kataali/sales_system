import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:sales_system/src/features/reports/data/datasources/reports_remote_datasource.dart';
import 'package:sales_system/src/features/reports/data/repositories/reports_repository_impl.dart';
import 'package:sales_system/src/features/reports/domain/entities/report_entity.dart';
import 'package:sales_system/src/features/reports/domain/repositories/reports_repository.dart';
import 'package:sales_system/src/features/reports/presentation/controllers/reports_controller.dart';

final reportsDatasourceProvider = Provider<ReportsRemoteDataSource>((ref) {
  final storage = ref.read(authSecureStorageProvider);
  return ReportsRemoteDataSource(storage);
});

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  final storage = ref.read(authSecureStorageProvider);
  final dataSource = ref.read(reportsDatasourceProvider);
  return ReportsRepositoryImpl(
    dataSource,
    storage,
  );
});

final reportsControllerProvider =
    StateNotifierProvider.family<ReportsController,
        AsyncValue<RevenueReportEntity>, RevenueReportParams>((ref, params) {
  final repository = ref.read(reportsRepositoryProvider);
  return ReportsController(repository, params);
});
