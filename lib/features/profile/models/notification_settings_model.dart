class NotificationSettingsModel {
  final bool pushNotification;
  final bool emailNotification;
  final bool smsNotification;
  final bool orderUpdates;
  final bool promotionalOffers;
  final bool wishlistUpdates;
  final bool supportUpdates;
  final DateTime? updatedAt;

  const NotificationSettingsModel({
    required this.pushNotification,
    required this.emailNotification,
    required this.smsNotification,
    required this.orderUpdates,
    required this.promotionalOffers,
    required this.wishlistUpdates,
    required this.supportUpdates,
    this.updatedAt,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      pushNotification: _toBool(json['push_notification'] ?? json['pushNotification']),
      emailNotification: _toBool(json['email_notification'] ?? json['emailNotification']),
      smsNotification: _toBool(json['sms_notification'] ?? json['smsNotification']),
      orderUpdates: _toBool(json['order_updates'] ?? json['orderUpdates']),
      promotionalOffers: _toBool(json['promotional_offers'] ?? json['promotionalOffers']),
      wishlistUpdates: _toBool(json['wishlist_updates'] ?? json['wishlistUpdates']),
      supportUpdates: _toBool(json['support_updates'] ?? json['supportUpdates']),
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'push_notification': pushNotification,
        'email_notification': emailNotification,
        'sms_notification': smsNotification,
        'order_updates': orderUpdates,
        'promotional_offers': promotionalOffers,
        'wishlist_updates': wishlistUpdates,
        'support_updates': supportUpdates,
      };

  NotificationSettingsModel copyWith({
    bool? pushNotification,
    bool? emailNotification,
    bool? smsNotification,
    bool? orderUpdates,
    bool? promotionalOffers,
    bool? wishlistUpdates,
    bool? supportUpdates,
    DateTime? updatedAt,
  }) {
    return NotificationSettingsModel(
      pushNotification: pushNotification ?? this.pushNotification,
      emailNotification: emailNotification ?? this.emailNotification,
      smsNotification: smsNotification ?? this.smsNotification,
      orderUpdates: orderUpdates ?? this.orderUpdates,
      promotionalOffers: promotionalOffers ?? this.promotionalOffers,
      wishlistUpdates: wishlistUpdates ?? this.wishlistUpdates,
      supportUpdates: supportUpdates ?? this.supportUpdates,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    final text = value?.toString().toLowerCase().trim();
    return text == 'true' || text == '1' || text == 'yes';
  }
}
