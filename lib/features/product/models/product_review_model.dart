class ProductReviewUserModel {
  final int id;
  final String displayName;
  final String? avatarUrl;

  const ProductReviewUserModel({required this.id, required this.displayName, this.avatarUrl});

  factory ProductReviewUserModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewUserModel(
      id: _asInt(json['id']),
      displayName: _asString(json['display_name'] ?? json['displayName'] ?? json['name'] ?? 'Customer'),
      avatarUrl: _nullableString(json['avatar_url'] ?? json['avatarUrl'] ?? json['avatar']),
    );
  }
}

class ProductReviewModel {
  final int id;
  final ProductReviewUserModel user;
  final num rating;
  final String comment;
  final List<String> images;
  final DateTime? createdAt;

  const ProductReviewModel({
    required this.id,
    required this.user,
    required this.rating,
    required this.comment,
    required this.images,
    this.createdAt,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    final imageList = _asList(json['images']);
    return ProductReviewModel(
      id: _asInt(json['id']),
      user: ProductReviewUserModel.fromJson(_asMap(json['user'] ?? json['customer'])),
      rating: _asNum(json['rating'] ?? json['stars']),
      comment: _asString(json['comment'] ?? json['review'] ?? json['message']),
      images: imageList.map((item) => item.toString()).where((url) => url.isNotEmpty).toList(),
      createdAt: DateTime.tryParse(_asString(json['created_at'] ?? json['createdAt'])),
    );
  }
}

class ProductReviewSummaryModel {
  final num averageRating;
  final int totalReviews;
  final Map<String, dynamic> ratingCount;

  const ProductReviewSummaryModel({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingCount,
  });

  factory ProductReviewSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewSummaryModel(
      averageRating: _asNum(json['average_rating'] ?? json['averageRating'] ?? json['rating']),
      totalReviews: _asInt(json['total_reviews'] ?? json['totalReviews'] ?? json['count']),
      ratingCount: _asMap(json['rating_count'] ?? json['ratingCount'] ?? json['breakdown']),
    );
  }
}

class ProductReviewsResponseModel {
  final ProductReviewSummaryModel summary;
  final List<ProductReviewModel> reviews;

  const ProductReviewsResponseModel({required this.summary, required this.reviews});

  factory ProductReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawReviews = _asList(json['items'] ?? json['reviews'] ?? json['data']);
    return ProductReviewsResponseModel(
      summary: ProductReviewSummaryModel.fromJson(_asMap(json['summary'] ?? json['review_summary'])),
      reviews: rawReviews.map((item) => ProductReviewModel.fromJson(_asMap(item))).toList(),
    );
  }
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
String _asString(dynamic value, [String fallback = '']) => value?.toString() ?? fallback;
String? _nullableString(dynamic value) => value?.toString();
Map<String, dynamic> _asMap(dynamic value) => value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
List<dynamic> _asList(dynamic value) => value is List ? value : <dynamic>[];
