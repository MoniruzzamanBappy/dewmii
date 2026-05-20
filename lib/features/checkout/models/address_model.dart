class AddressModel {
  final int id;
  final int userId;
  final String name;
  final String phone;
  final String division;
  final String city;
  final String area;
  final String addressLine;
  final String postalCode;
  final String type;
  final bool isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AddressModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.division,
    required this.city,
    required this.area,
    required this.addressLine,
    required this.postalCode,
    required this.type,
    required this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id'] ?? json['userId']),
      name: _toString(json['name']),
      phone: _toString(json['phone'] ?? json['phone_number']),
      division: _toString(json['division']),
      city: _toString(json['city']),
      area: _toString(json['area']),
      addressLine: _toString(json['address_line'] ?? json['addressLine'] ?? json['address']),
      postalCode: _toString(json['postal_code'] ?? json['postalCode']),
      type: _toString(json['type']).isEmpty ? 'home' : _toString(json['type']),
      isDefault: _toBool(json['is_default'] ?? json['isDefault']),
      createdAt: _toDate(json['created_at'] ?? json['createdAt']),
      updatedAt: _toDate(json['updated_at'] ?? json['updatedAt']),
    );
  }

  String get fullAddress {
    final parts = [addressLine, area, city, division, postalCode]
        .where((item) => item.trim().isNotEmpty)
        .toList();
    return parts.isEmpty ? 'No address details' : parts.join(', ');
  }

  String get typeLabel {
    if (type.toLowerCase() == 'office') return 'Office';
    if (type.toLowerCase() == 'other') return 'Other';
    return 'Home';
  }

  AddressModel copyWith({
    int? id,
    int? userId,
    String? name,
    String? phone,
    String? division,
    String? city,
    String? area,
    String? addressLine,
    String? postalCode,
    String? type,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      division: division ?? this.division,
      city: city ?? this.city,
      area: area ?? this.area,
      addressLine: addressLine ?? this.addressLine,
      postalCode: postalCode ?? this.postalCode,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'phone': phone,
      'division': division,
      'city': city,
      'area': area,
      'address_line': addressLine,
      'postal_code': postalCode,
      'type': type,
      'is_default': isDefault,
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _toString(dynamic value) => value?.toString() ?? '';

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = value?.toString().toLowerCase().trim();
    return text == 'true' || text == '1' || text == 'yes';
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
