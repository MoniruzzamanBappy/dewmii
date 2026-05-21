class AdminOrderCustomerModel {
  final int id;
  final String name;
  final String email;
  final String phone;

  const AdminOrderCustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory AdminOrderCustomerModel.fromJson(Map<String, dynamic> json) {
    return AdminOrderCustomerModel(
      id: _Parser.intValue(json['id']),
      name: _Parser.stringValue(json['name']),
      email: _Parser.stringValue(json['email']),
      phone: _Parser.stringValue(json['phone']),
    );
  }
}

class AdminOrderListItemModel {
  final int id;
  final String orderNumber;
  final AdminOrderCustomerModel customer;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final num total;
  final int itemsCount;
  final DateTime? createdAt;

  const AdminOrderListItemModel({
    required this.id,
    required this.orderNumber,
    required this.customer,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.total,
    required this.itemsCount,
    this.createdAt,
  });

  factory AdminOrderListItemModel.fromJson(Map<String, dynamic> json) {
    return AdminOrderListItemModel(
      id: _Parser.intValue(json['id']),
      orderNumber: _Parser.stringValue(json['order_number'] ?? json['orderNumber']),
      customer: AdminOrderCustomerModel.fromJson(
        _Parser.mapValue(json['customer']),
      ),
      status: _Parser.stringValue(json['status'], fallback: 'pending'),
      paymentStatus: _Parser.stringValue(
        json['payment_status'] ?? json['paymentStatus'],
        fallback: 'unpaid',
      ),
      paymentMethod: _Parser.stringValue(
        json['payment_method'] ?? json['paymentMethod'],
        fallback: 'cod',
      ),
      total: _Parser.numValue(json['total']),
      itemsCount: _Parser.intValue(json['items_count'] ?? json['itemsCount']),
      createdAt: _Parser.dateValue(json['created_at'] ?? json['createdAt']),
    );
  }

  AdminOrderListItemModel copyWith({
    String? status,
    String? paymentStatus,
    String? paymentMethod,
  }) {
    return AdminOrderListItemModel(
      id: id,
      orderNumber: orderNumber,
      customer: customer,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      total: total,
      itemsCount: itemsCount,
      createdAt: createdAt,
    );
  }
}

class AdminOrderAddressModel {
  final String name;
  final String phone;
  final String division;
  final String city;
  final String area;
  final String addressLine;
  final String postalCode;

  const AdminOrderAddressModel({
    required this.name,
    required this.phone,
    required this.division,
    required this.city,
    required this.area,
    required this.addressLine,
    required this.postalCode,
  });

  factory AdminOrderAddressModel.fromJson(Map<String, dynamic> json) {
    return AdminOrderAddressModel(
      name: _Parser.stringValue(json['name']),
      phone: _Parser.stringValue(json['phone']),
      division: _Parser.stringValue(json['division']),
      city: _Parser.stringValue(json['city']),
      area: _Parser.stringValue(json['area']),
      addressLine: _Parser.stringValue(json['address_line'] ?? json['addressLine']),
      postalCode: _Parser.stringValue(json['postal_code'] ?? json['postalCode']),
    );
  }

  String get fullAddress {
    final parts = [addressLine, area, city, division]
        .where((part) => part.trim().isNotEmpty)
        .toList();
    final address = parts.join(', ');
    return postalCode.isEmpty ? address : '$address - $postalCode';
  }
}

class AdminOrderProductItemModel {
  final int id;
  final int productId;
  final int? variantId;
  final String name;
  final String sku;
  final String thumbnail;
  final String? size;
  final String? color;
  final int quantity;
  final num price;
  final num subtotal;

