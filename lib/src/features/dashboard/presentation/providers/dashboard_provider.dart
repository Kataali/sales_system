import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:sales_system/src/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:sales_system/src/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:sales_system/src/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:sales_system/src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:sales_system/src/features/dashboard/presentation/controllers/dashboard_controller.dart';

final dashboardDatasourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  final storage = ref.read(authSecureStorageProvider);
  return DashboardRemoteDataSource(storage);
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final authSecureStorage = ref.read(authSecureStorageProvider);
  final dataSource = ref.read(dashboardDatasourceProvider);

  return DashboardRepositoryImpl(
    dataSource,
    authSecureStorage,
  );
});

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, AsyncValue<DashboardEntity>>((ref) {
  final repository = ref.read(dashboardRepositoryProvider);
  return DashboardController(repository);
});
