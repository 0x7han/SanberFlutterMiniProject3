
class Cart {
  final dynamic id;
  final dynamic userId;
  final String date;
  final List<dynamic> products;

  const Cart(
      {this.id = '',
      required this.userId,
      required this.date,
      required this.products});

   factory Cart.fromMap(Map<String, dynamic> data, dynamic documentId) {
    return Cart(
      id: documentId,
      userId: data['userId'] ?? '',
      date: data['date'] ?? '',
      products: data['products'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date,
      'products': products,
    };
  }
}
