class CategoryModel {
  final int id;
  final int? parentId;
  final String name;
  final String slug;
  final String description;
  final String imageUrl;
  final String? bannerUrl;
  final String status;
  final List<CategoryModel> children;

  CategoryModel({
    required this.id,
    this.parentId,
    required this.name,
    required this.slug,
    required this.description,
    required this.imageUrl,
    this.bannerUrl,
    required this.status,
    required this.children,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final childrenJson = json['children'];

    return CategoryModel(
      id: _toInt(json['id']),
      parentId: json['parent_id'] == null ? null : _toInt(json['parent_id']),
      name: _toString(json['name']),
      slug: _toString(json['slug']),
      description: _toString(json['description']),
      imageUrl: _toString(json['image_url']),
      bannerUrl: json['banner_url']?.toString(),
      status: _toString(json['status']),
      children: childrenJson is List
          ? childrenJson
                .whereType<Map<String, dynamic>>()
                .map(CategoryModel.fromJson)
                .toList()
          : [],
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _toString(dynamic value) => value?.toString() ?? '';
}
