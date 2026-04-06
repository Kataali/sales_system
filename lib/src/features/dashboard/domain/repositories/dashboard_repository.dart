import 'package:sales_system/src/features/dashboard/domain/entities/dashboard_entity.dart';

abstract class DashboardRepository {
  Future<DashboardEntity> getDashboard();
}
