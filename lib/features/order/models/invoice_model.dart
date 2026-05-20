class InvoiceModel {
  final int orderId;
  final String orderNumber;
  final String invoiceNumber;
  final String invoiceUrl;
  final DateTime? generatedAt;

  const InvoiceModel({
    required this.orderId,
    required this.orderNumber,
    required this.invoiceNumber,
    required this.invoiceUrl,
    this.generatedAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      orderId: _Json.intValue(json['order_id'] ?? json['orderId']),
      orderNumber: _Json.stringValue(json['order_number'] ?? json['orderNumber']),
      invoiceNumber: _Json.stringValue(json['invoice_number'] ?? json['invoiceNumber']),
      invoiceUrl: _Json.stringValue(json['invoice_url'] ?? json['invoiceUrl']),
      generatedAt: _Json.dateValue(json['generated_at'] ?? json['generatedAt']),
    );
  }
}

class _Json {
  static int intValue(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String stringValue(dynamic value) => value?.toString() ?? '';

  static DateTime? dateValue(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
