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
    return PaymentResultModel(
      paymentId: json['payment_id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      amount: json['amount'] ?? json['paid_amount'] ?? 0,
      currency: json['currency'] ?? 'BDT',
      transactionId: json['transaction_id'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      paymentUrl: json['payment_url'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      paidAt: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'])
          : null,
    );
  }
}
