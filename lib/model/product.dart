class Product {
  final dynamic id;
  final String title;
  final num price;
  final String description;
  final String category;
  final String image;
  final Map<String, dynamic> rating;

  const Product({
    this.id = '',
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromMap(Map<String, dynamic> data, dynamic documentId) {
    return Product(
      id: documentId,
      title: data['title'] ?? '',
      price: data['price'] ?? 0,
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      image: data['image'] ?? '',
      rating: data['rating'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating,
    };
  }
}
