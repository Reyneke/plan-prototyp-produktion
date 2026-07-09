class Article {
  final int id;
  final String title;
  final String slug;
  final String content;
  final String? excerpt;
  final String? featuredImage;
  final String authorId;
  final String status; // 'draft' | 'published'
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Article({
    required this.id,
    required this.title,
    required this.slug,
    required this.content,
    this.excerpt,
    this.featuredImage,
    required this.authorId,
    required this.status,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      content: json['content'],
      excerpt: json['excerpt'],
      featuredImage: json['featured_image'],
      authorId: json['author_id'],
      status: json['status'],
      publishedAt: json['published_at'] != null ? DateTime.parse(json['published_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'slug': slug,
    'content': content,
    'excerpt': excerpt,
    'featured_image': featuredImage,
    'author_id': authorId,
    'status': status,
    'published_at': publishedAt?.toIso8601String(),
  };
}