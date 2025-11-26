class Product {
  final String id;
  final String name;
  final String imageUrl; // URL to product image, baka gawing local path later
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

  // For if NLP uses shopping API to get product data, palitan pag may list na ng products (i think!!)
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
