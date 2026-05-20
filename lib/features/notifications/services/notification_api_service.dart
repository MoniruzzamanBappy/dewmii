import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/notification_model.dart';

class NotificationApiService {
  final ApiClient _apiClient;

  NotificationApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _apiClient.get(ApiConstants.notifications);
    final items = _extractList(response);

    return items
        .whereType<Map>()
        .map((item) => NotificationModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<int> getUnreadCount() async {
    final response = await _apiClient.get(ApiConstants.notifications);
    final data = _extractMap(response['data']);

    return _asInt(
      data['unread_count'] ??
          data['unreadCount'] ??
          response['unread_count'] ??
          response['unreadCount'],
    );
  }

  Future<NotificationModel?> getNotificationDetails(int id) async {
    final response = await _apiClient.get(ApiConstants.notificationDetails(id));
    final data = _extractMap(response['data']);

    if (data.isEmpty) return null;
    return NotificationModel.fromJson(data);
  }

  Future<Map<String, dynamic>> markAsRead({
    required int notificationId,
  }) async {
    try {
      return await _apiClient.put(
        ApiConstants.notificationMarkRead,
        body: {'notification_id': notificationId},
      );
    } catch (_) {
      return markAsReadDemo(notificationId: notificationId);
    }
  }

  Future<Map<String, dynamic>> markAllAsRead() async {
    try {
      return await _apiClient.put(ApiConstants.notificationReadAll);
    } catch (_) {
      return markAllAsReadDemo();
    }
  }

  Future<Map<String, dynamic>> deleteNotification({
    required int notificationId,
  }) async {
    try {
      return await _apiClient.delete(
        ApiConstants.notificationDelete,
        body: {'notification_id': notificationId},
      );
    } catch (_) {
      return deleteNotificationDemo(notificationId: notificationId);
    }
  }

  Future<Map<String, dynamic>> markAsReadDemo({
    required int notificationId,
  }) async {
    return _apiClient.get(ApiConstants.notificationMarkRead);
  }

  Future<Map<String, dynamic>> markAllAsReadDemo() async {
    return _apiClient.get(ApiConstants.notificationReadAll);
  }

  Future<Map<String, dynamic>> deleteNotificationDemo({
    required int notificationId,
  }) async {
    return _apiClient.get(ApiConstants.notificationDelete);
  }

  int? parseDeletedNotificationId(Map<String, dynamic> response) {
    final data = _extractMap(response['data']);
    return _asNullableInt(
      data['deleted_notification_id'] ??
          data['deletedNotificationId'] ??
          data['id'] ??
          response['deleted_notification_id'],
    );
  }

  List<dynamic> _extractList(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is List) return data;

    final map = _extractMap(data);
    final items = map['items'] ?? map['notifications'] ?? response['items'];

    if (items is List) return items;
    return <dynamic>[];
  }

  Map<String, dynamic> _extractMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  int _asInt(dynamic value) => _asNullableInt(value) ?? 0;

  int? _asNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}
