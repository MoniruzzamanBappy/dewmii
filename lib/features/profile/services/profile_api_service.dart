import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/notification_settings_model.dart';
import '../models/profile_model.dart';

class ProfileApiService {
  final ApiClient _apiClient;

  ProfileApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<ProfileModel?> getProfile() async {
    final response = await _apiClient.get(ApiConstants.userProfile);
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return ProfileModel.fromJson(data);
  }

  Future<Map<String, dynamic>> updateProfileDemo({
    required ProfileModel profile,
  }) async {
    return _apiClient.get(ApiConstants.updateProfile);
  }

  Future<Map<String, dynamic>> uploadAvatarDemo() async {
    return _apiClient.get(ApiConstants.uploadAvatar);
  }

  Future<Map<String, dynamic>> changePasswordDemo({
    required String currentPassword,
    required String newPassword,
  }) async {
    return _apiClient.get(ApiConstants.userChangePassword);
  }

  Future<NotificationSettingsModel?> getNotificationSettings() async {
    final response = await _apiClient.get(ApiConstants.notificationSettings);
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return NotificationSettingsModel.fromJson(data);
  }

  Future<Map<String, dynamic>> updateNotificationSettingsDemo({
    required NotificationSettingsModel settings,
  }) async {
    return _apiClient.get(ApiConstants.updateNotificationSettings);
  }

  Future<Map<String, dynamic>> deleteAccountDemo() async {
    return _apiClient.get(ApiConstants.deleteAccount);
  }

  ProfileModel? parseProfile(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return ProfileModel.fromJson(data);
  }

  String? parseAvatarUrl(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return data['avatar_url'];
  }

  NotificationSettingsModel? parseNotificationSettings(
    Map<String, dynamic> response,
  ) {
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return NotificationSettingsModel.fromJson(data);
  }
}
