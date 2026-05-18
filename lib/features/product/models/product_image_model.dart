class ProductImageModel {
  final int id;
  final int productId;
  final String imageUrl;
  final bool isPrimary;
  final int sortOrder;

  ProductImageModel({
    required this.id,
    required this.productId,
    required this.imageUrl,
    required this.isPrimary,
    required this.sortOrder,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      isPrimary: json['is_primary'] ?? false,
      sortOrder: json['sort_order'] ?? 0,
    );
  }
}
