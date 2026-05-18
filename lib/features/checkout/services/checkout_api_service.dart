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

  CheckoutApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<CheckoutModel?> getCheckoutData() async {
    final response = await _apiClient.get(ApiConstants.checkout);
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return CheckoutModel.fromJson(data);
  }

  Future<Map<String, dynamic>> validateCheckoutDemo() async {
    return _apiClient.get(ApiConstants.checkoutValidate);
  }

  Future<List<ShippingMethodModel>> getShippingMethods() async {
    final response = await _apiClient.get(ApiConstants.shippingMethods);
    final data = response['data'];

    if (data is! List) return [];

    return data
        .map(
          (item) => ShippingMethodModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final response = await _apiClient.get(ApiConstants.paymentMethods);
    final data = response['data'];

    if (data is! List) return [];

    return data
        .map(
          (item) => PaymentMethodModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<OrderPreviewModel?> previewOrderDemo() async {
    final response = await _apiClient.get(ApiConstants.orderPreview);
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return OrderPreviewModel.fromJson(data);
  }

  Future<OrderResultModel?> placeOrderDemo() async {
    final response = await _apiClient.get(ApiConstants.placeOrder);
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return OrderResultModel.fromJson(data);
  }

  Future<PaymentResultModel?> initiatePaymentDemo() async {
    final response = await _apiClient.get(ApiConstants.paymentInitiate);
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return PaymentResultModel.fromJson(data);
  }

  Future<PaymentResultModel?> verifyPaymentDemo() async {
    final response = await _apiClient.get(ApiConstants.paymentVerify);
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return PaymentResultModel.fromJson(data);
  }

  CartSummaryModel? parseValidationSummary(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    final summary = data['summary'];

    if (summary is! Map<String, dynamic>) return null;

    return CartSummaryModel.fromJson(summary);
  }

  bool isCheckoutValid(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! Map<String, dynamic>) return false;

    return data['is_valid'] == true;
  }
}
