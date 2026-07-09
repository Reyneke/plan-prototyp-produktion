class Product {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final double? comparePrice;
  final String? imageUrl;
  final int? categoryId;
  final bool isAvailable;
  final bool isFeatured;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    this.comparePrice,
    this.imageUrl,
    this.categoryId,
    required this.isAvailable,
    required this.isFeatured,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      comparePrice: json['compare_price'] != null ? (json['compare_price'] as num).toDouble() : null,
      imageUrl: json['image_url'],
      categoryId: json['category_id'],
      isAvailable: json['is_available'] ?? true,
      isFeatured: json['is_featured'] ?? false,
      sortOrder: json['sort_order'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'slug': slug,
    'description': description,
    'price': price,
    'compare_price': comparePrice,
    'image_url': imageUrl,
    'category_id': categoryId,
    'is_available': isAvailable,
    'is_featured': isFeatured,
    'sort_order': sortOrder,
  };

  String get formattedPrice => '${price.toStringAsFixed(2).replaceAll('.', ',')} €';
  String? get formattedComparePrice => comparePrice != null
      ? '${comparePrice!.toStringAsFixed(2).replaceAll('.', ',')} €'
      : null;
}