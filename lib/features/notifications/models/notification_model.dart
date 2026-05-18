class NotificationActionModel {
  final String label;
  final String screen;
  final Map<String, dynamic> params;

  NotificationActionModel({
    required this.label,
    required this.screen,
    required this.params,
  });

  factory NotificationActionModel.fromJson(Map<String, dynamic> json) {
    return NotificationActionModel(
      label: json['label'] ?? '',
      screen: json['screen'] ?? '',
      params: json['params'] is Map<String, dynamic>
          ? json['params'] as Map<String, dynamic>
          : <String, dynamic>{},
    );
  }
}

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String type;
  final int? referenceId;
  final bool isRead;
  final NotificationActionModel? action;
  final DateTime? createdAt;
  final DateTime? readAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.referenceId,
    required this.isRead,
    this.action,
    this.createdAt,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final actionJson = json['action'];

    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      referenceId: json['reference_id'],
      isRead: json['is_read'] ?? false,
      action: actionJson is Map<String, dynamic>
          ? NotificationActionModel.fromJson(actionJson)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      readAt: json['read_at'] != null
          ? DateTime.tryParse(json['read_at'])
          : null,
    );
  }

  NotificationModel copyWith({bool? isRead, DateTime? readAt}) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      type: type,
      referenceId: referenceId,
      isRead: isRead ?? this.isRead,
      action: action,
      createdAt: createdAt,
      readAt: readAt ?? this.readAt,
    );
  }
}
