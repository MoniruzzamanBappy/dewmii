class CartItemModel {
  final int id;
  final int productId;
  final int? variantId;
  final String name;
  final String slug;
  final String thumbnail;
  final String? size;
  final String? color;
  final String? variantName;
  final num price;
  final num regularPrice;
  final int quantity;
  final num subtotal;
  final String stockStatus;
  final int availableStock;

  CartItemModel({
    required this.id,
    required this.productId,
    this.variantId,
    required this.name,
    required this.slug,
    required this.thumbnail,
    this.size,
    this.color,
    this.variantName,
    required this.price,
    required this.regularPrice,
    required this.quantity,
    required this.subtotal,
    required this.stockStatus,
    required this.availableStock,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      variantId: json['variant_id'],
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      size: json['size'],
      color: json['color'],
      variantName: json['variant_name'],
      price: json['price'] ?? 0,
      regularPrice: json['regular_price'] ?? json['price'] ?? 0,
      quantity: json['quantity'] ?? 0,
      subtotal: json['subtotal'] ?? 0,
      stockStatus: json['stock_status'] ?? '',
      availableStock: json['available_stock'] ?? 0,
    );
  }

  CartItemModel copyWith({int? quantity, num? subtotal}) {
    return CartItemModel(
      id: id,
      productId: productId,
      variantId: variantId,
      name: name,
      slug: slug,
      thumbnail: thumbnail,
      size: size,
      color: color,
      variantName: variantName,
      price: price,
      regularPrice: regularPrice,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
      stockStatus: stockStatus,
      availableStock: availableStock,
    );
  }
}
