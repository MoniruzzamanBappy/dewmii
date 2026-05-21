class AdminProductImageModel {
  final int id;
  final int productId;
  final String imageUrl;
  final bool isPrimary;
  final int sortOrder;

  const AdminProductImageModel({
    required this.id,
    required this.productId,
    required this.imageUrl,
    required this.isPrimary,
    required this.sortOrder,
  });

  factory AdminProductImageModel.fromJson(Map<String, dynamic> json) {
    return AdminProductImageModel(
      id: _toInt(json['id']),
      productId: _toInt(json['product_id'] ?? json['productId']),
      imageUrl: (json['image_url'] ?? json['imageUrl'] ?? json['url'] ?? '').toString(),
      isPrimary: _toBool(json['is_primary'] ?? json['isPrimary']),
      sortOrder: _toInt(json['sort_order'] ?? json['sortOrder']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'image_url': imageUrl,
        'is_primary': isPrimary,
        'sort_order': sortOrder,
      };

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    final text = value?.toString().toLowerCase();
    return text == 'true' || text == '1' || text == 'yes';
  }
}
