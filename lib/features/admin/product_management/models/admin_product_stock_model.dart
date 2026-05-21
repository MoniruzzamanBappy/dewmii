class AdminVariantStockModel {
  final int variantId;
  final int stock;

  const AdminVariantStockModel({required this.variantId, required this.stock});

  factory AdminVariantStockModel.fromJson(Map<String, dynamic> json) {
    return AdminVariantStockModel(
      variantId: _toInt(json['variant_id'] ?? json['variantId'] ?? json['id']),
      stock: _toInt(json['stock']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class AdminProductStockModel {
  final int productId;
  final int stock;
  final String stockStatus;
  final List<AdminVariantStockModel> variantStocks;
  final DateTime? updatedAt;

  const AdminProductStockModel({
    required this.productId,
    required this.stock,
    required this.stockStatus,
    required this.variantStocks,
    this.updatedAt,
  });

  factory AdminProductStockModel.fromJson(Map<String, dynamic> json) {
    final variantJson = json['variant_stocks'] ?? json['variantStocks'];

    return AdminProductStockModel(
      productId: _toInt(json['product_id'] ?? json['productId'] ?? json['id']),
      stock: _toInt(json['stock']),
      stockStatus: (json['stock_status'] ?? json['stockStatus'] ?? '').toString(),
      variantStocks: variantJson is List
          ? variantJson
              .whereType<Map>()
              .map((item) => AdminVariantStockModel.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
      updatedAt: DateTime.tryParse((json['updated_at'] ?? json['updatedAt'] ?? '').toString()),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
