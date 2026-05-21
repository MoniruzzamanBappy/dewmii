import '../../../core/network/api_client.dart';
import '../models/admin_auth_model.dart';
import '../models/admin_customer_analytics_model.dart';
import '../models/admin_dashboard_model.dart';
import '../models/admin_product_analytics_model.dart';
import '../models/admin_sales_analytics_model.dart';


class _AdminEndpoints {
  static const String _baseUrl = 'https://moniruzzamanbappy.github.io/ecommerce-demo-json-api';
  static const String login = '$_baseUrl/admin/auth/login.json';
  static const String dashboard = '$_baseUrl/admin/dashboard.json';
  static const String salesAnalytics = '$_baseUrl/admin/analytics/sales.json';
  static const String productAnalytics = '$_baseUrl/admin/analytics/products.json';
  static const String customerAnalytics = '$_baseUrl/admin/analytics/customers.json';
}

class AdminApiService {
  final ApiClient _apiClient;

  AdminApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<AdminAuthModel> login({required String email, required String password}) async {
    try {
      final response = await _apiClient.post(
        _AdminEndpoints.login,
        body: {'email': email, 'password': password},
      );
      return AdminAuthModel.fromJson(response);
    } catch (_) {
      final response = await _apiClient.get(_AdminEndpoints.login);
      return AdminAuthModel.fromJson(response);
    }
  }

  Future<AdminDashboardModel?> getDashboard() async {
    final response = await _apiClient.get(_AdminEndpoints.dashboard);
    final data = response['data'];
    if (data is! Map && data is! Map<String, dynamic>) return null;
    return AdminDashboardModel.fromJson(AdminJson.map(data));
  }

  Future<AdminSalesAnalyticsModel?> getSalesAnalytics() async {
    final response = await _apiClient.get(_AdminEndpoints.salesAnalytics);
    final data = response['data'];
    if (data is! Map && data is! Map<String, dynamic>) return null;
    return AdminSalesAnalyticsModel.fromJson(AdminJson.map(data));
  }

  Future<AdminProductAnalyticsModel?> getProductAnalytics() async {
    final response = await _apiClient.get(_AdminEndpoints.productAnalytics);
    final data = response['data'];
    if (data is! Map && data is! Map<String, dynamic>) return null;
    return AdminProductAnalyticsModel.fromJson(AdminJson.map(data));
  }

  Future<AdminCustomerAnalyticsModel?> getCustomerAnalytics() async {
    final response = await _apiClient.get(_AdminEndpoints.customerAnalytics);
    final data = response['data'];
    if (data is! Map && data is! Map<String, dynamic>) return null;
    return AdminCustomerAnalyticsModel.fromJson(AdminJson.map(data));
  }
}
