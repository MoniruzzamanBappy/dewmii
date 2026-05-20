class ProductModel {
  final int id;
  final int categoryId;
  final int brandId;
  final String name;
  final String slug;
  final String sku;
  final String shortDescription;
  final String description;
  final num price;
  final num discountPrice;
  final num discountPercentage;
  final String thumbnail;
  final num rating;
  final int totalReviews;
  final int stock;
  final String stockStatus;
  final bool isFeatured;
  final bool isWishlist;
  final int soldCount;
  final DateTime? createdAt;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.brandId,
    required this.name,
    required this.slug,
    required this.sku,
    required this.shortDescription,
    required this.description,
    required this.price,
    required this.discountPrice,
    required this.discountPercentage,
    required this.thumbnail,
    required this.rating,
    required this.totalReviews,
    required this.stock,
    required this.stockStatus,
    required this.isFeatured,
    required this.isWishlist,
    required this.soldCount,
    this.createdAt,
  });

  bool get hasDiscount => discountPrice < price;

  bool get isInStock =>
      stock > 0 || stockStatus.toLowerCase().contains('stock');

  String get displayPrice => '৳${_formatMoney(discountPrice)}';

  String get displayOldPrice => '৳${_formatMoney(price)}';

  String get displayRating => rating.toStringAsFixed(rating % 1 == 0 ? 0 : 1);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final price = _toNum(json['price']);
    final discountPrice = _toNum(json['discount_price'], fallback: price);

    return ProductModel(
      id: _toInt(json['id']),
      categoryId: _toInt(
        json['category_id'] ?? _nested(json['category'], 'id'),
      ),
      brandId: _toInt(json['brand_id'] ?? _nested(json['brand'], 'id')),
      name: _toString(json['name']),
      slug: _toString(json['slug']),
      sku: _toString(json['sku']),
      shortDescription: _toString(json['short_description']),
      description: _toString(json['description']),
      price: price,
      discountPrice: discountPrice,
      discountPercentage: _toNum(json['discount_percentage']),
      thumbnail: _toString(
        json['thumbnail'] ?? _primaryImageFromJson(json['images']),
      ),
      rating: _toNum(json['rating']),
      totalReviews: _toInt(json['total_reviews']),
      stock: _toInt(json['stock']),
      stockStatus: _toString(json['stock_status']),
      isFeatured: _toBool(json['is_featured']),
      isWishlist: _toBool(json['is_wishlist']),
      soldCount: _toInt(json['sold_count']),
      createdAt: DateTime.tryParse(_toString(json['created_at'])),
    );
  }

  static dynamic _nested(dynamic value, String key) {
    if (value is Map<String, dynamic>) return value[key];
    return null;
  }

  static String? _primaryImageFromJson(dynamic images) {
    if (images is! List || images.isEmpty) return null;

    final primary = images.where((item) {
      return item is Map<String, dynamic> && item['is_primary'] == true;
    }).toList();

    final item = primary.isNotEmpty ? primary.first : images.first;
    if (item is Map<String, dynamic>) return _toString(item['image_url']);
    return null;
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static num _toNum(dynamic value, {num fallback = 0}) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    final text = value?.toString().toLowerCase();
    return text == 'true' || text == '1' || text == 'yes';
  }

  static String _toString(dynamic value) => value?.toString() ?? '';

  static String _formatMoney(num value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }
}
