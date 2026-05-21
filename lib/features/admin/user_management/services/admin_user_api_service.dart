import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/admin_user_model.dart';

class AdminUserApiService {
  final ApiClient _apiClient;

  AdminUserApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<AdminUserListItemModel>> getUsers() async {
    final response = await _apiClient.get(ApiConstants.adminUsers);
    final data = response['data'];
    final items = data is Map<String, dynamic> ? data['items'] : data;
    if (items is! List) return [];
    return items
        .whereType<Map<String, dynamic>>()
        .map(AdminUserListItemModel.fromJson)
        .toList();
  }

  Future<AdminUserDetailsModel?> getUserDetails(int userId) async {
    final response = await _apiClient.get(ApiConstants.adminUserDetails(userId));
    final data = response['data'];
    if (data is! Map<String, dynamic>) return null;
    return AdminUserDetailsModel.fromJson(data);
  }

  Future<Map<String, dynamic>> updateStatus({
    required int userId,
    required String status,
    String? reason,
  }) async {
    try {
      return await _apiClient.put(
        ApiConstants.adminUserUpdateStatus,
        body: {
          'user_id': userId,
          'status': status,
          'reason': ?reason,
        },
      );
    } catch (_) {
      return _apiClient.get(ApiConstants.adminUserUpdateStatus);
    }
  }

  Future<Map<String, dynamic>> updateRole({
    required int userId,
    required String role,
  }) async {
    try {
      return await _apiClient.put(
        ApiConstants.adminUserUpdateRole,
        body: {
          'user_id': userId,
          'role': role,
        },
      );
    } catch (_) {
      return _apiClient.get(ApiConstants.adminUserUpdateRole);
    }
  }

  Future<Map<String, dynamic>> updateStatusDemo({
    required int userId,
    required String status,
    required String reason,
  }) {
    return updateStatus(userId: userId, status: status, reason: reason);
  }

  Future<Map<String, dynamic>> updateRoleDemo({
    required int userId,
    required String role,
  }) {
    return updateRole(userId: userId, role: role);
  }

  String? parseUpdatedStatus(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) return data['status']?.toString();
    return response['status']?.toString();
  }

  String? parseUpdatedRole(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) return data['role']?.toString();
    return response['role']?.toString();
  }
}
