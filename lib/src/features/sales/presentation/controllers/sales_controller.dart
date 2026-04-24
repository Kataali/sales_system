import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sales_system/shared/error/failure.dart';
import 'package:sales_system/src/features/sales/domain/entities/sale_entity.dart';
import 'package:sales_system/src/features/sales/domain/repositories/sales_repository.dart';

class SalesController extends StateNotifier<AsyncValue<List<SaleEntity>>> {
  final SalesRepository repository;

  SalesController(this.repository) : super(const AsyncValue.loading());

  void setSales(List<SaleEntity> sales) {
    state = AsyncValue.data(sales);
  }

  Future<void> fetchSales() async {
    state = const AsyncValue.loading();

    final Either<Failure, List<SaleEntity>> result =
        await repository.fetchSales();

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.empty),
      (sales) => AsyncValue.data(sales),
    );
  }
}
