import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/admin_category_model.dart';

class AdminCategoryApiService {
  final ApiClient _apiClient;

  AdminCategoryApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<AdminCategoryModel>> getCategories() async {
    final response = await _apiClient.get(ApiConstants.adminCategories);
    final items = _extractList(response);

    return items
        .whereType<Map<String, dynamic>>()
        .map(AdminCategoryModel.fromJson)
        .toList();
  }

  Future<Map<String, dynamic>> createCategory({
    required Map<String, dynamic> body,
  }) async {
    try {
      return await _apiClient.post(ApiConstants.adminCategories, body: body);
    } catch (_) {
      return createCategoryDemo(body: body);
    }
  }

  Future<Map<String, dynamic>> updateCategory({
    required int categoryId,
    required Map<String, dynamic> body,
  }) async {
    try {
      return await _apiClient.put(
        '${ApiConstants.adminCategories}/$categoryId',
        body: body,
      );
    } catch (_) {
      return updateCategoryDemo(categoryId: categoryId, body: body);
    }
  }

  Future<Map<String, dynamic>> deleteCategory({required int categoryId}) async {
    try {
      return await _apiClient.delete('${ApiConstants.adminCategories}/$categoryId');
    } catch (_) {
      return deleteCategoryDemo(categoryId: categoryId);
    }
  }

  Future<Map<String, dynamic>> createCategoryDemo({
    required Map<String, dynamic> body,
  }) async {
    return _apiClient.get(ApiConstants.adminCategoryCreate);
  }

  Future<Map<String, dynamic>> updateCategoryDemo({
    required int categoryId,
    required Map<String, dynamic> body,
  }) async {
    return _apiClient.get(ApiConstants.adminCategoryUpdate);
  }

  Future<Map<String, dynamic>> deleteCategoryDemo({
    required int categoryId,
  }) async {
    return _apiClient.get(ApiConstants.adminCategoryDelete);
  }

  AdminCategoryModel? parseCategory(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) return AdminCategoryModel.fromJson(data);

    final category = response['category'];
    if (category is Map<String, dynamic>) {
      return AdminCategoryModel.fromJson(category);
    }

    return null;
  }

  int? parseDeletedCategoryId(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return _toIntOrNull(
        data['deleted_category_id'] ?? data['deletedCategoryId'] ?? data['id'],
      );
    }

    return _toIntOrNull(response['deleted_category_id'] ?? response['id']);
  }

  List<dynamic> _extractList(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final items = data['items'] ?? data['categories'] ?? data['data'];
      if (items is List) return items;
    }

    final categories = response['categories'];
    if (categories is List) return categories;

    return [];
  }

  int? _toIntOrNull(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}
