class CartSummaryModel {
  final num subtotal;
  final num discount;
  final num shippingCharge;
  final num tax;
  final num total;
  final int totalItems;
  final String currency;
  final String? couponCode;

  const CartSummaryModel({
    required this.subtotal,
    required this.discount,
    required this.shippingCharge,
    required this.tax,
    required this.total,
    required this.totalItems,
    required this.currency,
    this.couponCode,
  });

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) {
    final subtotal = _asNum(json['subtotal']);
    final discount = _asNum(json['discount']);
    final shipping = _asNum(
      json['shipping_charge'] ??
          json['shippingCharge'] ??
          json['delivery_charge'],
    );
    final tax = _asNum(json['tax'] ?? json['vat']);

    return CartSummaryModel(
      subtotal: subtotal,
      discount: discount,
      shippingCharge: shipping,
      tax: tax,
      total: _asNum(
        json['total'] ?? json['grand_total'] ?? json['grandTotal'],
        fallback: subtotal - discount + shipping + tax,
      ),
      totalItems: _asInt(
        json['total_items'] ??
            json['totalItems'] ??
            json['item_count'] ??
            json['itemCount'],
      ),
      currency: _asString(json['currency'], fallback: 'BDT'),
      couponCode: _nullableText(json['coupon_code'] ?? json['couponCode']),
    );
  }

  factory CartSummaryModel.empty() {
    return const CartSummaryModel(
      subtotal: 0,
      discount: 0,
      shippingCharge: 0,
      tax: 0,
      total: 0,
      totalItems: 0,
      currency: 'BDT',
      couponCode: null,
    );
  }

  CartSummaryModel copyWith({
    num? subtotal,
    num? discount,
    num? shippingCharge,
    num? tax,
    num? total,
    int? totalItems,
    String? currency,
    String? couponCode,
    bool clearCouponCode = false,
  }) {
    return CartSummaryModel(
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      shippingCharge: shippingCharge ?? this.shippingCharge,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      totalItems: totalItems ?? this.totalItems,
      currency: currency ?? this.currency,
      couponCode: clearCouponCode ? null : couponCode ?? this.couponCode,
    );
  }

  static int _asInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static num _asNum(dynamic value, {num fallback = 0}) {
    if (value is num) return value;
    if (value is String) {
      return num.tryParse(value.replaceAll(',', '')) ?? fallback;
    }
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
