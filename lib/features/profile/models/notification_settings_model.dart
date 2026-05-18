class NotificationSettingsModel {
  final bool pushNotification;
  final bool emailNotification;
  final bool smsNotification;
  final bool orderUpdates;
  final bool promotionalOffers;
  final bool wishlistUpdates;
  final bool supportUpdates;
  final DateTime? updatedAt;

  NotificationSettingsModel({
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
      pushNotification: json['push_notification'] ?? false,
      emailNotification: json['email_notification'] ?? false,
      smsNotification: json['sms_notification'] ?? false,
      orderUpdates: json['order_updates'] ?? false,
      promotionalOffers: json['promotional_offers'] ?? false,
      wishlistUpdates: json['wishlist_updates'] ?? false,
      supportUpdates: json['support_updates'] ?? false,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

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
}
