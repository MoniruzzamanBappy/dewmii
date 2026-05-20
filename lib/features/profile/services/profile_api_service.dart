import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/notification_settings_model.dart';
import '../models/profile_model.dart';

class ProfileApiService {
  final ApiClient _apiClient;

  ProfileApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<ProfileModel?> getProfile() async {
    final response = await _apiClient.get(ApiConstants.userProfile);
    return parseProfile(response);
  }

  Future<Map<String, dynamic>> updateProfileDemo({required ProfileModel profile}) async {
    try {
      return await _apiClient.put(ApiConstants.updateProfile, body: profile.toJson());
    } catch (_) {
      return _apiClient.get(ApiConstants.updateProfile);
    }
  }

  Future<Map<String, dynamic>> uploadAvatarDemo() async {
    try {
      return await _apiClient.post(ApiConstants.uploadAvatar, body: {'avatar': 'demo'});
    } catch (_) {
      return _apiClient.get(ApiConstants.uploadAvatar);
    }
  }

  Future<Map<String, dynamic>> changePasswordDemo({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      return await _apiClient.post(
        ApiConstants.userChangePassword,
        body: {'current_password': currentPassword, 'new_password': newPassword},
      );
    } catch (_) {
      return _apiClient.get(ApiConstants.userChangePassword);
    }
  }

  Future<NotificationSettingsModel?> getNotificationSettings() async {
    final response = await _apiClient.get(ApiConstants.notificationSettings);
    return parseNotificationSettings(response);
  }

  Future<Map<String, dynamic>> updateNotificationSettingsDemo({
    required NotificationSettingsModel settings,
  }) async {
    try {
      return await _apiClient.put(
        ApiConstants.updateNotificationSettings,
        body: settings.toJson(),
      );
    } catch (_) {
      return _apiClient.get(ApiConstants.updateNotificationSettings);
    }
  }

  Future<Map<String, dynamic>> deleteAccountDemo() async {
    try {
      return await _apiClient.delete(ApiConstants.deleteAccount);
    } catch (_) {
      return _apiClient.get(ApiConstants.deleteAccount);
    }
  }

  ProfileModel? parseProfile(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) return ProfileModel.fromJson(data);
    if (response.isNotEmpty) return ProfileModel.fromJson(response);
    return null;
  }

  String? parseAvatarUrl(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) return data['avatar_url']?.toString();
    return response['avatar_url']?.toString();
  }

  NotificationSettingsModel? parseNotificationSettings(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) return NotificationSettingsModel.fromJson(data);
    if (response.isNotEmpty) return NotificationSettingsModel.fromJson(response);
    return null;
  }
}
