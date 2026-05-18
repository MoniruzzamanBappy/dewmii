class OrderResultModel {
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
  final DateTime? createdAt;
  final String? redirectUrl;

  OrderResultModel({
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
    this.createdAt,
    this.redirectUrl,
  });

  factory OrderResultModel.fromJson(Map<String, dynamic> json) {
    final order = json['order'] is Map<String, dynamic>
        ? json['order'] as Map<String, dynamic>
        : json;

    return OrderResultModel(
      id: order['id'] ?? 0,
      orderNumber: order['order_number'] ?? '',
      userId: order['user_id'] ?? 0,
      status: order['status'] ?? '',
      paymentStatus: order['payment_status'] ?? '',
      paymentMethod: order['payment_method'] ?? '',
      subtotal: order['subtotal'] ?? 0,
      discount: order['discount'] ?? 0,
      shippingCharge: order['shipping_charge'] ?? 0,
      tax: order['tax'] ?? 0,
      total: order['total'] ?? 0,
      currency: order['currency'] ?? 'BDT',
      createdAt: order['created_at'] != null
          ? DateTime.tryParse(order['created_at'])
          : null,
      redirectUrl: json['redirect_url'],
    );
  }
}
