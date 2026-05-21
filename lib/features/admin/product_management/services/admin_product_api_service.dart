import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/admin_product_detail_model.dart';
import '../models/admin_product_image_model.dart';
import '../models/admin_product_model.dart';
import '../models/admin_product_stock_model.dart';

class AdminProductApiService {
  final ApiClient _apiClient;

  AdminProductApiService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<AdminProductModel>> getProducts() async {
    final response = await _apiClient.get(ApiConstants.adminProducts);
    final data = response['data'];

    final items = data is Map<String, dynamic>
        ? data['items'] ?? data['products'] ?? data['data']
        : data;

    if (items is! List) return [];

    return items
        .whereType<Map>()
        .map((item) => AdminProductModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<AdminProductDetailModel?> getProductDetails(int productId) async {
    final response = await _apiClient.get(
      ApiConstants.adminProductDetails(productId),
    );

    final data = response['data'];
    if (data is! Map) return null;

    return AdminProductDetailModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<Map<String, dynamic>> createProductDemo({
    required Map<String, dynamic> body,
  }) async {
    try {
      return await _apiClient.post(ApiConstants.adminProductCreate, body: body);
    } catch (_) {
      return _apiClient.get(ApiConstants.adminProductCreate);
    }
  }

  Future<Map<String, dynamic>> updateProductDemo({
    required int productId,
    required Map<String, dynamic> body,
  }) async {
    try {
      return await _apiClient.put(
        ApiConstants.adminProductDetails(productId),
        body: body,
      );
    } catch (_) {
      return _apiClient.get(ApiConstants.adminProductUpdate);
    }
  }

  Future<Map<String, dynamic>> deleteProductDemo({
    required int productId,
  }) async {
    try {
      return await _apiClient.delete(ApiConstants.adminProductDetails(productId));
    } catch (_) {
      return _apiClient.get(ApiConstants.adminProductDelete);
    }
  }

  Future<List<AdminProductImageModel>> uploadImagesDemo({
    required int productId,
  }) async {
    Map<String, dynamic> response;
    try {
      response = await _apiClient.post(
        ApiConstants.adminProductUploadImages,
        body: {'product_id': productId},
      );
    } catch (_) {
      response = await _apiClient.get(ApiConstants.adminProductUploadImages);
    }

    final data = response['data'];
    final items = data is Map<String, dynamic> ? data['items'] ?? data['images'] : data;

    if (items is! List) return [];

    return items
        .whereType<Map>()
        .map((item) => AdminProductImageModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<Map<String, dynamic>> deleteImageDemo({
    required int productId,
    required int imageId,
  }) async {
    try {
      return await _apiClient.delete(
        ApiConstants.adminProductDeleteImage,
        body: {'product_id': productId, 'image_id': imageId},
      );
    } catch (_) {
      return _apiClient.get(ApiConstants.adminProductDeleteImage);
    }
  }

  Future<AdminProductStockModel?> updateStockDemo({
    required int productId,
    required int stock,
  }) async {
    Map<String, dynamic> response;
    try {
      response = await _apiClient.put(
        ApiConstants.adminProductUpdateStock,
        body: {'product_id': productId, 'stock': stock},
      );
    } catch (_) {
      response = await _apiClient.get(ApiConstants.adminProductUpdateStock);
    }

    final data = response['data'];
    if (data is! Map) return null;

    return AdminProductStockModel.fromJson(Map<String, dynamic>.from(data));
  }

  AdminProductModel? parseProduct(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is! Map) return null;
    return AdminProductModel.fromJson(Map<String, dynamic>.from(data));
  }

  int? parseDeletedProductId(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is! Map) return null;
    return _toInt(data['deleted_product_id'] ?? data['id']);
  }

  int? parseDeletedImageId(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is! Map) return null;
    return _toInt(data['deleted_image_id'] ?? data['id']);
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}
