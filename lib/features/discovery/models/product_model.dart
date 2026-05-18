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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? json['category']?['id'] ?? 0,
      brandId: json['brand_id'] ?? json['brand']?['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      sku: json['sku'] ?? '',
      shortDescription: json['short_description'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      discountPrice: json['discount_price'] ?? json['price'] ?? 0,
      discountPercentage: json['discount_percentage'] ?? 0,
      thumbnail:
          json['thumbnail'] ?? _primaryImageFromJson(json['images']) ?? '',
      rating: json['rating'] ?? 0,
      totalReviews: json['total_reviews'] ?? 0,
      stock: json['stock'] ?? 0,
      stockStatus: json['stock_status'] ?? '',
      isFeatured: json['is_featured'] ?? false,
      isWishlist: json['is_wishlist'] ?? false,
      soldCount: json['sold_count'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  static String? _primaryImageFromJson(dynamic images) {
    if (images is! List || images.isEmpty) return null;

    final primary = images.where((item) {
      return item is Map<String, dynamic> && item['is_primary'] == true;
    }).toList();

    if (primary.isNotEmpty) {
      return primary.first['image_url'];
    }

    final first = images.first;

    if (first is Map<String, dynamic>) {
      return first['image_url'];
    }

    return null;
  }
}
