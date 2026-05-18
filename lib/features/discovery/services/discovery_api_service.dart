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
    final data = response['data'];

    if (data is Map<String, dynamic>) {
      return HomeDataModel.fromJson(data);
    }

    return HomeDataModel.fromJson({});
  }

  Future<List<BannerModel>> getBanners() async {
    final response = await _apiClient.get(ApiConstants.banners);
    final data = response['data'];

    if (data is! List) return [];

    return data
        .map((item) => BannerModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiClient.get(ApiConstants.categories);
    final data = response['data'];

    if (data is! List) return [];

    return data
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<CategoryModel?> getCategoryDetails(int categoryId) async {
    final response = await _apiClient.get(
      ApiConstants.categoryDetails(categoryId),
    );

    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return CategoryModel.fromJson(data);
  }

  Future<List<ProductModel>> getProducts() async {
    final response = await _apiClient.get(ApiConstants.products);
    final data = response['data'];

    final items = data is Map<String, dynamic> ? data['items'] : null;

    if (items is! List) return [];

    return items
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final response = await _apiClient.get(
      ApiConstants.categoryProducts(categoryId),
    );

    final data = response['data'];
    final items = data is Map<String, dynamic> ? data['items'] : null;

    if (items is! List) return [];

    return items
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final response = await _apiClient.get(ApiConstants.productSearch);
    final data = response['data'];
    final items = data is Map<String, dynamic> ? data['items'] : null;

    if (items is! List) return [];

    final apiResults = items
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();

    final keyword = query.trim().toLowerCase();

    if (keyword.isEmpty) return apiResults;

    final filtered = apiResults.where((product) {
      return product.name.toLowerCase().contains(keyword) ||
          product.slug.toLowerCase().contains(keyword) ||
          product.shortDescription.toLowerCase().contains(keyword) ||
          product.description.toLowerCase().contains(keyword);
    }).toList();

    return filtered.isEmpty ? apiResults : filtered;
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    final response = await _apiClient.get(ApiConstants.featuredProducts);
    final data = response['data'];

    if (data is! List) return [];

    return data
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> getNewArrivals() async {
    final response = await _apiClient.get(ApiConstants.newArrivals);
    final data = response['data'];

    if (data is! List) return [];

    return data
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> getBestSelling() async {
    final response = await _apiClient.get(ApiConstants.bestSelling);
    final data = response['data'];

    if (data is! List) return [];

    return data
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel?> getProductDetails(int productId) async {
    final response = await _apiClient.get(
      ApiConstants.productDetails(productId),
    );

    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return ProductModel.fromJson(data);
  }

  Future<List<String>> getProductImages(int productId) async {
    final response = await _apiClient.get(
      ApiConstants.productImages(productId),
    );

    final data = response['data'];

    if (data is! List) return [];

    return data
        .map((item) {
          if (item is Map<String, dynamic>) {
            return item['image_url']?.toString() ?? '';
          }

          return '';
        })
        .where((url) => url.isNotEmpty)
        .toList();
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

  Future<List<ProductModel>> filterProducts({
    String? query,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String sortBy = 'default',
  }) async {
    List<ProductModel> products;

    if (query != null && query.trim().isNotEmpty) {
      products = await searchProducts(query);
    } else if (categoryId != null) {
      products = await getProductsByCategory(categoryId);
    } else {
      products = await getProducts();
    }

    if (minPrice != null) {
      products = products.where((product) {
        return product.discountPrice >= minPrice;
      }).toList();
    }

    if (maxPrice != null) {
      products = products.where((product) {
        return product.discountPrice <= maxPrice;
      }).toList();
    }

    if (minRating != null) {
      products = products.where((product) {
        return product.rating >= minRating;
      }).toList();
    }

    switch (sortBy) {
      case 'price_low_high':
        products.sort((a, b) => a.discountPrice.compareTo(b.discountPrice));
        break;
      case 'price_high_low':
        products.sort((a, b) => b.discountPrice.compareTo(a.discountPrice));
        break;
      case 'rating_high_low':
        products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'name_a_z':
        products.sort((a, b) => a.name.compareTo(b.name));
        break;
      default:
        break;
    }

    return products;
  }
}
