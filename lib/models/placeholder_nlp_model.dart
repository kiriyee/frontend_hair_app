class Product {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> tags;
  final String? description;
  final String? shopUrl;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tags,
    this.description,
    this.shopUrl,
  });

  // For when NLP is integrated ?? not rly sure
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      tags: List<String>.from(json['tags']),
      description: json['description'],
      shopUrl: json['shopUrl'],
    );
  }
}
