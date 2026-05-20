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

  const CartItemModel({
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
    final price = _asNum(
      json['price'] ?? json['sale_price'] ?? json['salePrice'],
    );
    final quantity = _asInt(json['quantity'], fallback: 1);

    return CartItemModel(
      id: _asInt(json['id'] ?? json['cart_item_id'] ?? json['cartItemId']),
      productId: _asInt(json['product_id'] ?? json['productId']),
      variantId: _asNullableInt(json['variant_id'] ?? json['variantId']),
      name: _asString(
        json['name'] ?? json['product_name'] ?? json['productName'],
        fallback: 'Product',
      ),
      slug: _asString(json['slug']),
      thumbnail: _asString(
        json['thumbnail'] ??
            json['image'] ??
            json['image_url'] ??
            json['imageUrl'],
      ),
      size: _nullableText(json['size']),
      color: _nullableText(json['color']),
      variantName: _nullableText(json['variant_name'] ?? json['variantName']),
      price: price,
      regularPrice: _asNum(
        json['regular_price'] ?? json['regularPrice'],
        fallback: price,
      ),
      quantity: quantity,
      subtotal: _asNum(json['subtotal'], fallback: price * quantity),
      stockStatus: _asString(
        json['stock_status'] ?? json['stockStatus'],
        fallback: 'in_stock',
      ),
      availableStock: _asInt(
        json['available_stock'] ?? json['availableStock'],
        fallback: 99,
      ),
    );
  }

  bool get hasDiscount => regularPrice > price;

  bool get isOutOfStock {
    final normalized = stockStatus.toLowerCase().replaceAll(' ', '_');
    return availableStock <= 0 ||
        normalized == 'out_of_stock' ||
        normalized == 'outofstock';
  }

  num get effectiveSubtotal => subtotal > 0 ? subtotal : price * quantity;

  CartItemModel copyWith({
    int? quantity,
    num? subtotal,
    int? availableStock,
    String? stockStatus,
  }) {
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
      stockStatus: stockStatus ?? this.stockStatus,
      availableStock: availableStock ?? this.availableStock,
    );
  }

  static int _asInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static int? _asNullableInt(dynamic value) {
    if (value == null) return null;
    return _asInt(value);
  }

  static num _asNum(dynamic value, {num fallback = 0}) {
    if (value is num) return value;
    if (value is String)
      return num.tryParse(value.replaceAll(',', '')) ?? fallback;
    return fallback;
  }

  static String _asString(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  static String? _nullableText(dynamic value) {
    final text = _asString(value);
    return text.isEmpty ? null : text;
  }
}
