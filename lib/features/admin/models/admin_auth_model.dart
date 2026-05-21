class AdminJson {
  AdminJson._();

  static Map<String, dynamic> map(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.map((key, val) => MapEntry(key.toString(), val));
    return <String, dynamic>{};
  }

  static String string(dynamic value, [String fallback = '']) {
    if (value == null) return fallback;
    return value.toString();
  }

  static int integer(dynamic value, [int fallback = 0]) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static bool boolean(dynamic value, [bool fallback = false]) {
    if (value is bool) return value;
    final text = value?.toString().toLowerCase().trim();
    if (text == 'true' || text == '1' || text == 'yes') return true;
    if (text == 'false' || text == '0' || text == 'no') return false;
    return fallback;
  }

  static DateTime? date(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

class AdminUserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String status;
  final String? avatarUrl;
  final DateTime? lastLoginAt;

  const AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    this.avatarUrl,
    this.lastLoginAt,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'A';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'.toUpperCase();
  }

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    final avatar = AdminJson.string(json['avatar_url']);
    return AdminUserModel(
      id: AdminJson.integer(json['id']),
      name: AdminJson.string(json['name'], 'Admin User'),
      email: AdminJson.string(json['email']),
      role: AdminJson.string(json['role'], 'admin'),
      status: AdminJson.string(json['status'], 'active'),
      avatarUrl: avatar.isEmpty ? null : avatar,
      lastLoginAt: AdminJson.date(json['last_login_at']),
    );
  }
}

class AdminAuthModel {
  final bool success;
  final String message;
  final AdminUserModel admin;
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  const AdminAuthModel({
    required this.success,
    required this.message,
    required this.admin,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory AdminAuthModel.fromJson(Map<String, dynamic> json) {
    final data = AdminJson.map(json['data']);
    return AdminAuthModel(
      success: AdminJson.boolean(json['success'], true),
      message: AdminJson.string(json['message'], 'Logged in successfully'),
      admin: AdminUserModel.fromJson(AdminJson.map(data['admin'])),
      accessToken: AdminJson.string(data['access_token']),
      refreshToken: AdminJson.string(data['refresh_token']),
      tokenType: AdminJson.string(data['token_type'], 'Bearer'),
      expiresIn: AdminJson.integer(data['expires_in']),
    );
  }
}
