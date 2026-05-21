class ProductStockModel {
  final int productId;
  final String productName;
  final int? variantId;
  final String? variantName;
  final int requestedQuantity;
  final int availableStock;
  final String stockStatus;
  final bool isAvailable;
  final int maxOrderQuantity;

  const ProductStockModel({
    required this.productId,
    required this.productName,
    this.variantId,
    this.variantName,
    required this.requestedQuantity,
    required this.availableStock,
    required this.stockStatus,
    required this.isAvailable,
    required this.maxOrderQuantity,
  });

  factory ProductStockModel.fromJson(Map<String, dynamic> json) {
    final available = _asInt(json['available_stock'] ?? json['availableStock'] ?? json['stock']);
    return ProductStockModel(
      productId: _asInt(json['product_id'] ?? json['productId']),
      productName: _asString(json['product_name'] ?? json['productName'] ?? json['name']),
      variantId: _nullableInt(json['variant_id'] ?? json['variantId']),
      variantName: _nullableString(json['variant_name'] ?? json['variantName']),
      requestedQuantity: _asInt(json['requested_quantity'] ?? json['requestedQuantity'], 1),
      availableStock: available,
      stockStatus: _asString(json['stock_status'] ?? json['stockStatus'], available > 0 ? 'In stock' : 'Out of stock'),
      isAvailable: _asBool(json['is_available'] ?? json['isAvailable'], available > 0),
      maxOrderQuantity: _asInt(json['max_order_quantity'] ?? json['maxOrderQuantity'], available > 0 ? available : 1),
    );
  }
}

int _asInt(dynamic value, [int fallback = 0]) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? double.tryParse(value)?.toInt() ?? fallback;
  return fallback;
}

int? _nullableInt(dynamic value) => value == null ? null : _asInt(value);
bool _asBool(dynamic value, [bool fallback = false]) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) return ['true', '1', 'yes'].contains(value.toLowerCase());
  return fallback;
}
String _asString(dynamic value, [String fallback = '']) => value?.toString() ?? fallback;
String? _nullableString(dynamic value) => value?.toString();
