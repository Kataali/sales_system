class ApiConstants {
  static const baseUrl = "http://localhost:3000";
}

class Endpoints {
  static const login = "/api/auth/login";
  static const register = "/api/auth/register";
  static const products = "/api/products";
  static const sales = "/api/sales";
  static const dashboard = "/api/admin/dashboard";
  static const revenueReport = "/api/reports/revenue";
  static const employees = "/api/admin/employees";
  static String updateEmployeeStatus(String id) => "/api/admin/employees/$id/status";
  static String resetEmployeePassword(String id) => "/api/admin/employees/$id/reset-password";
  static const changePassword = "/api/auth/change-password";
}