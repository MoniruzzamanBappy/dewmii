import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/invoice_model.dart';
import '../models/order_details_model.dart';
import '../models/order_list_item_model.dart';
import '../models/order_tracking_model.dart';

class OrderApiService {
  final ApiClient _apiClient;

  OrderApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<OrderListItemModel>> getOrders() async {
    final response = await _apiClient.get(ApiConstants.orders);
    final data = _extractData(response);
    final items = data is Map<String, dynamic> ? (data['items'] ?? data['orders']) : data;

    if (items is! List) return [];
    return items
        .whereType<Map<String, dynamic>>()
        .map(OrderListItemModel.fromJson)
        .toList();
  }

  Future<OrderDetailsModel?> getOrderDetails(int orderId) async {
    final response = await _apiClient.get(ApiConstants.orderDetails(orderId));
    final data = _extractData(response);
    if (data is! Map<String, dynamic>) return null;
    return OrderDetailsModel.fromJson(data);
  }

  Future<OrderTrackingModel?> getOrderTracking(int orderId) async {
    final response = await _apiClient.get(ApiConstants.orderTracking(orderId));
    final data = _extractData(response);
    if (data is! Map<String, dynamic>) return null;
    return OrderTrackingModel.fromJson(data);
  }

  Future<Map<String, dynamic>> cancelOrderDemo({
    required int orderId,
    required String reason,
  }) async {
    final body = {'order_id': orderId, 'reason': reason};
    try {
      return await _apiClient.post(ApiConstants.orderCancel, body: body);
    } catch (_) {
      return _apiClient.get(ApiConstants.orderCancel);
    }
  }

  Future<Map<String, dynamic>> returnRequestDemo({
    required int orderId,
    required String reason,
    required String description,
  }) async {
    final body = {'order_id': orderId, 'reason': reason, 'description': description};
    try {
      return await _apiClient.post(ApiConstants.orderReturnRequest, body: body);
    } catch (_) {
      return _apiClient.get(ApiConstants.orderReturnRequest);
    }
  }

  Future<Map<String, dynamic>> refundRequestDemo({
    required int orderId,
    required String reason,
    required String description,
  }) async {
    final body = {'order_id': orderId, 'reason': reason, 'description': description};
    try {
      return await _apiClient.post(ApiConstants.orderRefundRequest, body: body);
    } catch (_) {
      return _apiClient.get(ApiConstants.orderRefundRequest);
    }
  }

  Future<InvoiceModel?> getInvoiceDemo({required int orderId}) async {
    final response = await _apiClient.get(ApiConstants.orderInvoice);
    final data = _extractData(response);
    if (data is! Map<String, dynamic>) return null;
    return InvoiceModel.fromJson(data);
  }

  String? parseCancelledStatus(Map<String, dynamic> response) {
    final data = _extractData(response);
    if (data is! Map<String, dynamic>) return null;
    final status = data['status'] ?? response['status'];
    return status?.toString();
  }

  dynamic _extractData(Map<String, dynamic> response) {
    return response['data'] ?? response['result'] ?? response;
  }
}
