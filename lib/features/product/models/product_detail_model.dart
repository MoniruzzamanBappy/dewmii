class ProductCategoryInfo {
  final int id;
  final String name;
  final String slug;

  ProductCategoryInfo({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory ProductCategoryInfo.fromJson(Map<String, dynamic> json) {
    return ProductCategoryInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}

class ProductBrandInfo {
  final int id;
  final String name;
  final String logoUrl;

  ProductBrandInfo({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  factory ProductBrandInfo.fromJson(Map<String, dynamic> json) {
    return ProductBrandInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logoUrl: json['logo_url'] ?? '',
    );
  }
}

class ProductDetailImage {
  final int id;
  final String imageUrl;
  final bool isPrimary;

  ProductDetailImage({
    required this.id,
    required this.imageUrl,
    required this.isPrimary,
  });

  factory ProductDetailImage.fromJson(Map<String, dynamic> json) {
    return ProductDetailImage(
      id: json['id'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      isPrimary: json['is_primary'] ?? false,
    );
  }
}

class ProductVariantModel {
  final int id;
  final String type;
  final String name;
  final String? colorCode;
  final num price;
  final int stock;

  ProductVariantModel({
    required this.id,
    required this.type,
    required this.name,
    this.colorCode,
    required this.price,
    required this.stock,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      colorCode: json['color_code'],
      price: json['price'] ?? 0,
      stock: json['stock'] ?? 0,
    );
  }
}

class ProductSpecificationModel {
  final String name;
  final String value;

  ProductSpecificationModel({required this.name, required this.value});

  factory ProductSpecificationModel.fromJson(Map<String, dynamic> json) {
    return ProductSpecificationModel(
      name: json['name'] ?? '',
      value: json['value'] ?? '',
    );
  }
}

class ProductReviewSummary {
  final num averageRating;
  final int totalReviews;
  final Map<String, dynamic> ratingCount;

  ProductReviewSummary({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingCount,
  });

  factory ProductReviewSummary.fromJson(Map<String, dynamic> json) {
    return ProductReviewSummary(
      averageRating: json['average_rating'] ?? 0,
      totalReviews: json['total_reviews'] ?? 0,
      ratingCount: json['rating_count'] ?? <String, dynamic>{},
    );
  }
}

class ProductDetailModel {
  final int id;
  final ProductCategoryInfo category;
  final ProductBrandInfo brand;
  final String name;
  final String slug;
  final String sku;
  final String shortDescription;
  final String description;
  final num price;
  final num discountPrice;
  final num discountPercentage;
  final int stock;
  final String stockStatus;
  final num rating;
  final int totalReviews;
  final bool isFeatured;
  final bool isWishlist;
  final List<ProductDetailImage> images;
  final List<ProductVariantModel> variants;
  final List<ProductSpecificationModel> specifications;
  final ProductReviewSummary reviewSummary;

  ProductDetailModel({
    required this.id,
    required this.category,
    required this.brand,
    required this.name,
    required this.slug,
    required this.sku,
    required this.shortDescription,
    required this.description,
    required this.price,
    required this.discountPrice,
    required this.discountPercentage,
    required this.stock,
    required this.stockStatus,
    required this.rating,
    required this.totalReviews,
    required this.isFeatured,
    required this.isWishlist,
    required this.images,
    required this.variants,
    required this.specifications,
    required this.reviewSummary,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    final imagesJson = json['images'];
    final variantsJson = json['variants'];
    final specificationsJson = json['specifications'];

    return ProductDetailModel(
      id: json['id'] ?? 0,
      category: ProductCategoryInfo.fromJson(
        json['category'] ?? <String, dynamic>{},
      ),
      brand: ProductBrandInfo.fromJson(json['brand'] ?? <String, dynamic>{}),
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      sku: json['sku'] ?? '',
      shortDescription: json['short_description'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      discountPrice: json['discount_price'] ?? json['price'] ?? 0,
      discountPercentage: json['discount_percentage'] ?? 0,
      stock: json['stock'] ?? 0,
      stockStatus: json['stock_status'] ?? '',
      rating: json['rating'] ?? 0,
      totalReviews: json['total_reviews'] ?? 0,
      isFeatured: json['is_featured'] ?? false,
      isWishlist: json['is_wishlist'] ?? false,
      images: imagesJson is List
          ? imagesJson
                .map(
                  (item) =>
                      ProductDetailImage.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : [],
      variants: variantsJson is List
          ? variantsJson
                .map(
                  (item) => ProductVariantModel.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList()
          : [],
      specifications: specificationsJson is List
          ? specificationsJson
                .map(
                  (item) => ProductSpecificationModel.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList()
          : [],
      reviewSummary: ProductReviewSummary.fromJson(
        json['review_summary'] ?? <String, dynamic>{},
      ),
    );
  }

  String get primaryImage {
    if (images.isEmpty) return '';

    final primaryImages = images.where((image) => image.isPrimary).toList();

    if (primaryImages.isNotEmpty) {
      return primaryImages.first.imageUrl;
    }

    return images.first.imageUrl;
  }
}
