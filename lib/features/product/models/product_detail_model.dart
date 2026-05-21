class ProductCategoryInfo {
  final int id;
  final String name;
  final String slug;

  const ProductCategoryInfo({required this.id, required this.name, required this.slug});

  factory ProductCategoryInfo.fromJson(Map<String, dynamic> json) {
    return ProductCategoryInfo(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      slug: _asString(json['slug']),
    );
  }
}

class ProductBrandInfo {
  final int id;
  final String name;
  final String logoUrl;

  const ProductBrandInfo({required this.id, required this.name, required this.logoUrl});

  factory ProductBrandInfo.fromJson(Map<String, dynamic> json) {
    return ProductBrandInfo(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      logoUrl: _asString(json['logo_url'] ?? json['logoUrl'] ?? json['logo']),
    );
  }
}

class ProductDetailImage {
  final int id;
  final String imageUrl;
  final bool isPrimary;

  const ProductDetailImage({required this.id, required this.imageUrl, required this.isPrimary});

  factory ProductDetailImage.fromJson(Map<String, dynamic> json) {
    return ProductDetailImage(
      id: _asInt(json['id']),
      imageUrl: _asString(json['image_url'] ?? json['imageUrl'] ?? json['url'] ?? json['src']),
      isPrimary: _asBool(json['is_primary'] ?? json['isPrimary']),
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

  const ProductVariantModel({
    required this.id,
    required this.type,
    required this.name,
    this.colorCode,
    required this.price,
    required this.stock,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: _asInt(json['id']),
      type: _asString(json['type'] ?? json['variant_type']),
      name: _asString(json['name'] ?? json['value']),
      colorCode: _nullableString(json['color_code'] ?? json['colorCode']),
      price: _asNum(json['price']),
      stock: _asInt(json['stock']),
    );
  }
}

class ProductSpecificationModel {
  final String name;
  final String value;

  const ProductSpecificationModel({required this.name, required this.value});

  factory ProductSpecificationModel.fromJson(Map<String, dynamic> json) {
    return ProductSpecificationModel(
      name: _asString(json['name'] ?? json['key'] ?? json['title']),
      value: _asString(json['value'] ?? json['description']),
    );
  }
}

class ProductReviewSummary {
  final num averageRating;
  final int totalReviews;
  final Map<String, dynamic> ratingCount;

  const ProductReviewSummary({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingCount,
  });

  factory ProductReviewSummary.fromJson(Map<String, dynamic> json) {
    return ProductReviewSummary(
      averageRating: _asNum(json['average_rating'] ?? json['averageRating'] ?? json['rating']),
      totalReviews: _asInt(json['total_reviews'] ?? json['totalReviews'] ?? json['count']),
      ratingCount: _asMap(json['rating_count'] ?? json['ratingCount'] ?? json['breakdown']),
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

  const ProductDetailModel({
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
    final imageItems = _asList(json['images']);
    final variantItems = _asList(json['variants']);
    final specificationItems = _asList(json['specifications'] ?? json['specs']);
    final rawPrice = _asNum(json['price']);

    return ProductDetailModel(
      id: _asInt(json['id']),
      category: ProductCategoryInfo.fromJson(_asMap(json['category'])),
      brand: ProductBrandInfo.fromJson(_asMap(json['brand'])),
      name: _asString(json['name'] ?? json['title']),
      slug: _asString(json['slug']),
      sku: _asString(json['sku']),
      shortDescription: _asString(json['short_description'] ?? json['shortDescription'] ?? json['subtitle']),
      description: _asString(json['description'] ?? json['details']),
      price: rawPrice,
      discountPrice: _asNum(json['discount_price'] ?? json['discountPrice'] ?? json['sale_price'] ?? rawPrice),
      discountPercentage: _asNum(json['discount_percentage'] ?? json['discountPercentage']),
      stock: _asInt(json['stock'] ?? json['available_stock']),
      stockStatus: _asString(json['stock_status'] ?? json['stockStatus']),
      rating: _asNum(json['rating'] ?? json['average_rating']),
      totalReviews: _asInt(json['total_reviews'] ?? json['reviews_count']),
      isFeatured: _asBool(json['is_featured'] ?? json['isFeatured']),
      isWishlist: _asBool(json['is_wishlist'] ?? json['isWishlist']),
      images: imageItems.map((item) => ProductDetailImage.fromJson(_asMap(item))).toList(),
      variants: variantItems.map((item) => ProductVariantModel.fromJson(_asMap(item))).toList(),
      specifications: specificationItems.map((item) => ProductSpecificationModel.fromJson(_asMap(item))).toList(),
      reviewSummary: ProductReviewSummary.fromJson(_asMap(json['review_summary'] ?? json['reviewSummary'])),
    );
  }

  List<String> get imageUrls {
    final urls = images.map((image) => image.imageUrl).where((url) => url.trim().isNotEmpty).toList();
    return urls.isEmpty ? [primaryImage] : urls;
  }

  String get primaryImage {
    if (images.isEmpty) return '';
    final primary = images.where((image) => image.isPrimary && image.imageUrl.isNotEmpty).toList();
    if (primary.isNotEmpty) return primary.first.imageUrl;
    return images.first.imageUrl;
  }

  bool get hasDiscount => discountPrice > 0 && discountPrice < price;
  num get displayPrice => hasDiscount ? discountPrice : price;
  bool get inStock => stock > 0 || stockStatus.toLowerCase().contains('stock');
}

int _asInt(dynamic value, [int fallback = 0]) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? double.tryParse(value)?.toInt() ?? fallback;
  return fallback;
}

num _asNum(dynamic value, [num fallback = 0]) {
  if (value is num) return value;
  if (value is String) return num.tryParse(value) ?? fallback;
  return fallback;
}

bool _asBool(dynamic value, [bool fallback = false]) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) return ['true', '1', 'yes', 'y'].contains(value.toLowerCase());
  return fallback;
}

String _asString(dynamic value, [String fallback = '']) => value?.toString() ?? fallback;
String? _nullableString(dynamic value) => value?.toString();
Map<String, dynamic> _asMap(dynamic value) => value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
List<dynamic> _asList(dynamic value) => value is List ? value : <dynamic>[];
