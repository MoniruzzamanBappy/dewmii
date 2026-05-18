class CartSummaryModel {
  final num subtotal;
  final num discount;
  final num shippingCharge;
  final num tax;
  final num total;
  final int totalItems;
  final String currency;
  final String? couponCode;

  CartSummaryModel({
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
    return CartSummaryModel(
      subtotal: json['subtotal'] ?? 0,
      discount: json['discount'] ?? 0,
      shippingCharge: json['shipping_charge'] ?? 0,
      tax: json['tax'] ?? 0,
      total: json['total'] ?? 0,
      totalItems: json['total_items'] ?? 0,
      currency: json['currency'] ?? 'BDT',
      couponCode: json['coupon_code'],
    );
  }

  factory CartSummaryModel.empty() {
    return CartSummaryModel(
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
}
