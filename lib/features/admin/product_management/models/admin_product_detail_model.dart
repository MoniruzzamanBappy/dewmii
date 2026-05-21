import 'admin_product_image_model.dart';

class AdminProductVariantModel {
  final int id;
  final String type;
  final String name;
  final num price;
  final int stock;

  const AdminProductVariantModel({
    required this.id,
    required this.type,
    required this.name,
    required this.price,
    required this.stock,
  });

  factory AdminProductVariantModel.fromJson(Map<String, dynamic> json) {
    return AdminProductVariantModel(
      id: _toInt(json['id']),
      type: (json['type'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      price: _toNum(json['price']),
      stock: _toInt(json['stock']),
    );
  }
}

class AdminProductSpecificationModel {
  final String name;
  final String value;

  const AdminProductSpecificationModel({required this.name, required this.value});

  factory AdminProductSpecificationModel.fromJson(Map<String, dynamic> json) {
    return AdminProductSpecificationModel(
      name: (json['name'] ?? json['key'] ?? '').toString(),
      value: (json['value'] ?? '').toString(),
    );
  }
}

class AdminProductDetailModel {
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
  final int stock;
  final String stockStatus;
  final String status;
  final bool isFeatured;
  final List<AdminProductImageModel> images;
  final List<AdminProductVariantModel> variants;
  final List<AdminProductSpecificationModel> specifications;

  const AdminProductDetailModel({
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
    required this.stock,
    required this.stockStatus,
    required this.status,
    required this.isFeatured,
    required this.images,
    required this.variants,
    required this.specifications,
  });

  factory AdminProductDetailModel.fromJson(Map<String, dynamic> json) {
    final imagesJson = json['images'];
    final variantsJson = json['variants'];
    final specsJson = json['specifications'] ?? json['specs'];

    return AdminProductDetailModel(
      id: _toInt(json['id']),
      categoryId: _toInt(json['category_id'] ?? json['categoryId']),
      brandId: _toInt(json['brand_id'] ?? json['brandId']),
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      sku: (json['sku'] ?? '').toString(),
      shortDescription: (json['short_description'] ?? json['shortDescription'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: _toNum(json['price']),
      discountPrice: _toNum(json['discount_price'] ?? json['discountPrice']),
      stock: _toInt(json['stock']),
      stockStatus: (json['stock_status'] ?? json['stockStatus'] ?? '').toString(),
      status: (json['status'] ?? 'active').toString(),
      isFeatured: _toBool(json['is_featured'] ?? json['isFeatured']),
      images: imagesJson is List
          ? imagesJson
              .whereType<Map>()
              .map((item) => AdminProductImageModel.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
      variants: variantsJson is List
          ? variantsJson
              .whereType<Map>()
              .map((item) => AdminProductVariantModel.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
      specifications: specsJson is List
          ? specsJson
              .whereType<Map>()
              .map((item) => AdminProductSpecificationModel.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
    );
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

num _toNum(dynamic value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
}

bool _toBool(dynamic value) {
  if (value is bool) return value;
  final text = value?.toString().toLowerCase();
  return text == 'true' || text == '1' || text == 'yes';
}
