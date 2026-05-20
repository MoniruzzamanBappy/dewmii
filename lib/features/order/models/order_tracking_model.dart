class OrderTrackingEventModel {
  final String status;
  final String title;
  final String description;
  final DateTime? date;
  final bool isCompleted;

  const OrderTrackingEventModel({
    required this.status,
    required this.title,
    required this.description,
    this.date,
    required this.isCompleted,
  });

  factory OrderTrackingEventModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingEventModel(
      status: _Json.stringValue(json['status']),
      title: _Json.stringValue(json['title'], fallback: 'Order update'),
      description: _Json.stringValue(json['description']),
      date: _Json.dateValue(json['date'] ?? json['created_at']),
      isCompleted: _Json.boolValue(json['is_completed'] ?? json['completed']),
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

  const OrderTrackingModel({
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
    final eventsJson = json['events'] ?? json['timeline'];
    return OrderTrackingModel(
      orderId: _Json.intValue(json['order_id'] ?? json['orderId']),
      orderNumber: _Json.stringValue(json['order_number'] ?? json['orderNumber']),
      currentStatus: _Json.stringValue(json['current_status'] ?? json['currentStatus'], fallback: 'pending'),
      trackingNumber: _Json.stringValue(json['tracking_number'] ?? json['trackingNumber']),
      courierName: _Json.stringValue(json['courier_name'] ?? json['courierName']),
      trackingUrl: _Json.stringValue(json['tracking_url'] ?? json['trackingUrl']),
      estimatedDeliveryDate: _Json.dateValue(json['estimated_delivery_date'] ?? json['estimatedDeliveryDate']),
      events: eventsJson is List
          ? eventsJson.whereType<Map<String, dynamic>>().map(OrderTrackingEventModel.fromJson).toList()
          : [],
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

  static bool boolValue(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return ['true', '1', 'yes', 'completed', 'done'].contains(value.toLowerCase().trim());
    return false;
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
