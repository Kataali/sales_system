import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:sales_system/src/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardController extends StateNotifier<AsyncValue<DashboardEntity>> {
  final DashboardRepository repository;

  DashboardController(this.repository) : super(const AsyncValue.loading()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      state = const AsyncValue.loading();
      final data = await repository.getDashboard();
      state = AsyncValue.data(data);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> refresh() async {
    await loadDashboard();
  }
}
