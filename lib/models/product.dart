class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final String image;
  final double rating;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.rating,
    required this.description,
  });

  // JSON -> Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      description: json['description'] as String? ?? '',
    );
  }

  // Product -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'image': image,
      'rating': rating,
      'description': description,
    };
  }

  String get formattedPrice => '${price.toStringAsFixed(2).replaceAll('.', ',')} ₺';
}
