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

  WishlistItemModel({
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
    final product = json['product'];

    if (product is Map<String, dynamic>) {
      return WishlistItemModel(
        id: json['id'] ?? 0,
        productId: json['product_id'] ?? product['id'] ?? 0,
        name: product['name'] ?? '',
        slug: product['slug'] ?? '',
        price: product['price'] ?? 0,
        discountPrice: product['discount_price'] ?? product['price'] ?? 0,
        discountPercentage: product['discount_percentage'] ?? 0,
        thumbnail: product['thumbnail'] ?? '',
        rating: product['rating'] ?? 0,
        totalReviews: product['total_reviews'] ?? 0,
        stockStatus: product['stock_status'] ?? '',
        availableStock: product['available_stock'] ?? 0,
        addedAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'])
            : null,
      );
    }

    return WishlistItemModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      price: json['price'] ?? 0,
      discountPrice: json['discount_price'] ?? json['price'] ?? 0,
      discountPercentage: json['discount_percentage'] ?? 0,
      thumbnail: json['thumbnail'] ?? '',
      rating: json['rating'] ?? 0,
      totalReviews: json['total_reviews'] ?? 0,
      stockStatus: json['stock_status'] ?? '',
      availableStock: json['available_stock'] ?? 0,
      addedAt: json['added_at'] != null
          ? DateTime.tryParse(json['added_at'])
          : null,
    );
  }
}
