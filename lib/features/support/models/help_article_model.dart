class HelpArticleModel {
  final int id;
  final String title;
  final String slug;
  final String category;
  final String shortDescription;
  final String content;
  final DateTime? createdAt;

  const HelpArticleModel({
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
      id: _toInt(json['id']),
      title: _toStringValue(json['title']),
      slug: _toStringValue(json['slug']),
      category: _toStringValue(json['category']),
      shortDescription: _toStringValue(
        json['short_description'] ?? json['shortDescription'] ?? json['summary'],
      ),
      content: _toStringValue(json['content'] ?? json['body']),
      createdAt: _toDate(json['created_at'] ?? json['createdAt']),
    );
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String _toStringValue(dynamic value) => value?.toString() ?? '';

DateTime? _toDate(dynamic value) {
  if (value is DateTime) return value;
  if (value is String && value.trim().isNotEmpty) return DateTime.tryParse(value);
  return null;
}
