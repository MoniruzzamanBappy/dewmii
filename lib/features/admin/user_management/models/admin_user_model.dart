import 'package:flutter/widgets.dart';

class AdminUserListItemModel {
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
  final int totalOrders;
  final num totalSpent;
  final DateTime? createdAt;

  const AdminUserListItemModel({
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
    required this.totalOrders,
    required this.totalSpent,
    this.createdAt,
  });

  factory AdminUserListItemModel.fromJson(Map<String, dynamic> json) {
    return AdminUserListItemModel(
      id: _toInt(json['id']),
      username: _toString(json['username']),
      email: _toString(json['email']),
      firstName: _toString(json['first_name'] ?? json['firstName']),
      lastName: _toString(json['last_name'] ?? json['lastName']),
      displayName: _toString(json['display_name'] ?? json['displayName']).isEmpty
          ? _fallbackName(json)
          : _toString(json['display_name'] ?? json['displayName']),
      avatarUrl: _nullableString(json['avatar_url'] ?? json['avatarUrl']),
      phoneNumber: _toString(json['phone_number'] ?? json['phoneNumber']),
      role: _toString(json['role']).isEmpty ? 'customer' : _toString(json['role']),
      status: _toString(json['status']).isEmpty ? 'active' : _toString(json['status']),
      emailVerified: _toBool(json['email_verified'] ?? json['emailVerified']),
      totalOrders: _toInt(json['total_orders'] ?? json['totalOrders']),
      totalSpent: _toNum(json['total_spent'] ?? json['totalSpent']),
      createdAt: _toDate(json['created_at'] ?? json['createdAt']),
    );
  }

  String get initials {
    final source = displayName.isNotEmpty ? displayName : email;
    final parts = source.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.characters.take(1).toString().toUpperCase();
    return '${parts.first.characters.take(1)}${parts.last.characters.take(1)}'.toUpperCase();
  }

  AdminUserListItemModel copyWith({String? role, String? status}) {
    return AdminUserListItemModel(
      id: id,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      displayName: displayName,
      avatarUrl: avatarUrl,
      phoneNumber: phoneNumber,
      role: role ?? this.role,
      status: status ?? this.status,
      emailVerified: emailVerified,
      totalOrders: totalOrders,
      totalSpent: totalSpent,
      createdAt: createdAt,
    );
  }
}

class AdminUserAddressModel {
  final int id;
  final String name;
  final String phone;
  final String division;
  final String city;
  final String area;
  final String addressLine;
  final bool isDefault;

  const AdminUserAddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.division,
    required this.city,
    required this.area,
    required this.addressLine,
    required this.isDefault,
  });

  factory AdminUserAddressModel.fromJson(Map<String, dynamic> json) {
    return AdminUserAddressModel(
      id: _toInt(json['id']),
      name: _toString(json['name']),
      phone: _toString(json['phone']),
      division: _toString(json['division']),
      city: _toString(json['city']),
      area: _toString(json['area']),
      addressLine: _toString(json['address_line'] ?? json['addressLine']),
      isDefault: _toBool(json['is_default'] ?? json['isDefault']),
    );
  }

  String get fullAddress => [addressLine, area, city, division].where((e) => e.trim().isNotEmpty).join(', ');
}

class AdminUserRecentOrderModel {
  final int id;
  final String orderNumber;
  final String status;
  final String paymentStatus;
  final num total;
  final DateTime? createdAt;

  const AdminUserRecentOrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    required this.total,
    this.createdAt,
  });

  factory AdminUserRecentOrderModel.fromJson(Map<String, dynamic> json) {
    return AdminUserRecentOrderModel(
      id: _toInt(json['id']),
      orderNumber: _toString(json['order_number'] ?? json['orderNumber']),
      status: _toString(json['status']),
      paymentStatus: _toString(json['payment_status'] ?? json['paymentStatus']),
      total: _toNum(json['total']),
      createdAt: _toDate(json['created_at'] ?? json['createdAt']),
    );
  }
}

class AdminUserDetailsModel {
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
  final int totalOrders;
  final num totalSpent;
  final List<AdminUserAddressModel> addresses;
  final List<AdminUserRecentOrderModel> recentOrders;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AdminUserDetailsModel({
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
    required this.totalOrders,
    required this.totalSpent,
    required this.addresses,
    required this.recentOrders,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminUserDetailsModel.fromJson(Map<String, dynamic> json) {
    final addressesJson = json['addresses'];
    final recentOrdersJson = json['recent_orders'] ?? json['recentOrders'];

    return AdminUserDetailsModel(
      id: _toInt(json['id']),
      username: _toString(json['username']),
      email: _toString(json['email']),
      firstName: _toString(json['first_name'] ?? json['firstName']),
      lastName: _toString(json['last_name'] ?? json['lastName']),
      displayName: _toString(json['display_name'] ?? json['displayName']).isEmpty
          ? _fallbackName(json)
          : _toString(json['display_name'] ?? json['displayName']),
      avatarUrl: _nullableString(json['avatar_url'] ?? json['avatarUrl']),
      phoneNumber: _toString(json['phone_number'] ?? json['phoneNumber']),
      role: _toString(json['role']).isEmpty ? 'customer' : _toString(json['role']),
      status: _toString(json['status']).isEmpty ? 'active' : _toString(json['status']),
      emailVerified: _toBool(json['email_verified'] ?? json['emailVerified']),
      lastLoginAt: _toDate(json['last_login_at'] ?? json['lastLoginAt']),
      totalOrders: _toInt(json['total_orders'] ?? json['totalOrders']),
      totalSpent: _toNum(json['total_spent'] ?? json['totalSpent']),
      addresses: addressesJson is List
          ? addressesJson.whereType<Map<String, dynamic>>().map(AdminUserAddressModel.fromJson).toList()
          : [],
      recentOrders: recentOrdersJson is List
          ? recentOrdersJson.whereType<Map<String, dynamic>>().map(AdminUserRecentOrderModel.fromJson).toList()
          : [],
      createdAt: _toDate(json['created_at'] ?? json['createdAt']),
      updatedAt: _toDate(json['updated_at'] ?? json['updatedAt']),
    );
  }

  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.characters.take(1).toString().toUpperCase();
    return '${parts.first.characters.take(1)}${parts.last.characters.take(1)}'.toUpperCase();
  }

  AdminUserDetailsModel copyWith({String? role, String? status}) {
    return AdminUserDetailsModel(
      id: id,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      displayName: displayName,
      avatarUrl: avatarUrl,
      phoneNumber: phoneNumber,
      role: role ?? this.role,
      status: status ?? this.status,
      emailVerified: emailVerified,
      lastLoginAt: lastLoginAt,
      totalOrders: totalOrders,
      totalSpent: totalSpent,
      addresses: addresses,
      recentOrders: recentOrders,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

String _fallbackName(Map<String, dynamic> json) {
  final first = _toString(json['first_name'] ?? json['firstName']);
  final last = _toString(json['last_name'] ?? json['lastName']);
  final combined = '$first $last'.trim();
  if (combined.isNotEmpty) return combined;
  final username = _toString(json['username']);
  if (username.isNotEmpty) return username;
  return _toString(json['email']).isEmpty ? 'Customer' : _toString(json['email']);
}

String _toString(dynamic value) => value?.toString() ?? '';
String? _nullableString(dynamic value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

num _toNum(dynamic value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
}

bool _toBool(dynamic value) {
  if (value is bool) return value;
  final text = value?.toString().toLowerCase().trim();
  return text == 'true' || text == '1' || text == 'yes' || text == 'verified';
}

DateTime? _toDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
