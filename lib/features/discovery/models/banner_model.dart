class BannerModel {
  final int id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String? position;
  final String redirectType;
  final int redirectId;
  final String status;

  BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.position,
    required this.redirectType,
    required this.redirectId,
    required this.status,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: _toInt(json['id']),
      title: _toString(json['title']),
      subtitle: _toString(json['subtitle']),
      imageUrl: _toString(json['image_url']),
      position: json['position']?.toString(),
      redirectType: _toString(json['redirect_type']),
      redirectId: _toInt(json['redirect_id']),
      status: _toString(json['status']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _toString(dynamic value) => value?.toString() ?? '';
}
