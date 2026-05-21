import 'admin_auth_model.dart';

class AdminTopSellingProductModel {
  final int productId;
  final String name;
  final String sku;
  final int soldQuantity;
  final num revenue;
  final String thumbnail;
  const AdminTopSellingProductModel({required this.productId, required this.name, required this.sku, required this.soldQuantity, required this.revenue, required this.thumbnail});
  factory AdminTopSellingProductModel.fromJson(Map<String, dynamic> json) => AdminTopSellingProductModel(
        productId: AdminJson.integer(json['product_id']),
        name: AdminJson.string(json['name'], 'Product'),
        sku: AdminJson.string(json['sku']),
        soldQuantity: AdminJson.integer(json['sold_quantity']),
        revenue: AdminJson.integer(json['revenue']),
        thumbnail: AdminJson.string(json['thumbnail']),
      );
}

class AdminStockProductModel {
  final int productId;
  final String name;
  final String sku;
  final int stock;
  final String stockStatus;
  final String thumbnail;
  const AdminStockProductModel({required this.productId, required this.name, required this.sku, required this.stock, required this.stockStatus, required this.thumbnail});
  factory AdminStockProductModel.fromJson(Map<String, dynamic> json) => AdminStockProductModel(
        productId: AdminJson.integer(json['product_id']),
        name: AdminJson.string(json['name'], 'Product'),
        sku: AdminJson.string(json['sku']),
        stock: AdminJson.integer(json['stock']),
        stockStatus: AdminJson.string(json['stock_status'], 'in_stock'),
        thumbnail: AdminJson.string(json['thumbnail']),
      );
}

class AdminProductAnalyticsModel {
  final List<AdminTopSellingProductModel> topSellingProducts;
  final List<AdminStockProductModel> lowStockProducts;
  final List<AdminStockProductModel> outOfStockProducts;
  const AdminProductAnalyticsModel({required this.topSellingProducts, required this.lowStockProducts, required this.outOfStockProducts});
  factory AdminProductAnalyticsModel.fromJson(Map<String, dynamic> json) {
    final topJson = json['top_selling_products'];
    final lowJson = json['low_stock_products'];
    final outJson = json['out_of_stock_products'];
    return AdminProductAnalyticsModel(
      topSellingProducts: topJson is List ? topJson.map((item) => AdminTopSellingProductModel.fromJson(AdminJson.map(item))).toList() : [],
      lowStockProducts: lowJson is List ? lowJson.map((item) => AdminStockProductModel.fromJson(AdminJson.map(item))).toList() : [],
      outOfStockProducts: outJson is List ? outJson.map((item) => AdminStockProductModel.fromJson(AdminJson.map(item))).toList() : [],
    );
  }
}
