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
      id: _toInt(json['id']),
      name: _toString(json['name']),
      code: _toString(json['code']),
      charge: _toNum(json['charge'] ?? json['shipping_charge'] ?? json['fee']),
      estimatedDays: _toString(json['estimated_days'] ?? json['estimatedDays'] ?? json['eta']),
      description: _toString(json['description']),
      city: _toString(json['city']),
      area: json['area']?.toString(),
      isAvailable: _toBool(json['is_available'] ?? json['isAvailable'] ?? true),
    );
  }

  String get formattedCharge => charge <= 0 ? 'Free' : '৳${charge.toStringAsFixed(charge % 1 == 0 ? 0 : 2)}';

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static num _toNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _toString(dynamic value) => value?.toString() ?? '';

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = value?.toString().toLowerCase().trim();
    return text != 'false' && text != '0';
  }
}
