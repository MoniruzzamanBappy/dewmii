class AdminCategoryModel {
  final int id;
  final int? parentId;
  final String name;
  final String slug;
  final String description;
  final String imageUrl;
  final String status;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AdminCategoryModel({
    required this.id,
    this.parentId,
    required this.name,
    required this.slug,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminCategoryModel.fromJson(Map<String, dynamic> json) {
    return AdminCategoryModel(
      id: _toInt(json['id']),
      parentId: _toNullableInt(json['parent_id']),
      name: _toStringValue(json['name']),
      slug: _toStringValue(json['slug']),
      description: _toStringValue(json['description']),
      imageUrl: _toStringValue(json['image_url'] ?? json['imageUrl']),
      status: _toStringValue(json['status'], fallback: 'active'),
      sortOrder: _toInt(json['sort_order'] ?? json['sortOrder'], fallback: 1),
      createdAt: _toDate(json['created_at'] ?? json['createdAt']),
      updatedAt: _toDate(json['updated_at'] ?? json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'name': name,
      'slug': slug,
      'description': description,
      'image_url': imageUrl,
      'status': status,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  bool get isActive => status.toLowerCase() == 'active';

  AdminCategoryModel copyWith({
    int? id,
    int? parentId,
    String? name,
    String? slug,
    String? description,
    String? imageUrl,
    String? status,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminCategoryModel(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static int? _toNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static String _toStringValue(dynamic value, {String fallback = ''}) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? fallback : text;
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
