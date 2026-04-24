import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:sales_system/src/features/procurements/data/datasources/procurements_datasource.dart';
import 'package:sales_system/src/features/procurements/data/repositories/procurements_repository_impl.dart';
import 'package:sales_system/src/features/procurements/domain/entities/procurement.dart';
import 'package:sales_system/src/features/procurements/domain/repositories/procurements_repository.dart';
import 'package:sales_system/src/features/procurements/presentation/controllers/procurements_controller.dart';

final procurementsDatasourceProvider =
    Provider<ProcurementsRemoteDatasource>((ref) {
  final storage = ref.read(authSecureStorageProvider);
  return ProcurementsRemoteDatasource(storage: storage);
});

final procurementsRepositoryProvider = Provider<ProcurementsRepository>((ref) {
  final datasource = ref.read(procurementsDatasourceProvider);
  return ProcurementsRepositoryImpl(datasource: datasource);
});

final procurementsControllerProvider = StateNotifierProvider<ProcurementsController,
    AsyncValue<List<ProcurementEntity>>>((ref) {
  final repository = ref.read(procurementsRepositoryProvider);
  final controller = ProcurementsController(repository);

  final authState = ref.watch(authControllerProvider);
  authState.whenData((user) {
    if (user != null) {
      controller.fetchProcurements();
    } else {
      controller.setProcurements([]);
    }
  });

  return controller;
});

final procurementDetailControllerProvider = StateNotifierProvider.family<
    ProcurementDetailController, AsyncValue<ProcurementEntity?>, int>((ref, id) {
  final repository = ref.read(procurementsRepositoryProvider);
  return ProcurementDetailController(repository);
});
