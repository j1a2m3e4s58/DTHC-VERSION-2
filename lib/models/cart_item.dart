import 'food_item.dart';

class CartItem {
  final ProductItem product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  ProductItem get food => product;

  double get totalPrice => product.price * quantity;
}