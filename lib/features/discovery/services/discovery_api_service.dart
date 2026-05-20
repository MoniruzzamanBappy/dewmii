import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/home_data_model.dart';
import '../models/product_model.dart';

class DiscoveryApiService {
  final ApiClient _apiClient;

  DiscoveryApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<HomeDataModel> getHomeData() async {
    final response = await _apiClient.get(ApiConstants.home);
    final data = _asMap(response['data']);
    return HomeDataModel.fromJson(data ?? const {});
  }

  Future<List<BannerModel>> getBanners() async {
    final response = await _apiClient.get(ApiConstants.banners);
    return _parseList(response['data'], BannerModel.fromJson);
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiClient.get(ApiConstants.categories);
    return _parseList(response['data'], CategoryModel.fromJson);
  }

  Future<CategoryModel?> getCategoryDetails(int categoryId) async {
    final response = await _apiClient.get(
      ApiConstants.categoryDetails(categoryId),
    );
    final data = _asMap(response['data']);
    return data == null ? null : CategoryModel.fromJson(data);
  }

  Future<List<ProductModel>> getProducts() async {
    final response = await _apiClient.get(ApiConstants.products);
    return _parseProductPayload(response['data']);
  }

  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final response = await _apiClient.get(
      ApiConstants.categoryProducts(categoryId),
    );
    return _parseProductPayload(response['data']);
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final response = await _apiClient.get(ApiConstants.productSearch);
    final products = _parseProductPayload(response['data']);
    final keyword = query.trim().toLowerCase();

    if (keyword.isEmpty) return products;

    final filtered = products.where((product) {
      final searchable = [
        product.name,
        product.slug,
        product.sku,
        product.shortDescription,
        product.description,
      ].join(' ').toLowerCase();

      return searchable.contains(keyword);
    }).toList();

    return filtered;
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    final response = await _apiClient.get(ApiConstants.featuredProducts);
    return _parseList(response['data'], ProductModel.fromJson);
  }

  Future<List<ProductModel>> getNewArrivals() async {
    final response = await _apiClient.get(ApiConstants.newArrivals);
    return _parseList(response['data'], ProductModel.fromJson);
  }

  Future<List<ProductModel>> getBestSelling() async {
    final response = await _apiClient.get(ApiConstants.bestSelling);
    return _parseList(response['data'], ProductModel.fromJson);
  }

  Future<ProductModel?> getProductDetails(int productId) async {
    final response = await _apiClient.get(
      ApiConstants.productDetails(productId),
    );
    final data = _asMap(response['data']);
    return data == null ? null : ProductModel.fromJson(data);
  }

  Future<List<String>> getProductImages(int productId) async {
    final response = await _apiClient.get(
      ApiConstants.productImages(productId),
    );
    final data = response['data'];

    if (data is! List) return [];

    return data
        .whereType<Map<String, dynamic>>()
        .map((item) => item['image_url']?.toString() ?? '')
        .where((url) => url.isNotEmpty)
        .toList();
  }

  Future<List<ProductModel>> getRelatedProducts(int productId) async {
    final response = await _apiClient.get(
      ApiConstants.productRelated(productId),
    );
    return _parseList(response['data'], ProductModel.fromJson);
  }

  Future<List<ProductModel>> filterProducts({
    String? query,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String sortBy = 'default',
  }) async {
    final products = query != null && query.trim().isNotEmpty
        ? await searchProducts(query)
        : categoryId != null
        ? await getProductsByCategory(categoryId)
        : await getProducts();

    final filtered = products.where((product) {
      final price = product.discountPrice;
      final matchesMinPrice = minPrice == null || price >= minPrice;
      final matchesMaxPrice = maxPrice == null || price <= maxPrice;
      final matchesRating = minRating == null || product.rating >= minRating;
      return matchesMinPrice && matchesMaxPrice && matchesRating;
    }).toList();

    switch (sortBy) {
      case 'price_low_high':
        filtered.sort((a, b) => a.discountPrice.compareTo(b.discountPrice));
        break;
      case 'price_high_low':
        filtered.sort((a, b) => b.discountPrice.compareTo(a.discountPrice));
        break;
      case 'rating_high_low':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'name_a_z':
        filtered.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      default:
        break;
    }

    return filtered;
  }

  List<ProductModel> _parseProductPayload(dynamic data) {
    if (data is List) return _parseList(data, ProductModel.fromJson);

    final map = _asMap(data);
    if (map == null) return [];

    return _parseList(
      map['items'] ?? map['products'] ?? map['data'],
      ProductModel.fromJson,
    );
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    return null;
  }

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic> json) parser,
  ) {
    if (value is! List) return [];
    return value.whereType<Map<String, dynamic>>().map(parser).toList();
  }
}
