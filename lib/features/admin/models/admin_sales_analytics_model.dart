import 'admin_auth_model.dart';

class AdminSalesFilterModel {
  final String from;
  final String to;
  final String groupBy;
  const AdminSalesFilterModel({required this.from, required this.to, required this.groupBy});
  factory AdminSalesFilterModel.fromJson(Map<String, dynamic> json) => AdminSalesFilterModel(
        from: AdminJson.string(json['from']),
        to: AdminJson.string(json['to']),
        groupBy: AdminJson.string(json['group_by'], 'daily'),
      );
}

class AdminSalesChartModel {
  final String date;
  final num sales;
  final int orders;
  const AdminSalesChartModel({required this.date, required this.sales, required this.orders});
  factory AdminSalesChartModel.fromJson(Map<String, dynamic> json) => AdminSalesChartModel(
        date: AdminJson.string(json['date']),
        sales: AdminJson.integer(json['sales']),
        orders: AdminJson.integer(json['orders']),
      );
}

class AdminPaymentBreakdownModel {
  final String paymentMethod;
  final int orders;
  final num amount;
  const AdminPaymentBreakdownModel({required this.paymentMethod, required this.orders, required this.amount});
  factory AdminPaymentBreakdownModel.fromJson(Map<String, dynamic> json) => AdminPaymentBreakdownModel(
        paymentMethod: AdminJson.string(json['payment_method'], 'unknown'),
        orders: AdminJson.integer(json['orders']),
        amount: AdminJson.integer(json['amount']),
      );
}

class AdminSalesAnalyticsModel {
  final AdminSalesFilterModel filter;
  final num totalSales;
  final int totalOrders;
  final num averageOrderValue;
  final num totalDiscount;
  final num totalShippingCharge;
  final List<AdminSalesChartModel> chart;
  final List<AdminPaymentBreakdownModel> paymentBreakdown;

  const AdminSalesAnalyticsModel({
    required this.filter,
    required this.totalSales,
    required this.totalOrders,
    required this.averageOrderValue,
    required this.totalDiscount,
    required this.totalShippingCharge,
    required this.chart,
    required this.paymentBreakdown,
  });

  factory AdminSalesAnalyticsModel.fromJson(Map<String, dynamic> json) {
    final chartJson = json['chart'];
    final paymentJson = json['payment_breakdown'];
    return AdminSalesAnalyticsModel(
      filter: AdminSalesFilterModel.fromJson(AdminJson.map(json['filter'])),
      totalSales: AdminJson.integer(json['total_sales']),
      totalOrders: AdminJson.integer(json['total_orders']),
      averageOrderValue: AdminJson.integer(json['average_order_value']),
      totalDiscount: AdminJson.integer(json['total_discount']),
      totalShippingCharge: AdminJson.integer(json['total_shipping_charge']),
      chart: chartJson is List ? chartJson.map((item) => AdminSalesChartModel.fromJson(AdminJson.map(item))).toList() : [],
      paymentBreakdown: paymentJson is List ? paymentJson.map((item) => AdminPaymentBreakdownModel.fromJson(AdminJson.map(item))).toList() : [],
    );
  }
}
