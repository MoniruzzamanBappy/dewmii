import 'admin_auth_model.dart';

class AdminTopCustomerModel {
  final int userId;
  final String name;
  final String email;
  final String phone;
  final int totalOrders;
  final num totalSpent;
  const AdminTopCustomerModel({required this.userId, required this.name, required this.email, required this.phone, required this.totalOrders, required this.totalSpent});
  factory AdminTopCustomerModel.fromJson(Map<String, dynamic> json) => AdminTopCustomerModel(
        userId: AdminJson.integer(json['user_id']),
        name: AdminJson.string(json['name'], 'Customer'),
        email: AdminJson.string(json['email']),
        phone: AdminJson.string(json['phone']),
        totalOrders: AdminJson.integer(json['total_orders']),
        totalSpent: AdminJson.integer(json['total_spent']),
      );
}

class AdminCustomerChartModel {
  final String date;
  final int newCustomers;
  const AdminCustomerChartModel({required this.date, required this.newCustomers});
  factory AdminCustomerChartModel.fromJson(Map<String, dynamic> json) => AdminCustomerChartModel(
        date: AdminJson.string(json['date']),
        newCustomers: AdminJson.integer(json['new_customers']),
      );
}

class AdminCustomerAnalyticsModel {
  final int totalCustomers;
  final int newCustomers;
  final int returningCustomers;
  final int inactiveCustomers;
  final List<AdminTopCustomerModel> topCustomers;
  final List<AdminCustomerChartModel> chart;
  const AdminCustomerAnalyticsModel({required this.totalCustomers, required this.newCustomers, required this.returningCustomers, required this.inactiveCustomers, required this.topCustomers, required this.chart});
  factory AdminCustomerAnalyticsModel.fromJson(Map<String, dynamic> json) {
    final topJson = json['top_customers'];
    final chartJson = json['chart'];
    return AdminCustomerAnalyticsModel(
      totalCustomers: AdminJson.integer(json['total_customers']),
      newCustomers: AdminJson.integer(json['new_customers']),
      returningCustomers: AdminJson.integer(json['returning_customers']),
      inactiveCustomers: AdminJson.integer(json['inactive_customers']),
      topCustomers: topJson is List ? topJson.map((item) => AdminTopCustomerModel.fromJson(AdminJson.map(item))).toList() : [],
      chart: chartJson is List ? chartJson.map((item) => AdminCustomerChartModel.fromJson(AdminJson.map(item))).toList() : [],
    );
  }
}
