import 'package:flutter/material.dart';
import 'package:sales_system/views/add_inventory.dart';
import 'package:sales_system/views/dashboard_view.dart';
import 'package:sales_system/views/products.dart';
import 'package:sales_system/views/login.dart';
import 'package:sales_system/views/manage_inventory_view.dart';
import 'package:sales_system/views/revenue.dart';

class AppRoutes {
  String? gender;
  Map<String, WidgetBuilder> getRoutes() {
    return {
      DashboardView.routeName: (context) => const DashboardView(),
      HomeView.routeName: (context) => const HomeView(),
      ManageInventoryView.routeName: (context) => const ManageInventoryView(),
      LoginView.routeName: (context) => const LoginView(),
      RevenueView.routeName: (context) => const RevenueView(),
      AddInventoryView.routeName: (context) => const AddInventoryView()
    };
  }
}
