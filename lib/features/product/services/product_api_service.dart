import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../discovery/models/product_model.dart';
import '../models/product_detail_model.dart';
import '../models/product_image_model.dart';
import '../models/product_review_model.dart';
import '../models/product_stock_model.dart';

class ProductApiService {
  final ApiClient _apiClient;

  ProductApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<ProductDetailModel?> getProductDetails(int productId) async {
    final response = await _apiClient.get(ApiConstants.productDetails(productId));
    final data = response['data'];
    if (data is Map) return ProductDetailModel.fromJson(Map<String, dynamic>.from(data));
    return null;
  }

  Future<List<ProductImageModel>> getProductImages(int productId) async {
    final response = await _apiClient.get(ApiConstants.productImages(productId));
    final data = response['data'];
    if (data is! List) return [];
    return data.map((item) => ProductImageModel.fromJson(Map<String, dynamic>.from(item as Map))).toList();
  }

  Future<ProductReviewsResponseModel> getProductReviews(int productId) async {
    final response = await _apiClient.get(ApiConstants.productReviews(productId));
    final data = response['data'];
    if (data is Map) return ProductReviewsResponseModel.fromJson(Map<String, dynamic>.from(data));
    if (data is List) return ProductReviewsResponseModel.fromJson({'items': data});
    return const ProductReviewsResponseModel(
      summary: ProductReviewSummaryModel(averageRating: 0, totalReviews: 0, ratingCount: {}),
      reviews: [],
    );
  }

  Future<List<ProductModel>> getRelatedProducts(int productId) async {
    final response = await _apiClient.get(ApiConstants.productRelated(productId));
    final data = response['data'];
    if (data is! List) return [];
    return data.map((item) => ProductModel.fromJson(Map<String, dynamic>.from(item as Map))).toList();
  }

  Future<ProductStockModel?> checkStock(int productId) async {
    final response = await _apiClient.get(ApiConstants.productStock(productId));
    final data = response['data'];
    if (data is Map) return ProductStockModel.fromJson(Map<String, dynamic>.from(data));
    return null;
  }

  Future<Map<String, dynamic>> addReviewDemo({
    required int productId,
    required int rating,
    required String comment,
  }) async {
    try {
      return await _apiClient.post(
        ApiConstants.productReviews(productId),
        body: {'rating': rating, 'comment': comment},
      );
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 650));
      return {
        'success': true,
        'message': 'Review submitted successfully',
        'data': {'product_id': productId, 'rating': rating, 'comment': comment},
      };
    }
  }

  Future<Map<String, dynamic>> updateReviewDemo({
    required int reviewId,
    required int rating,
    required String comment,
  }) async {
    try {
      return await _apiClient.put(
        '${ApiConstants.baseUrl}/reviews/$reviewId',
        body: {'rating': rating, 'comment': comment},
      );
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 650));
      return {
        'success': true,
        'message': 'Review updated successfully',
        'data': {'review_id': reviewId, 'rating': rating, 'comment': comment},
      };
    }
  }

  Future<Map<String, dynamic>> deleteReviewDemo({required int reviewId}) async {
    try {
      return await _apiClient.delete('${ApiConstants.baseUrl}/reviews/$reviewId');
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 500));
      return {'success': true, 'message': 'Review deleted successfully'};
    }
  }
}