  const AdminOrderProductItemModel({
    required this.id,
    required this.productId,
    this.variantId,
    required this.name,
    required this.sku,
    required this.thumbnail,
    this.size,
    this.color,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory AdminOrderProductItemModel.fromJson(Map<String, dynamic> json) {
    return AdminOrderProductItemModel(
      id: _Parser.intValue(json['id']),
      productId: _Parser.intValue(json['product_id'] ?? json['productId']),
      variantId: _Parser.nullableInt(json['variant_id'] ?? json['variantId']),
      name: _Parser.stringValue(json['name']),
      sku: _Parser.stringValue(json['sku']),
      thumbnail: _Parser.stringValue(json['thumbnail'] ?? json['image']),
      size: _Parser.nullableString(json['size']),
      color: _Parser.nullableString(json['color']),
      quantity: _Parser.intValue(json['quantity']),
      price: _Parser.numValue(json['price']),
      subtotal: _Parser.numValue(json['subtotal']),
    );
  }
}

class AdminOrderStatusHistoryModel {
  final String status;
  final String note;
  final DateTime? createdAt;

  const AdminOrderStatusHistoryModel({
    required this.status,
    required this.note,
    this.createdAt,
  });

  factory AdminOrderStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    return AdminOrderStatusHistoryModel(
      status: _Parser.stringValue(json['status']),
      note: _Parser.stringValue(json['note']),
      createdAt: _Parser.dateValue(json['created_at'] ?? json['createdAt']),
    );
  }
}

class AdminOrderDetailsModel {
  final int id;
  final String orderNumber;
  final AdminOrderCustomerModel customer;
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
  final AdminOrderAddressModel shippingAddress;
  final List<AdminOrderProductItemModel> items;
  final List<AdminOrderStatusHistoryModel> statusHistory;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AdminOrderDetailsModel({
    required this.id,
    required this.orderNumber,
    required this.customer,
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
    required this.shippingAddress,
    required this.items,
    required this.statusHistory,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'];
    final historyJson = json['status_history'] ?? json['statusHistory'];

    return AdminOrderDetailsModel(
      id: _Parser.intValue(json['id']),
      orderNumber: _Parser.stringValue(json['order_number'] ?? json['orderNumber']),
      customer: AdminOrderCustomerModel.fromJson(_Parser.mapValue(json['customer'])),
      status: _Parser.stringValue(json['status'], fallback: 'pending'),
      paymentStatus: _Parser.stringValue(json['payment_status'] ?? json['paymentStatus'], fallback: 'unpaid'),
      paymentMethod: _Parser.stringValue(json['payment_method'] ?? json['paymentMethod'], fallback: 'cod'),
      subtotal: _Parser.numValue(json['subtotal']),
      discount: _Parser.numValue(json['discount']),
      shippingCharge: _Parser.numValue(json['shipping_charge'] ?? json['shippingCharge']),
      tax: _Parser.numValue(json['tax']),
      total: _Parser.numValue(json['total']),
      currency: _Parser.stringValue(json['currency'], fallback: 'BDT'),
      note: _Parser.stringValue(json['note']),
      shippingAddress: AdminOrderAddressModel.fromJson(
        _Parser.mapValue(json['shipping_address'] ?? json['shippingAddress']),
      ),
      items: itemsJson is List
          ? itemsJson
              .whereType<Map>()
              .map((item) => AdminOrderProductItemModel.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : [],
      statusHistory: historyJson is List
          ? historyJson
              .whereType<Map>()
              .map((item) => AdminOrderStatusHistoryModel.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : [],
      createdAt: _Parser.dateValue(json['created_at'] ?? json['createdAt']),
      updatedAt: _Parser.dateValue(json['updated_at'] ?? json['updatedAt']),
    );
  }

  AdminOrderDetailsModel copyWith({String? status, String? paymentStatus}) {
    return AdminOrderDetailsModel(
      id: id,
      orderNumber: orderNumber,
      customer: customer,
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
      shippingAddress: shippingAddress,
      items: items,
      statusHistory: statusHistory,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class _Parser {
  static String stringValue(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    return value.toString();
  }

  static String? nullableString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static int intValue(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int? nullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static num numValue(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? dateValue(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static Map<String, dynamic> mapValue(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }
}
