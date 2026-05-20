import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';
import '../models/cart_summary_model.dart';

class CartApiService {
  final ApiClient _apiClient;

  CartApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<CartModel> getCart() async {
    final response = await _apiClient.get(ApiConstants.cart);
    return _parseCartResponse(response);
  }

  Future<Map<String, dynamic>> addItemDemo({
    required int productId,
    int? variantId,
    int quantity = 1,
  }) async {
    return _apiClient.get(ApiConstants.cartAddItem);
  }

  Future<Map<String, dynamic>> updateItemQuantityDemo({
    required int cartItemId,
    required int quantity,
  }) async {
    return _apiClient.get(ApiConstants.cartUpdateItem);
  }

  Future<Map<String, dynamic>> removeItemDemo({required int cartItemId}) async {
    return _apiClient.get(ApiConstants.cartRemoveItem);
  }

  Future<CartModel> clearCartDemo() async {
    final response = await _apiClient.get(ApiConstants.cartClear);
    return _parseCartResponse(response);
  }

  Future<Map<String, dynamic>> applyCouponDemo({
    required String couponCode,
  }) async {
    return _apiClient.get(ApiConstants.cartApplyCoupon);
  }

  Future<Map<String, dynamic>> removeCouponDemo() async {
    return _apiClient.get(ApiConstants.cartRemoveCoupon);
  }

  Future<CartSummaryModel> getSummary() async {
    final response = await _apiClient.get(ApiConstants.cartSummary);
    final data = response['data'];

    if (data is Map) {
      return CartSummaryModel.fromJson(Map<String, dynamic>.from(data));
    }

    return CartSummaryModel.empty();
  }

  CartItemModel? parseUpdatedCartItem(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is! Map) return null;

    final item = data['cart_item'] ?? data['cartItem'] ?? data['item'];
    if (item is! Map) return null;

    return CartItemModel.fromJson(Map<String, dynamic>.from(item));
  }

  CartSummaryModel? parseSummary(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is! Map) return null;

    final summary =
        data['summary'] ?? data['cart_summary'] ?? data['cartSummary'];
    if (summary is! Map) return null;

    return CartSummaryModel.fromJson(Map<String, dynamic>.from(summary));
  }

  CartModel _parseCartResponse(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is Map) {
      return CartModel.fromJson(Map<String, dynamic>.from(data));
    }

    return CartModel.empty();
  }
}
