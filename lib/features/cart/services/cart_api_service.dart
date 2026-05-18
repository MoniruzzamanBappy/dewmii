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
    final data = response['data'];

    if (data is! Map<String, dynamic>) {
      return CartModel.empty();
    }

    return CartModel.fromJson(data);
  }

  Future<Map<String, dynamic>> addItemDemo({
    required int productId,
    int? variantId,
    int quantity = 1,
  }) async {
    final response = await _apiClient.get(ApiConstants.cartAddItem);
    return response;
  }

  Future<Map<String, dynamic>> updateItemQuantityDemo({
    required int cartItemId,
    required int quantity,
  }) async {
    final response = await _apiClient.get(ApiConstants.cartUpdateItem);
    return response;
  }

  Future<Map<String, dynamic>> removeItemDemo({required int cartItemId}) async {
    final response = await _apiClient.get(ApiConstants.cartRemoveItem);
    return response;
  }

  Future<CartModel> clearCartDemo() async {
    final response = await _apiClient.get(ApiConstants.cartClear);
    final data = response['data'];

    if (data is! Map<String, dynamic>) {
      return CartModel.empty();
    }

    return CartModel.fromJson(data);
  }

  Future<Map<String, dynamic>> applyCouponDemo({
    required String couponCode,
  }) async {
    final response = await _apiClient.get(ApiConstants.cartApplyCoupon);
    return response;
  }

  Future<Map<String, dynamic>> removeCouponDemo() async {
    final response = await _apiClient.get(ApiConstants.cartRemoveCoupon);
    return response;
  }

  Future<CartSummaryModel> getSummary() async {
    final response = await _apiClient.get(ApiConstants.cartSummary);
    final data = response['data'];

    if (data is! Map<String, dynamic>) {
      return CartSummaryModel.empty();
    }

    return CartSummaryModel.fromJson(data);
  }

  CartItemModel? parseUpdatedCartItem(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    final cartItem = data['cart_item'];

    if (cartItem is! Map<String, dynamic>) return null;

    return CartItemModel.fromJson(cartItem);
  }

  CartSummaryModel? parseSummary(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    final summary = data['summary'];

    if (summary is! Map<String, dynamic>) return null;

    return CartSummaryModel.fromJson(summary);
  }
}
