import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/invoice_model.dart';
import '../models/order_details_model.dart';
import '../models/order_list_item_model.dart';
import '../models/order_tracking_model.dart';

class OrderApiService {
  final ApiClient _apiClient;

  OrderApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<OrderListItemModel>> getOrders() async {
    final response = await _apiClient.get(ApiConstants.orders);
    final data = response['data'];

    if (data is! Map<String, dynamic>) return [];

    final items = data['items'];

    if (items is! List) return [];

    return items
        .map(
          (item) => OrderListItemModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<OrderDetailsModel?> getOrderDetails(int orderId) async {
    final response = await _apiClient.get(ApiConstants.orderDetails(orderId));

    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return OrderDetailsModel.fromJson(data);
  }

  Future<OrderTrackingModel?> getOrderTracking(int orderId) async {
    final response = await _apiClient.get(ApiConstants.orderTracking(orderId));

    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return OrderTrackingModel.fromJson(data);
  }

  Future<Map<String, dynamic>> cancelOrderDemo({
    required int orderId,
    required String reason,
  }) async {
    return _apiClient.get(ApiConstants.orderCancel);
  }

  Future<Map<String, dynamic>> returnRequestDemo({
    required int orderId,
    required String reason,
    required String description,
  }) async {
    return _apiClient.get(ApiConstants.orderReturnRequest);
  }

  Future<Map<String, dynamic>> refundRequestDemo({
    required int orderId,
    required String reason,
    required String description,
  }) async {
    return _apiClient.get(ApiConstants.orderRefundRequest);
  }

  Future<InvoiceModel?> getInvoiceDemo({required int orderId}) async {
    final response = await _apiClient.get(ApiConstants.orderInvoice);
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return InvoiceModel.fromJson(data);
  }

  String? parseCancelledStatus(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return data['status'];
  }
}
