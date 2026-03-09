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
      _items.isEmpty ? '—' : 'To be confirmed';

  String get deliveryNote =>
      'Delivery fee will be confirmed by the store based on your location.';

  double get estimatedTotal => subtotal;

  bool get isEmpty => _items.isEmpty;

  void addToCart(FoodItem food) {
    final index = _items.indexWhere((item) => item.food.id == food.id);

    if (index != -1) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(food: food));
    }

    notifyListeners();
  }

  void decreaseQuantity(String foodId) {
    final index = _items.indexWhere((item) => item.food.id == foodId);

    if (index == -1) return;

    if (_items[index].quantity > 1) {
      _items[index].quantity -= 1;
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }

  void increaseQuantity(String foodId) {
    final index = _items.indexWhere((item) => item.food.id == foodId);

    if (index == -1) return;

    _items[index].quantity += 1;
    notifyListeners();
  }

  void removeFromCart(String foodId) {
    _items.removeWhere((item) => item.food.id == foodId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}