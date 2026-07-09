class Category {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final int sortOrder;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.sortOrder,
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      sortOrder: json['sort_order'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}