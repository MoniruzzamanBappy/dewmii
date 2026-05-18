import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/wishlist_item_model.dart';

class WishlistApiService {
  final ApiClient _apiClient;

  WishlistApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<WishlistItemModel>> getWishlist() async {
    final response = await _apiClient.get(ApiConstants.wishlist);
    final data = response['data'];

    if (data is! Map<String, dynamic>) return [];

    final items = data['items'];

    if (items is! List) return [];

    return items
        .map((item) => WishlistItemModel.fromJson(item as Map<String, dynamic>))
        .toList();
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
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return WishlistItemModel.fromJson(data);
  }

  int? parseRemovedProductId(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return data['removed_product_id'];
  }

  int? parseWishlistCount(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return data['wishlist_count'];
  }
}
