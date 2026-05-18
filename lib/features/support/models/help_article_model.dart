class HelpArticleModel {
  final int id;
  final String title;
  final String slug;
  final String category;
  final String shortDescription;
  final String content;
  final DateTime? createdAt;

  HelpArticleModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.category,
    required this.shortDescription,
    required this.content,
    this.createdAt,
  });

  factory HelpArticleModel.fromJson(Map<String, dynamic> json) {
    return HelpArticleModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      category: json['category'] ?? '',
      shortDescription: json['short_description'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
