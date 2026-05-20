class CartCouponModel {
  final String code;
  final String type;
  final num value;
  final num discountAmount;
  final num minimumOrderAmount;
  final DateTime? expiresAt;

  const CartCouponModel({
    required this.code,
    required this.type,
    required this.value,
    required this.discountAmount,
    required this.minimumOrderAmount,
    this.expiresAt,
  });

  factory CartCouponModel.fromJson(Map<String, dynamic> json) {
    return CartCouponModel(
      code: _asString(json['code']),
      type: _asString(json['type'], fallback: 'fixed'),
      value: _asNum(json['value']),
      discountAmount: _asNum(
        json['discount_amount'] ?? json['discountAmount'] ?? json['discount'],
      ),
      minimumOrderAmount: _asNum(
        json['minimum_order_amount'] ?? json['minimumOrderAmount'],
      ),
      expiresAt: _asDateTime(json['expires_at'] ?? json['expiresAt']),
    );
  }

  bool get hasExpiry => expiresAt != null;

  bool get isExpired {
    final date = expiresAt;
    if (date == null) return false;
    return DateTime.now().isAfter(date);
  }

  static String _asString(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  static num _asNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value.replaceAll(',', '')) ?? 0;
    return 0;
  }

  static DateTime? _asDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
