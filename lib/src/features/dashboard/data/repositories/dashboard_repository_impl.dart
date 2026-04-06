import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';
import 'package:sales_system/src/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:sales_system/src/features/dashboard/data/models/dashboard_model.dart';
import 'package:sales_system/src/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:sales_system/src/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource dataSource;
  final AuthSecureStorage storage;


  DashboardRepositoryImpl(this.dataSource, this.storage);

  @override
  Future<DashboardEntity> getDashboard() async {
    final token = await storage.getAccessToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }
    final json = await dataSource.fetchDashboard(token);
    return DashboardModel.fromJson(json);
  }
}
