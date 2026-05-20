class ProfileModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String displayName;
  final String? avatarUrl;
  final String phoneNumber;
  final String role;
  final String status;
  final bool emailVerified;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.displayName,
    this.avatarUrl,
    required this.phoneNumber,
    required this.role,
    required this.status,
    required this.emailVerified,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: _toInt(json['id']),
      username: _toString(json['username']),
      email: _toString(json['email']),
      firstName: _toString(json['first_name'] ?? json['firstName']),
      lastName: _toString(json['last_name'] ?? json['lastName']),
      displayName: _toString(json['display_name'] ?? json['displayName']),
      avatarUrl: _nullableString(json['avatar_url'] ?? json['avatarUrl']),
      phoneNumber: _toString(json['phone_number'] ?? json['phoneNumber']),
      role: _toString(json['role']),
      status: _toString(json['status']),
      emailVerified: _toBool(json['email_verified'] ?? json['emailVerified']),
      lastLoginAt: _toDate(json['last_login_at'] ?? json['lastLoginAt']),
      createdAt: _toDate(json['created_at'] ?? json['createdAt']),
      updatedAt: _toDate(json['updated_at'] ?? json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'display_name': displayName,
        'avatar_url': avatarUrl,
        'phone_number': phoneNumber,
        'role': role,
        'status': status,
        'email_verified': emailVerified,
      };

  String get fullName {
    final value = '$firstName $lastName'.trim();
    if (value.isNotEmpty) return value;
    if (displayName.isNotEmpty) return displayName;
    return username.isNotEmpty ? username : 'Dewmii Customer';
  }

  String get initials {
    final source = fullName.trim();
    if (source.isEmpty) return 'D';
    final parts = source.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'.toUpperCase();
  }

  ProfileModel copyWith({
    int? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? displayName,
    String? avatarUrl,
    String? phoneNumber,
    String? role,
    String? status,
    bool? emailVerified,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      status: status ?? this.status,
      emailVerified: emailVerified ?? this.emailVerified,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    final text = value?.toString().toLowerCase().trim();
    return text == 'true' || text == '1' || text == 'yes';
  }

  static String _toString(dynamic value) => value?.toString() ?? '';

  static String? _nullableString(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
