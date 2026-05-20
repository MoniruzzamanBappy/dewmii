class PaymentMethodModel {
  final int id;
  final String code;
  final String name;
  final String description;
  final String logoUrl;
  final bool isOnline;
  final bool isActive;
  final int sortOrder;

  PaymentMethodModel({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.isOnline,
    required this.isActive,
    required this.sortOrder,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: _toInt(json['id']),
      code: _toString(json['code']),
      name: _toString(json['name']),
      description: _toString(json['description']),
      logoUrl: _toString(json['logo_url'] ?? json['logoUrl']),
      isOnline: _toBool(json['is_online'] ?? json['isOnline']),
      isActive: _toBool(json['is_active'] ?? json['isActive'] ?? true),
      sortOrder: _toInt(json['sort_order'] ?? json['sortOrder']),
    );
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
}
