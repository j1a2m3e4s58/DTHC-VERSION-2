class OrderItem {
  final String foodId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  const OrderItem({
    required this.foodId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory OrderItem.fromMap(Map<dynamic, dynamic> map) {
    return OrderItem(
      foodId: (map['foodId'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      price: (map['price'] ?? 0).toDouble(),
      quantity: (map['quantity'] ?? 0) as int,
      imageUrl: (map['imageUrl'] ?? '').toString(),
    );
  }
}