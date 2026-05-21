class AdminProductModel {
  final int id;
  final String name;
  final String slug;
  final String sku;
  final int categoryId;
  final String categoryName;
  final int brandId;
  final String brandName;
  final num price;
  final num discountPrice;
  final int stock;
  final String stockStatus;
  final String status;
  final bool isFeatured;
  final String thumbnail;
  final DateTime? createdAt;

  const AdminProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.sku,
    required this.categoryId,
    required this.categoryName,
    required this.brandId,
    required this.brandName,
    required this.price,
    required this.discountPrice,
    required this.stock,
    required this.stockStatus,
    required this.status,
    required this.isFeatured,
    required this.thumbnail,
    this.createdAt,
  });

  factory AdminProductModel.fromJson(Map<String, dynamic> json) {
    return AdminProductModel(
      id: _toInt(json['id']),
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      sku: (json['sku'] ?? '').toString(),
      categoryId: _toInt(json['category_id'] ?? json['categoryId']),
      categoryName: (json['category_name'] ?? json['categoryName'] ?? json['category']?['name'] ?? '').toString(),
      brandId: _toInt(json['brand_id'] ?? json['brandId']),
      brandName: (json['brand_name'] ?? json['brandName'] ?? json['brand']?['name'] ?? '').toString(),
      price: _toNum(json['price']),
      discountPrice: _toNum(json['discount_price'] ?? json['discountPrice'] ?? json['sale_price']),
      stock: _toInt(json['stock']),
      stockStatus: (json['stock_status'] ?? json['stockStatus'] ?? '').toString(),
      status: (json['status'] ?? 'active').toString(),
      isFeatured: _toBool(json['is_featured'] ?? json['isFeatured']),
      thumbnail: (json['thumbnail'] ?? json['thumbnail_url'] ?? json['image'] ?? json['image_url'] ?? '').toString(),
      createdAt: _toDate(json['created_at'] ?? json['createdAt']),
    );
  }

  AdminProductModel copyWith({
    int? id,
    String? name,
    String? slug,
    String? sku,
    int? categoryId,
    String? categoryName,
    int? brandId,
    String? brandName,
    num? price,
    num? discountPrice,
    int? stock,
    String? stockStatus,
    String? status,
    bool? isFeatured,
    String? thumbnail,
    DateTime? createdAt,
  }) {
    return AdminProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      sku: sku ?? this.sku,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      stock: stock ?? this.stock,
      stockStatus: stockStatus ?? this.stockStatus,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      thumbnail: thumbnail ?? this.thumbnail,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  num get sellingPrice => discountPrice > 0 ? discountPrice : price;
  bool get isActive => status.toLowerCase() == 'active';

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static num _toNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    final text = value?.toString().toLowerCase();
    return text == 'true' || text == '1' || text == 'yes';
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
