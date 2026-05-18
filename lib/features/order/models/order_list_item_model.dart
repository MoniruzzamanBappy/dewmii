class OrderListItemModel {
  final int id;
  final String orderNumber;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final num total;
  final int itemsCount;
  final DateTime? createdAt;

  OrderListItemModel({
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
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      total: json['total'] ?? 0,
      itemsCount: json['items_count'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  OrderListItemModel copyWith({String? status, String? paymentStatus}) {
    return OrderListItemModel(
      id: id,
      orderNumber: orderNumber,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod,
      total: total,
      itemsCount: itemsCount,
      createdAt: createdAt,
    );
  }
}
