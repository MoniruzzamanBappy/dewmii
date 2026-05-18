class CartCouponModel {
  final String code;
  final String type;
  final num value;
  final num discountAmount;
  final num minimumOrderAmount;
  final DateTime? expiresAt;

  CartCouponModel({
    required this.code,
    required this.type,
    required this.value,
    required this.discountAmount,
    required this.minimumOrderAmount,
    this.expiresAt,
  });

  factory CartCouponModel.fromJson(Map<String, dynamic> json) {
    return CartCouponModel(
      code: json['code'] ?? '',
      type: json['type'] ?? '',
      value: json['value'] ?? 0,
      discountAmount: json['discount_amount'] ?? 0,
      minimumOrderAmount: json['minimum_order_amount'] ?? 0,
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'])
          : null,
    );
  }
}
