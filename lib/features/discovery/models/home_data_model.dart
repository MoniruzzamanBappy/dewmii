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
      banners: _parseList(json['banners'], BannerModel.fromJson),
      categories: _parseList(json['categories'], CategoryModel.fromJson),
      featuredProducts: _parseList(
        json['featured_products'],
        ProductModel.fromJson,
      ),
      newArrivals: _parseList(json['new_arrivals'], ProductModel.fromJson),
      bestSelling: _parseList(json['best_selling'], ProductModel.fromJson),
    );
  }

  bool get isEmpty =>
      banners.isEmpty &&
      categories.isEmpty &&
      featuredProducts.isEmpty &&
      newArrivals.isEmpty &&
      bestSelling.isEmpty;

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic> json) parser,
  ) {
    if (value is! List) return [];
    return value.whereType<Map<String, dynamic>>().map(parser).toList();
  }
}
