import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/notification_model.dart';

class NotificationApiService {
  final ApiClient _apiClient;

  NotificationApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _apiClient.get(ApiConstants.notifications);
    final data = response['data'];

    if (data is! Map<String, dynamic>) return [];

    final items = data['items'];

    if (items is! List) return [];

    return items
        .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<int> getUnreadCount() async {
    final response = await _apiClient.get(ApiConstants.notifications);
    final data = response['data'];

    if (data is! Map<String, dynamic>) return 0;

    return data['unread_count'] ?? 0;
  }

  Future<NotificationModel?> getNotificationDetails(int id) async {
    final response = await _apiClient.get(ApiConstants.notificationDetails(id));

    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return NotificationModel.fromJson(data);
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
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return data['deleted_notification_id'];
  }
}
