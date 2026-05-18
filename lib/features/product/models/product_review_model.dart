class ProductReviewUserModel {
  final int id;
  final String displayName;
  final String? avatarUrl;

  ProductReviewUserModel({
    required this.id,
    required this.displayName,
    this.avatarUrl,
  });

  factory ProductReviewUserModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewUserModel(
      id: json['id'] ?? 0,
      displayName: json['display_name'] ?? '',
      avatarUrl: json['avatar_url'],
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

  ProductReviewModel({
    required this.id,
    required this.user,
    required this.rating,
    required this.comment,
    required this.images,
    this.createdAt,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    final imageList = json['images'];

    return ProductReviewModel(
      id: json['id'] ?? 0,
      user: ProductReviewUserModel.fromJson(
        json['user'] ?? <String, dynamic>{},
      ),
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      images: imageList is List
          ? imageList.map((item) => item.toString()).toList()
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}

class ProductReviewSummaryModel {
  final num averageRating;
  final int totalReviews;
  final Map<String, dynamic> ratingCount;

  ProductReviewSummaryModel({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingCount,
  });

  factory ProductReviewSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewSummaryModel(
      averageRating: json['average_rating'] ?? 0,
      totalReviews: json['total_reviews'] ?? 0,
      ratingCount: json['rating_count'] ?? <String, dynamic>{},
    );
  }
}

class ProductReviewsResponseModel {
  final ProductReviewSummaryModel summary;
  final List<ProductReviewModel> reviews;

  ProductReviewsResponseModel({required this.summary, required this.reviews});

  factory ProductReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    final items = json['items'];

    return ProductReviewsResponseModel(
      summary: ProductReviewSummaryModel.fromJson(
        json['summary'] ?? <String, dynamic>{},
      ),
      reviews: items is List
          ? items
                .map(
                  (item) =>
                      ProductReviewModel.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }
}
