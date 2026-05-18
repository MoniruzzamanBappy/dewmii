class OrderAddressModel {
  final String name;
  final String phone;
  final String division;
  final String city;
  final String area;
  final String addressLine;
  final String postalCode;

  OrderAddressModel({
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
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      division: json['division'] ?? '',
      city: json['city'] ?? '',
      area: json['area'] ?? '',
      addressLine: json['address_line'] ?? '',
      postalCode: json['postal_code'] ?? '',
    );
  }

  String get fullAddress {
    return '$addressLine, $area, $city, $division - $postalCode';
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

  OrderDetailsItemModel({
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
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      variantId: json['variant_id'],
      name: json['name'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      size: json['size'],
      color: json['color'],
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? 0,
      subtotal: json['subtotal'] ?? 0,
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

  OrderDetailsModel({
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

    return OrderDetailsModel(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      userId: json['user_id'] ?? 0,
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      subtotal: json['subtotal'] ?? 0,
      discount: json['discount'] ?? 0,
      shippingCharge: json['shipping_charge'] ?? 0,
      tax: json['tax'] ?? 0,
      total: json['total'] ?? 0,
      currency: json['currency'] ?? 'BDT',
      note: json['note'] ?? '',
      address: OrderAddressModel.fromJson(
        json['address'] ?? <String, dynamic>{},
      ),
      items: itemsJson is List
          ? itemsJson
                .map(
                  (item) => OrderDetailsItemModel.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList()
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
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
