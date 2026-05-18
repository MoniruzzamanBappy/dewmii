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
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      logoUrl: json['logo_url'] ?? '',
      isOnline: json['is_online'] ?? false,
      isActive: json['is_active'] ?? false,
      sortOrder: json['sort_order'] ?? 0,
    );
  }
}
