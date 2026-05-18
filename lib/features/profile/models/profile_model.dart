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

  ProfileModel({
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
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      displayName: json['display_name'] ?? '',
      avatarUrl: json['avatar_url'],
      phoneNumber: json['phone_number'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      emailVerified: json['email_verified'] ?? false,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.tryParse(json['last_login_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
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
}
