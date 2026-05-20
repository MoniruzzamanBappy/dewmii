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
      id: _toInt(order['id']),
      orderNumber: _toString(order['order_number'] ?? order['orderNumber']),
      userId: _toInt(order['user_id']),
      status: _toString(order['status']),
      paymentStatus: _toString(order['payment_status']),
      paymentMethod: _toString(order['payment_method']),
      subtotal: _toNum(order['subtotal']),
      discount: _toNum(order['discount']),
      shippingCharge: _toNum(order['shipping_charge']),
      tax: _toNum(order['tax']),
      total: _toNum(order['total']),
      currency: _toString(order['currency']).isEmpty ? 'BDT' : _toString(order['currency']),
      createdAt: _toDate(order['created_at']),
      redirectUrl: (json['redirect_url'] ?? order['redirect_url'])?.toString(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static num _toNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _toString(dynamic value) => value?.toString() ?? '';

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
