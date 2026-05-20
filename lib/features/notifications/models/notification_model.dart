class NotificationActionModel {
  final String label;
  final String screen;
  final Map<String, dynamic> params;

  const NotificationActionModel({
    required this.label,
    required this.screen,
    required this.params,
  });

  factory NotificationActionModel.fromJson(Map<String, dynamic> json) {
    return NotificationActionModel(
      label: _asString(json['label']),
      screen: _asString(json['screen']),
      params: _asMap(json['params']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'screen': screen,
      'params': params,
    };
  }

  static String _asString(dynamic value) => value?.toString() ?? '';

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
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

  const NotificationModel({
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
      id: _asInt(json['id']),
      title: _asString(json['title']),
      message: _asString(json['message']),
      type: _asString(json['type']).isEmpty
          ? 'general'
          : _asString(json['type']).toLowerCase(),
      referenceId: _asNullableInt(json['reference_id'] ?? json['referenceId']),
      isRead: _asBool(json['is_read'] ?? json['isRead']),
      action: actionJson is Map
          ? NotificationActionModel.fromJson(
              Map<String, dynamic>.from(actionJson),
            )
          : null,
      createdAt: _asDate(json['created_at'] ?? json['createdAt']),
      readAt: _asDate(json['read_at'] ?? json['readAt']),
    );
  }

  String get displayType {
    if (type.isEmpty) return 'General';
    return '${type[0].toUpperCase()}${type.substring(1)}';
  }

  String get shortDate {
    final date = createdAt;
    if (date == null) return '';
    final local = date.toLocal();
    final now = DateTime.now();
    final difference = now.difference(local);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day/$month/${local.year}';
  }

  NotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    String? type,
    int? referenceId,
    bool? isRead,
    NotificationActionModel? action,
    DateTime? createdAt,
    DateTime? readAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      isRead: isRead ?? this.isRead,
      action: action ?? this.action,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
    );
  }

  static String _asString(dynamic value) => value?.toString() ?? '';

  static int _asInt(dynamic value) => _asNullableInt(value) ?? 0;

  static int? _asNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = value?.toString().toLowerCase().trim();
    return text == 'true' || text == '1' || text == 'yes';
  }

  static DateTime? _asDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
