import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/wishlist_item_model.dart';

class WishlistApiService {
  final ApiClient _apiClient;

  WishlistApiService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<WishlistItemModel>> getWishlist() async {
    final response = await _apiClient.get(ApiConstants.wishlist);
    final items = _extractList(response);

    return items
        .whereType<Map>()
        .map((item) => WishlistItemModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<Map<String, dynamic>> addToWishlist({required int productId}) async {
    try {
      return await _apiClient.post(
        ApiConstants.wishlistAdd,
        body: {'product_id': productId},
      );
    } catch (_) {
      return addToWishlistDemo(productId: productId);
    }
  }

  Future<Map<String, dynamic>> removeFromWishlist({
    required int productId,
  }) async {
    try {
      return await _apiClient.delete(
        ApiConstants.wishlistRemove,
        body: {'product_id': productId},
      );
    } catch (_) {
      return removeFromWishlistDemo(productId: productId);
    }
  }

  Future<Map<String, dynamic>> moveToCart({required int productId}) async {
    try {
      return await _apiClient.post(
        ApiConstants.wishlistMoveToCart,
        body: {'product_id': productId},
      );
    } catch (_) {
      return moveToCartDemo(productId: productId);
    }
  }

  Future<Map<String, dynamic>> addToWishlistDemo({
    required int productId,
  }) async {
    return _apiClient.get(ApiConstants.wishlistAdd);
  }

  Future<Map<String, dynamic>> removeFromWishlistDemo({
    required int productId,
  }) async {
    return _apiClient.get(ApiConstants.wishlistRemove);
  }

  Future<Map<String, dynamic>> moveToCartDemo({required int productId}) async {
    return _apiClient.get(ApiConstants.wishlistMoveToCart);
  }

  WishlistItemModel? parseAddedWishlistItem(Map<String, dynamic> response) {
    final data = _asMap(response['data']);
    if (data == null) return null;

    final item = _asMap(data['item']) ??
        _asMap(data['wishlist_item']) ??
        _asMap(data['product']) ??
        data;

    return WishlistItemModel.fromJson(item);
  }

  int? parseRemovedProductId(Map<String, dynamic> response) {
    final data = _asMap(response['data']);
    return _toIntOrNull(
      data?['removed_product_id'] ??
          data?['product_id'] ??
          response['removed_product_id'] ??
          response['product_id'],
    );
  }

  int? parseWishlistCount(Map<String, dynamic> response) {
    final data = _asMap(response['data']);
    return _toIntOrNull(
      data?['wishlist_count'] ??
          data?['count'] ??
          response['wishlist_count'] ??
          response['count'],
    );
  }

  List<dynamic> _extractList(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is List) return data;
    if (data is Map) {
      return data['items'] as List? ??
          data['wishlist'] as List? ??
          data['products'] as List? ??
          const [];
    }

    return response['items'] as List? ??
        response['wishlist'] as List? ??
        response['products'] as List? ??
        const [];
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  int? _toIntOrNull(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}
