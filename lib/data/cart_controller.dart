import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/food_item.dart';

class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItemsCount {
    int total = 0;
    for (final item in _items) {
      total += item.quantity;
    }
    return total;
  }

  double get subtotal {
    double total = 0;
    for (final item in _items) {
      total += item.totalPrice;
    }
    return total;
  }

  String get deliveryFeeLabel =>
      _items.isEmpty ? '—' : 'Calculated at checkout';

  String get deliveryNote =>
      'Delivery cost depends on your location in Ghana and order size.';

  double get estimatedTotal => subtotal;

  bool get isEmpty => _items.isEmpty;

  void addToCart(ProductItem product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(product: product));
    }

    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);

    if (index == -1) return;

    if (_items[index].quantity > 1) {
      _items[index].quantity -= 1;
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }

  void increaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);

    if (index == -1) return;

    _items[index].quantity += 1;
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}