class Product {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> tags;
  final String? description;
  final String? shopUrl;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tags,
    this.description,
    this.shopUrl,
    this.category = 'Other',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Defensive parsing for tags (can be list, string, or missing)
    List<String> parsedTags = [];
    final rawTags = json['tags'];

    if (rawTags is List) {
      parsedTags = rawTags.map((e) => e.toString()).toList();
    } else if (rawTags is String) {
      parsedTags = rawTags
          .split(RegExp(r'[;,]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    // Category: default to 'Other' if missing or empty
    String rawCategory = (json['category'] ?? '').toString().trim();
    String safeCategory = rawCategory.isEmpty ? 'Other' : rawCategory;

    // Image URL: backend uses 'product_image'
    String rawImage = (json['product_image'] ?? '').toString().trim();
    String safeImageUrl = rawImage.isNotEmpty
        ? rawImage
        : 'https://via.placeholder.com/164x195';

    return Product(
      // Use a fallback ID if none exists
      id: json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: (json['name'] ?? 'Unknown Product').toString(),
      imageUrl: safeImageUrl,
      tags: parsedTags,
      description: json['description']?.toString(),
      shopUrl: json['product_url']?.toString(),
      category: safeCategory,
    );
  }
}