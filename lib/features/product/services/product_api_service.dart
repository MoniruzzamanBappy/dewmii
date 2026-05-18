import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../discovery/models/product_model.dart';
import '../models/product_detail_model.dart';
import '../models/product_image_model.dart';
import '../models/product_review_model.dart';
import '../models/product_stock_model.dart';

class ProductApiService {
  final ApiClient _apiClient;

  ProductApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<ProductDetailModel?> getProductDetails(int productId) async {
    final response = await _apiClient.get(
      ApiConstants.productDetails(productId),
    );

    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return ProductDetailModel.fromJson(data);
  }

  Future<List<ProductImageModel>> getProductImages(int productId) async {
    final response = await _apiClient.get(
      ApiConstants.productImages(productId),
    );

    final data = response['data'];

    if (data is! List) return [];

    return data
        .map((item) => ProductImageModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ProductReviewsResponseModel> getProductReviews(int productId) async {
    final response = await _apiClient.get(
      ApiConstants.productReviews(productId),
    );

    final data = response['data'];

    if (data is! Map<String, dynamic>) {
      return ProductReviewsResponseModel.fromJson({});
    }

    return ProductReviewsResponseModel.fromJson(data);
  }

  Future<List<ProductModel>> getRelatedProducts(int productId) async {
    final response = await _apiClient.get(
      ApiConstants.productRelated(productId),
    );

    final data = response['data'];

    if (data is! List) return [];

    return data
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ProductStockModel?> checkStock(int productId) async {
    final response = await _apiClient.get(ApiConstants.productStock(productId));

    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return ProductStockModel.fromJson(data);
  }

  Future<Map<String, dynamic>> addReviewDemo({
    required int productId,
    required int rating,
    required String comment,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    return {
      'success': true,
      'message': 'Review submitted successfully',
      'data': {'product_id': productId, 'rating': rating, 'comment': comment},
    };
  }

  Future<Map<String, dynamic>> updateReviewDemo({
    required int reviewId,
    required int rating,
    required String comment,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    return {
      'success': true,
      'message': 'Review updated successfully',
      'data': {'review_id': reviewId, 'rating': rating, 'comment': comment},
    };
  }

  Future<Map<String, dynamic>> deleteReviewDemo({required int reviewId}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return {'success': true, 'message': 'Review deleted successfully'};
  }
}
