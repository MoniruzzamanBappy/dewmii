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
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      imageUrl: json['image_url'] ?? '',
      position: json['position'],
      redirectType: json['redirect_type'] ?? '',
      redirectId: json['redirect_id'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}
