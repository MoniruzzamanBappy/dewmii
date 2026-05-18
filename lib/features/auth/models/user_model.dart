class UserModel {
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

  UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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

  Map<String, dynamic> toJson() {
    return {
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
      'last_login_at': lastLoginAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
