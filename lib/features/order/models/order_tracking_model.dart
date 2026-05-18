class OrderTrackingEventModel {
  final String status;
  final String title;
  final String description;
  final DateTime? date;
  final bool isCompleted;

  OrderTrackingEventModel({
    required this.status,
    required this.title,
    required this.description,
    this.date,
    required this.isCompleted,
  });

  factory OrderTrackingEventModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingEventModel(
      status: json['status'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      isCompleted: json['is_completed'] ?? false,
    );
  }
}

class OrderTrackingModel {
  final int orderId;
  final String orderNumber;
  final String currentStatus;
  final String trackingNumber;
  final String courierName;
  final String trackingUrl;
  final DateTime? estimatedDeliveryDate;
  final List<OrderTrackingEventModel> events;

  OrderTrackingModel({
    required this.orderId,
    required this.orderNumber,
    required this.currentStatus,
    required this.trackingNumber,
    required this.courierName,
    required this.trackingUrl,
    this.estimatedDeliveryDate,
    required this.events,
  });

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) {
    final eventsJson = json['events'];

    return OrderTrackingModel(
      orderId: json['order_id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      currentStatus: json['current_status'] ?? '',
      trackingNumber: json['tracking_number'] ?? '',
      courierName: json['courier_name'] ?? '',
      trackingUrl: json['tracking_url'] ?? '',
      estimatedDeliveryDate: json['estimated_delivery_date'] != null
          ? DateTime.tryParse(json['estimated_delivery_date'])
          : null,
      events: eventsJson is List
          ? eventsJson
                .map(
                  (item) => OrderTrackingEventModel.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList()
          : [],
    );
  }
}
