class InvoiceModel {
  final int orderId;
  final String orderNumber;
  final String invoiceNumber;
  final String invoiceUrl;
  final DateTime? generatedAt;

  InvoiceModel({
    required this.orderId,
    required this.orderNumber,
    required this.invoiceNumber,
    required this.invoiceUrl,
    this.generatedAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      orderId: json['order_id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      invoiceNumber: json['invoice_number'] ?? '',
      invoiceUrl: json['invoice_url'] ?? '',
      generatedAt: json['generated_at'] != null
          ? DateTime.tryParse(json['generated_at'])
          : null,
    );
  }
}
