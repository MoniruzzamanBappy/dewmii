class PaymentResultModel {
  final int paymentId;
  final int orderId;
  final String orderNumber;
  final String paymentMethod;
  final num amount;
  final String currency;
  final String transactionId;
  final String paymentStatus;
  final String? paymentUrl;
  final DateTime? createdAt;
  final DateTime? paidAt;

  PaymentResultModel({
    required this.paymentId,
    required this.orderId,
    required this.orderNumber,
    required this.paymentMethod,
    required this.amount,
    required this.currency,
    required this.transactionId,
    required this.paymentStatus,
    this.paymentUrl,
    this.createdAt,
    this.paidAt,
  });

  factory PaymentResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['payment'] is Map<String, dynamic>
        ? json['payment'] as Map<String, dynamic>
        : json;

    return PaymentResultModel(
      paymentId: _toInt(data['payment_id'] ?? data['id']),
      orderId: _toInt(data['order_id']),
      orderNumber: _toString(data['order_number']),
      paymentMethod: _toString(data['payment_method']),
      amount: _toNum(data['amount'] ?? data['paid_amount']),
      currency: _toString(data['currency']).isEmpty ? 'BDT' : _toString(data['currency']),
      transactionId: _toString(data['transaction_id']),
      paymentStatus: _toString(data['payment_status'] ?? data['status']),
      paymentUrl: (data['payment_url'] ?? data['redirect_url'])?.toString(),
      createdAt: _toDate(data['created_at']),
      paidAt: _toDate(data['paid_at']),
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
