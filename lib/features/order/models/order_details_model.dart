class OrderAddressModel {
  final String name;
  final String phone;
  final String division;
  final String city;
  final String area;
  final String addressLine;
  final String postalCode;

  const OrderAddressModel({
    required this.name,
    required this.phone,
    required this.division,
    required this.city,
    required this.area,
    required this.addressLine,
    required this.postalCode,
  });

  factory OrderAddressModel.fromJson(Map<String, dynamic> json) {
    return OrderAddressModel(
      name: _Json.stringValue(json['name'] ?? json['full_name']),
      phone: _Json.stringValue(json['phone'] ?? json['phone_number']),
      division: _Json.stringValue(json['division'] ?? json['state']),
      city: _Json.stringValue(json['city']),
      area: _Json.stringValue(json['area'] ?? json['zone']),
      addressLine: _Json.stringValue(json['address_line'] ?? json['addressLine'] ?? json['address']),
      postalCode: _Json.stringValue(json['postal_code'] ?? json['postalCode'] ?? json['zip']),
    );
  }

  String get fullAddress {
    final parts = [addressLine, area, city, division, postalCode]
        .where((item) => item.trim().isNotEmpty)
        .toList();
    return parts.isEmpty ? 'No address available' : parts.join(', ');
  }
}

class OrderDetailsItemModel {
  final int id;
  final int productId;
  final int? variantId;
  final String name;
  final String thumbnail;
  final String? size;
  final String? color;
  final int quantity;
  final num price;
  final num subtotal;

  const OrderDetailsItemModel({
    required this.id,
    required this.productId,
    this.variantId,
    required this.name,
    required this.thumbnail,
    this.size,
    this.color,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory OrderDetailsItemModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsItemModel(
      id: _Json.intValue(json['id']),
      productId: _Json.intValue(json['product_id'] ?? json['productId']),
      variantId: json['variant_id'] == null ? null : _Json.intValue(json['variant_id']),
      name: _Json.stringValue(json['name'] ?? json['product_name']),
      thumbnail: _Json.stringValue(json['thumbnail'] ?? json['image'] ?? json['image_url']),
      size: _Json.nullableString(json['size']),
      color: _Json.nullableString(json['color']),
      quantity: _Json.intValue(json['quantity'], fallback: 1),
      price: _Json.numValue(json['price']),
      subtotal: _Json.numValue(json['subtotal'] ?? json['total']),
    );
  }
}

class OrderDetailsModel {
  final int id;
  final String orderNumber;
  final int userId;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final num subtotal;
  final num discount;
  final num shippingCharge;
  final num tax;
  final num total;
  final String currency;
  final String note;
  final OrderAddressModel address;
  final List<OrderDetailsItemModel> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderDetailsModel({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.subtotal,
    required this.discount,
    required this.shippingCharge,
    required this.tax,
    required this.total,
    required this.currency,
    required this.note,
    required this.address,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'];
    final addressJson = json['address'] ?? json['shipping_address'] ?? json['shippingAddress'];

    return OrderDetailsModel(
      id: _Json.intValue(json['id'] ?? json['order_id']),
      orderNumber: _Json.stringValue(json['order_number'] ?? json['orderNumber']),
      userId: _Json.intValue(json['user_id'] ?? json['userId']),
      status: _Json.stringValue(json['status'], fallback: 'pending'),
      paymentStatus: _Json.stringValue(json['payment_status'] ?? json['paymentStatus'], fallback: 'unpaid'),
      paymentMethod: _Json.stringValue(json['payment_method'] ?? json['paymentMethod'], fallback: 'cash'),
      subtotal: _Json.numValue(json['subtotal']),
      discount: _Json.numValue(json['discount']),
      shippingCharge: _Json.numValue(json['shipping_charge'] ?? json['shippingCharge']),
      tax: _Json.numValue(json['tax']),
      total: _Json.numValue(json['total'] ?? json['grand_total']),
      currency: _Json.stringValue(json['currency'], fallback: 'BDT'),
      note: _Json.stringValue(json['note']),
      address: OrderAddressModel.fromJson(addressJson is Map<String, dynamic> ? addressJson : <String, dynamic>{}),
      items: itemsJson is List
          ? itemsJson.whereType<Map<String, dynamic>>().map(OrderDetailsItemModel.fromJson).toList()
          : [],
      createdAt: _Json.dateValue(json['created_at'] ?? json['createdAt']),
      updatedAt: _Json.dateValue(json['updated_at'] ?? json['updatedAt']),
    );
  }

  OrderDetailsModel copyWith({String? status, String? paymentStatus}) {
    return OrderDetailsModel(
      id: id,
      orderNumber: orderNumber,
      userId: userId,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod,
      subtotal: subtotal,
      discount: discount,
      shippingCharge: shippingCharge,
      tax: tax,
      total: total,
      currency: currency,
      note: note,
      address: address,
      items: items,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class _Json {
  static int intValue(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static num numValue(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? 0;
    return 0;
  }

  static String stringValue(dynamic value, {String fallback = ''}) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? fallback : text;
  }

  static String? nullableString(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  static DateTime? dateValue(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
