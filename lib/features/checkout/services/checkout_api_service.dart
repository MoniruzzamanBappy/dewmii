import 'package:dewmii/features/cart/models/cart_summary_model.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/checkout_model.dart';
import '../models/order_preview_model.dart';
import '../models/order_result_model.dart';
import '../models/payment_method_model.dart';
import '../models/payment_result_model.dart';
import '../models/shipping_method_model.dart';

class CheckoutApiService {
  final ApiClient _apiClient;

  CheckoutApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<CheckoutModel?> getCheckoutData() async {
    final response = await _apiClient.get(ApiConstants.checkout);
    final data = response['data'];
    if (data is! Map) return null;
    return CheckoutModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<Map<String, dynamic>> validateCheckoutDemo({
    int? addressId,
    int? shippingMethodId,
    int? paymentMethodId,
  }) async {
    final body = {
      if (addressId != null) 'address_id': addressId,
      if (shippingMethodId != null) 'shipping_method_id': shippingMethodId,
      if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
    };

    try {
      return await _apiClient.post(ApiConstants.checkoutValidate, body: body);
    } catch (_) {
      return _apiClient.get(ApiConstants.checkoutValidate);
    }
  }

  Future<List<ShippingMethodModel>> getShippingMethods() async {
    final response = await _apiClient.get(ApiConstants.shippingMethods);
    final data = response['data'];
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((item) => ShippingMethodModel.fromJson(Map<String, dynamic>.from(item)))
        .where((item) => item.name.isNotEmpty)
        .toList();
  }

  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final response = await _apiClient.get(ApiConstants.paymentMethods);
    final data = response['data'];
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((item) => PaymentMethodModel.fromJson(Map<String, dynamic>.from(item)))
        .where((item) => item.name.isNotEmpty)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  Future<OrderPreviewModel?> previewOrderDemo() async {
    final response = await _apiClient.get(ApiConstants.orderPreview);
    final data = response['data'];
    if (data is! Map) return null;
    return OrderPreviewModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<OrderResultModel?> placeOrderDemo({
    int? addressId,
    int? shippingMethodId,
    int? paymentMethodId,
  }) async {
    final body = {
      if (addressId != null) 'address_id': addressId,
      if (shippingMethodId != null) 'shipping_method_id': shippingMethodId,
      if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
    };

    try {
      final response = await _apiClient.post(ApiConstants.placeOrder, body: body);
      final data = response['data'];
      if (data is! Map) return null;
      return OrderResultModel.fromJson(Map<String, dynamic>.from(data));
    } catch (_) {
      final response = await _apiClient.get(ApiConstants.placeOrder);
      final data = response['data'];
      if (data is! Map) return null;
      return OrderResultModel.fromJson(Map<String, dynamic>.from(data));
    }
  }

  Future<PaymentResultModel?> initiatePaymentDemo({int? orderId}) async {
    final body = {if (orderId != null) 'order_id': orderId};

    try {
      final response = await _apiClient.post(ApiConstants.paymentInitiate, body: body);
      final data = response['data'];
      if (data is! Map) return null;
      return PaymentResultModel.fromJson(Map<String, dynamic>.from(data));
    } catch (_) {
      final response = await _apiClient.get(ApiConstants.paymentInitiate);
      final data = response['data'];
      if (data is! Map) return null;
      return PaymentResultModel.fromJson(Map<String, dynamic>.from(data));
    }
  }

  Future<PaymentResultModel?> verifyPaymentDemo() async {
    final response = await _apiClient.get(ApiConstants.paymentVerify);
    final data = response['data'];
    if (data is! Map) return null;
    return PaymentResultModel.fromJson(Map<String, dynamic>.from(data));
  }

  CartSummaryModel? parseValidationSummary(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is! Map) return null;
    final summary = data['summary'];
    if (summary is! Map) return null;
    return CartSummaryModel.fromJson(Map<String, dynamic>.from(summary));
  }

  bool isCheckoutValid(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map && data['is_valid'] != null) return data['is_valid'] == true;
    return response['success'] != false;
  }
}
