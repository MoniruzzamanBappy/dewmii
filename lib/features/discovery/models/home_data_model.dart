import 'banner_model.dart';
import 'category_model.dart';
import 'product_model.dart';

class HomeDataModel {
  final List<BannerModel> banners;
  final List<CategoryModel> categories;
  final List<ProductModel> featuredProducts;
  final List<ProductModel> newArrivals;
  final List<ProductModel> bestSelling;

  HomeDataModel({
    required this.banners,
    required this.categories,
    required this.featuredProducts,
    required this.newArrivals,
    required this.bestSelling,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      banners: _parseBanners(json['banners']),
      categories: _parseCategories(json['categories']),
      featuredProducts: _parseProducts(json['featured_products']),
      newArrivals: _parseProducts(json['new_arrivals']),
      bestSelling: _parseProducts(json['best_selling']),
    );
  }

  static List<BannerModel> _parseBanners(dynamic value) {
    if (value is! List) return [];

    return value
        .map((item) => BannerModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static List<CategoryModel> _parseCategories(dynamic value) {
    if (value is! List) return [];

    return value
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static List<ProductModel> _parseProducts(dynamic value) {
    if (value is! List) return [];

    return value
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
