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
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      division: json['division'] ?? '',
      city: json['city'] ?? '',
      area: json['area'] ?? '',
      addressLine: json['address_line'] ?? '',
      postalCode: json['postal_code'] ?? '',
      type: json['type'] ?? 'home',
      isDefault: json['is_default'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
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

  String get fullAddress {
    return '$addressLine, $area, $city, $division - $postalCode';
  }
}
