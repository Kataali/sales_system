import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sales_system/shared/error/failure.dart';
import 'package:sales_system/src/features/procurements/domain/entities/procurement.dart';
import 'package:sales_system/src/features/procurements/domain/repositories/procurements_repository.dart';

class ProcurementsController
    extends StateNotifier<AsyncValue<List<ProcurementEntity>>> {
  final ProcurementsRepository repository;

  ProcurementsController(this.repository) : super(const AsyncValue.loading());

  void setProcurements(List<ProcurementEntity> procurements) {
    state = AsyncValue.data(procurements);
  }

  Future<void> fetchProcurements({int page = 1, int limit = 50}) async {
    state = const AsyncValue.loading();

    final Either<Failure, List<ProcurementEntity>> result =
        await repository.fetchProcurements(page: page, limit: limit);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.empty),
      (procurements) => AsyncValue.data(procurements),
    );
  }

  Future<ProcurementEntity> createProcurement({
    String? supplierName,
    String? referenceNumber,
    required List<Map<String, dynamic>> items,
  }) async {
    final result = await repository.createProcurement(
      supplierName: supplierName,
      referenceNumber: referenceNumber,
      items: items,
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (procurement) => procurement,
    );
  }
}

class ProcurementDetailController
    extends StateNotifier<AsyncValue<ProcurementEntity?>> {
  final ProcurementsRepository repository;

  ProcurementDetailController(this.repository)
      : super(const AsyncValue.data(null));

  Future<void> fetchProcurement(int id) async {
    state = const AsyncValue.loading();

    final Either<Failure, ProcurementEntity> result =
        await repository.fetchProcurementById(id);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.empty),
      (procurement) => AsyncValue.data(procurement),
    );
  }
}
