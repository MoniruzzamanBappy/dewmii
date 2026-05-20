class ProductImageModel {
  final int id;
  final int productId;
  final String imageUrl;
  final bool isPrimary;
  final int sortOrder;

  const ProductImageModel({
    required this.id,
    required this.productId,
    required this.imageUrl,
    required this.isPrimary,
    required this.sortOrder,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: _asInt(json['id']),
      productId: _asInt(json['product_id'] ?? json['productId']),
      imageUrl: _asString(json['image_url'] ?? json['imageUrl'] ?? json['url'] ?? json['src']),
      isPrimary: _asBool(json['is_primary'] ?? json['isPrimary']),
      sortOrder: _asInt(json['sort_order'] ?? json['sortOrder']),
    );
  }
}

int _asInt(dynamic value, [int fallback = 0]) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

bool _asBool(dynamic value, [bool fallback = false]) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) return ['true', '1', 'yes'].contains(value.toLowerCase());
  return fallback;
}

String _asString(dynamic value, [String fallback = '']) => value?.toString() ?? fallback;
