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
      id: json['id'] ?? 0,
      parentId: json['parent_id'],
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      bannerUrl: json['banner_url'],
      status: json['status'] ?? '',
      children: childrenJson is List
          ? childrenJson.map((item) => CategoryModel.fromJson(item)).toList()
          : [],
    );
  }
}
