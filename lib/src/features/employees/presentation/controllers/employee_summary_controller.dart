import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/employees/data/datasources/employee_remote_datasource.dart';
import 'package:sales_system/src/features/employees/domain/entities/employee_summary.dart';

class EmployeeSummaryController
    extends StateNotifier<AsyncValue<EmployeeSummary>> {
  final EmployeeRemoteDatasource datasource;

  EmployeeSummaryController(this.datasource)
      : super(const AsyncValue.loading()) {
    fetchSummary();
  }

  Future<void> fetchSummary() async {
    try {
      state = const AsyncValue.loading();
      final summary = await datasource.fetchSummary();
      state = AsyncValue.data(summary);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
