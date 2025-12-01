class Product {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> tags;
  final String? description;
  final String? shopUrl;
  final String category; // Added this field

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tags,
    this.description,
    this.shopUrl,
    this.category = 'Other', // Default value
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // Use a fallback ID if none exists
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? 'Unknown Product',
      // MAP PYTHON KEYS TO FLUTTER FIELDS HERE:
      imageUrl: json['product_image'] != null && json['product_image'] != "" 
          ? json['product_image'] 
          : 'https://via.placeholder.com/164x195',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      description: json['description'],
      shopUrl: json['product_url'], 
      category: json['category'] ?? 'Other',
    );
  }
}