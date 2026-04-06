import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/reports/domain/entities/report_entity.dart';
import 'package:sales_system/src/features/reports/domain/repositories/reports_repository.dart';

class ReportsController extends StateNotifier<AsyncValue<RevenueReportEntity>> {
  final ReportsRepository repository;

  ReportsController(this.repository, RevenueReportParams params)
      : super(const AsyncValue.loading()) {
    fetchReport(params);
  }

  Future<void> fetchReport(RevenueReportParams params) async {
    try {
      state = const AsyncValue.loading();
      final report = await repository.getRevenueReport(params);
      state = AsyncValue.data(report);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}
