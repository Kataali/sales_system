import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/deposits/domain/entities/deposit.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:sales_system/src/features/deposits/data/datasources/deposits_datasource.dart';
import 'package:sales_system/src/features/deposits/data/repositories/deposits_repository_impl.dart';
import 'package:sales_system/src/features/deposits/domain/repositories/deposits_repository.dart';
import 'package:sales_system/src/features/deposits/presentation/controllers/deposits_controller.dart';

final depositsDatasourceProvider = Provider<DepositsRemoteDatasource>((ref) {
  final storage = ref.read(authSecureStorageProvider);
  return DepositsRemoteDatasource(storage: storage);
});

final depositsRepositoryProvider = Provider<DepositsRepository>((ref) {
  final datasource = ref.read(depositsDatasourceProvider);
  return DepositsRepositoryImpl(datasource: datasource);
});

final depositsControllerProvider =
    StateNotifierProvider<DepositsController, AsyncValue<List<Deposit>>>((ref) {
  final repository = ref.read(depositsRepositoryProvider);
  final controller = DepositsController(repository);

  // Watch auth state and fetch deposits when user exists
  final authState = ref.watch(authControllerProvider);
  authState.whenData((user) {
    if (user != null) {
      controller.fetchDeposits();
    } else {
      controller.setDeposits([]);
    }
  });

  return controller;
});

final depositStatsControllerProvider =
    StateNotifierProvider<DepositStatsController, AsyncValue<DepositStats>>((ref) {
  final repository = ref.read(depositsRepositoryProvider);
  final controller = DepositStatsController(repository);

  // Watch auth state and fetch stats when user exists
  final authState = ref.watch(authControllerProvider);
  authState.whenData((user) {
    if (user != null) {
      controller.fetchStats();
    }
  });

  return controller;
});

final depositDetailControllerProvider = StateNotifierProvider.family<DepositDetailController, AsyncValue<Deposit>, int>((ref, id) {
  final repository = ref.read(depositsRepositoryProvider);
  return DepositDetailController(repository, id);
});