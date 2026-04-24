class ApiConstants {
  static const baseUrl = "http://localhost:3000";
}

class Endpoints {
  static const login = "/api/auth/login";
  static const register = "/api/auth/register";
  static const products = "/api/products";
  static const sales = "/api/sales";
  static String saleById(String id) => "/api/sales/$id";
  static const dashboard = "/api/admin/dashboard";
  static const revenueReport = "/api/reports/revenue";
  static const employees = "/api/admin/employees";
  static String updateEmployeeStatus(String id) =>
      "/api/admin/employees/$id/status";
  static String resetEmployeePassword(String id) =>
      "/api/admin/employees/$id/reset-password";
  static const changePassword = "/api/auth/change-password";
  static const deposits = "/api/deposits";
  static String depositById(String id) => "/api/deposits/$id";
  static const depositStats = "/api/deposits/stats";
  static const procurements = "/api/procurements";
  static String procurementById(String id) => "/api/procurements/$id";
  static const employeeSummary = "/api/v1/employees/summary";
  static const employeeSales = "/api/v1/employees/sales";
  static const employeeInventory = "/api/v1/employees/inventory";
}
