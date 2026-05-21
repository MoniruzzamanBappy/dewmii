import 'admin_auth_model.dart';

class AdminDashboardSummaryModel {
  final num totalSales;
  final int totalOrders;
  final int totalCustomers;
  final int totalProducts;
  final int pendingOrders;
  final int completedOrders;
  final int cancelledOrders;
  final int lowStockProducts;

  const AdminDashboardSummaryModel({
    required this.totalSales,
    required this.totalOrders,
    required this.totalCustomers,
    required this.totalProducts,
    required this.pendingOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.lowStockProducts,
  });

  factory AdminDashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardSummaryModel(
      totalSales: AdminJson.integer(json['total_sales']),
      totalOrders: AdminJson.integer(json['total_orders']),
      totalCustomers: AdminJson.integer(json['total_customers']),
      totalProducts: AdminJson.integer(json['total_products']),
      pendingOrders: AdminJson.integer(json['pending_orders']),
      completedOrders: AdminJson.integer(json['completed_orders']),
      cancelledOrders: AdminJson.integer(json['cancelled_orders']),
      lowStockProducts: AdminJson.integer(json['low_stock_products']),
    );
  }
}

class AdminTodayModel {
  final num sales;
  final int orders;
  final int newCustomers;
  final int pendingOrders;

  const AdminTodayModel({
    required this.sales,
    required this.orders,
    required this.newCustomers,
    required this.pendingOrders,
  });

  factory AdminTodayModel.fromJson(Map<String, dynamic> json) {
    return AdminTodayModel(
      sales: AdminJson.integer(json['sales']),
      orders: AdminJson.integer(json['orders']),
      newCustomers: AdminJson.integer(json['new_customers']),
      pendingOrders: AdminJson.integer(json['pending_orders']),
    );
  }
}

class AdminRecentOrderModel {
  final int id;
  final String orderNumber;
  final String customerName;
  final String customerPhone;
  final num total;
  final String status;
  final String paymentStatus;
  final DateTime? createdAt;

  const AdminRecentOrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.total,
    required this.status,
    required this.paymentStatus,
    this.createdAt,
  });

  factory AdminRecentOrderModel.fromJson(Map<String, dynamic> json) {
    return AdminRecentOrderModel(
      id: AdminJson.integer(json['id']),
      orderNumber: AdminJson.string(json['order_number'], '#0000'),
      customerName: AdminJson.string(json['customer_name'], 'Customer'),
      customerPhone: AdminJson.string(json['customer_phone']),
      total: AdminJson.integer(json['total']),
      status: AdminJson.string(json['status'], 'pending'),
      paymentStatus: AdminJson.string(json['payment_status'], 'pending'),
      createdAt: AdminJson.date(json['created_at']),
    );
  }
}

class AdminSalesChartPointModel {
  final String date;
  final num sales;
  final int orders;

  const AdminSalesChartPointModel({required this.date, required this.sales, required this.orders});

  factory AdminSalesChartPointModel.fromJson(Map<String, dynamic> json) {
    return AdminSalesChartPointModel(
      date: AdminJson.string(json['date']),
      sales: AdminJson.integer(json['sales']),
      orders: AdminJson.integer(json['orders']),
    );
  }
}

class AdminDashboardModel {
  final AdminDashboardSummaryModel summary;
  final AdminTodayModel today;
  final List<AdminRecentOrderModel> recentOrders;
  final List<AdminSalesChartPointModel> salesChart;

  const AdminDashboardModel({
    required this.summary,
    required this.today,
    required this.recentOrders,
    required this.salesChart,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    final recentOrdersJson = json['recent_orders'];
    final salesChartJson = json['sales_chart'];
    return AdminDashboardModel(
      summary: AdminDashboardSummaryModel.fromJson(AdminJson.map(json['summary'])),
      today: AdminTodayModel.fromJson(AdminJson.map(json['today'])),
      recentOrders: recentOrdersJson is List
          ? recentOrdersJson.map((item) => AdminRecentOrderModel.fromJson(AdminJson.map(item))).toList()
          : [],
      salesChart: salesChartJson is List
          ? salesChartJson.map((item) => AdminSalesChartPointModel.fromJson(AdminJson.map(item))).toList()
          : [],
    );
  }
}
