import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/admin_order_model.dart';

class AdminOrderApiService {
  final ApiClient _apiClient;

  AdminOrderApiService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<AdminOrderListItemModel>> getOrders() async {
    final response = await _apiClient.get(ApiConstants.adminOrders);
    final data = response['data'];

    List<dynamic> items = const [];
    if (data is Map<String, dynamic>) {
      final rawItems = data['items'] ?? data['orders'] ?? data['data'];
      if (rawItems is List) items = rawItems;
    } else if (data is List) {
      items = data;
    }

    return items
        .whereType<Map>()
        .map((item) => AdminOrderListItemModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<AdminOrderDetailsModel?> getOrderDetails(int orderId) async {
    final response = await _apiClient.get(ApiConstants.adminOrderDetails(orderId));
    final data = response['data'];

    if (data is Map<String, dynamic>) {
      return AdminOrderDetailsModel.fromJson(data);
    }

    return null;
  }

  Future<Map<String, dynamic>> updateStatusDemo({
    required int orderId,
    required String status,
    required String note,
  }) async {
    return _apiClient.get(ApiConstants.adminOrderUpdateStatus);
  }

  Future<Map<String, dynamic>> updatePaymentStatusDemo({
    required int orderId,
    required String paymentStatus,
    required String transactionId,
    required String note,
  }) async {
    return _apiClient.get(ApiConstants.adminOrderUpdatePaymentStatus);
  }

  Future<Map<String, dynamic>> updateTrackingDemo({
    required int orderId,
    required String courierName,
    required String trackingNumber,
    required String trackingUrl,
    required String estimatedDeliveryDate,
  }) async {
    return _apiClient.get(ApiConstants.adminOrderUpdateTracking);
  }

  String? parseUpdatedStatus(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return data['status']?.toString();
    }
    return null;
  }

  String? parseUpdatedPaymentStatus(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return (data['payment_status'] ?? data['paymentStatus'])?.toString();
    }
    return null;
  }
}
