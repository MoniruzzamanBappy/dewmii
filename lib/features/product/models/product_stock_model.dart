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

  ProductStockModel({
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
    return ProductStockModel(
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      variantId: json['variant_id'],
      variantName: json['variant_name'],
      requestedQuantity: json['requested_quantity'] ?? 0,
      availableStock: json['available_stock'] ?? 0,
      stockStatus: json['stock_status'] ?? '',
      isAvailable: json['is_available'] ?? false,
      maxOrderQuantity: json['max_order_quantity'] ?? 1,
    );
  }
}
