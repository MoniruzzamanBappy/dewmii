class OrderListItemModel {
  final int id;
  final String orderNumber;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final num total;
  final int itemsCount;
  final DateTime? createdAt;

  const OrderListItemModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.total,
    required this.itemsCount,
    this.createdAt,
  });

  factory OrderListItemModel.fromJson(Map<String, dynamic> json) {
    return OrderListItemModel(
      id: _Json.intValue(json['id'] ?? json['order_id']),
      orderNumber: _Json.stringValue(json['order_number'] ?? json['orderNumber']),
      status: _Json.stringValue(json['status'], fallback: 'pending'),
      paymentStatus: _Json.stringValue(json['payment_status'] ?? json['paymentStatus'], fallback: 'unpaid'),
      paymentMethod: _Json.stringValue(json['payment_method'] ?? json['paymentMethod'], fallback: 'cash'),
      total: _Json.numValue(json['total'] ?? json['grand_total']),
      itemsCount: _Json.intValue(json['items_count'] ?? json['itemsCount'] ?? json['quantity']),
      createdAt: _Json.dateValue(json['created_at'] ?? json['createdAt']),
    );
  }

  OrderListItemModel copyWith({
    String? status,
    String? paymentStatus,
    String? paymentMethod,
    num? total,
    int? itemsCount,
  }) {
    return OrderListItemModel(
      id: id,
      orderNumber: orderNumber,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      total: total ?? this.total,
      itemsCount: itemsCount ?? this.itemsCount,
      createdAt: createdAt,
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

  static num numValue(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? 0;
    return 0;
  }

  static String stringValue(dynamic value, {String fallback = ''}) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? fallback : text;
  }

  static DateTime? dateValue(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
