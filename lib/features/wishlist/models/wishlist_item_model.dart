class WishlistItemModel {
  final int id;
  final int productId;
  final String name;
  final String slug;
  final num price;
  final num discountPrice;
  final num discountPercentage;
  final String thumbnail;
  final num rating;
  final int totalReviews;
  final String stockStatus;
  final int availableStock;
  final DateTime? addedAt;

  const WishlistItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.slug,
    required this.price,
    required this.discountPrice,
    required this.discountPercentage,
    required this.thumbnail,
    required this.rating,
    required this.totalReviews,
    required this.stockStatus,
    required this.availableStock,
    this.addedAt,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    final product = _asMap(json['product']);
    final source = product ?? json;

    return WishlistItemModel(
      id: _toInt(json['id']),
      productId: _toInt(json['product_id'] ?? source['id']),
      name: _toString(source['name']),
      slug: _toString(source['slug']),
      price: _toNum(source['price']),
      discountPrice: _toNum(
        source['discount_price'] ??
            source['sale_price'] ??
            source['final_price'] ??
            source['price'],
      ),
      discountPercentage: _toNum(
        source['discount_percentage'] ?? source['discount_percent'],
      ),
      thumbnail: _toString(
        source['thumbnail'] ??
            source['image'] ??
            source['image_url'] ??
            source['featured_image'],
      ),
      rating: _toNum(source['rating'] ?? source['average_rating']),
      totalReviews: _toInt(source['total_reviews'] ?? source['reviews_count']),
      stockStatus: _normalizeStockStatus(
        source['stock_status'] ?? source['availability'] ?? source['status'],
      ),
      availableStock: _toInt(source['available_stock'] ?? source['stock']),
      addedAt: _toDate(json['created_at'] ?? json['added_at']),
    );
  }

  bool get hasDiscount => discountPrice > 0 && discountPrice < price;
  bool get isInStock {
    final normalized = stockStatus.toLowerCase().replaceAll(' ', '_');
    return normalized == 'in_stock' ||
        normalized == 'available' ||
        availableStock > 0;
  }

  String get stockLabel {
    if (stockStatus.trim().isEmpty) return isInStock ? 'In stock' : 'Limited';
    return stockStatus
        .replaceAll('_', ' ')
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'slug': slug,
      'price': price,
      'discount_price': discountPrice,
      'discount_percentage': discountPercentage,
      'thumbnail': thumbnail,
      'rating': rating,
      'total_reviews': totalReviews,
      'stock_status': stockStatus,
      'available_stock': availableStock,
      'added_at': addedAt?.toIso8601String(),
    };
  }

  WishlistItemModel copyWith({
    int? id,
    int? productId,
    String? name,
    String? slug,
    num? price,
    num? discountPrice,
    num? discountPercentage,
    String? thumbnail,
    num? rating,
    int? totalReviews,
    String? stockStatus,
    int? availableStock,
    DateTime? addedAt,
  }) {
    return WishlistItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      thumbnail: thumbnail ?? this.thumbnail,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      stockStatus: stockStatus ?? this.stockStatus,
      availableStock: availableStock ?? this.availableStock,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static String _toString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static num _toNum(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    return num.tryParse(value.toString()) ?? 0;
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static String _normalizeStockStatus(dynamic value) {
    final status = _toString(value).trim();
    if (status.isEmpty) return 'in_stock';
    return status.toLowerCase().replaceAll(' ', '_');
  }
}
