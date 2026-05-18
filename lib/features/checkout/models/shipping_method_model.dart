class ShippingMethodModel {
  final int id;
  final String name;
  final String code;
  final num charge;
  final String estimatedDays;
  final String description;
  final String city;
  final String? area;
  final bool isAvailable;

  ShippingMethodModel({
    required this.id,
    required this.name,
    required this.code,
    required this.charge,
    required this.estimatedDays,
    required this.description,
    required this.city,
    this.area,
    required this.isAvailable,
  });

  factory ShippingMethodModel.fromJson(Map<String, dynamic> json) {
    return ShippingMethodModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      charge: json['charge'] ?? 0,
      estimatedDays: json['estimated_days'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      area: json['area'],
      isAvailable: json['is_available'] ?? false,
    );
  }
}
