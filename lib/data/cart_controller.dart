import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/delivery_zone.dart';
import '../models/food_item.dart';

class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];
  DeliveryZone? _selectedDeliveryZone;

  List<CartItem> get items => List.unmodifiable(_items);

  DeliveryZone? get selectedDeliveryZone => _selectedDeliveryZone;

  String get selectedDeliveryZoneName =>
      _selectedDeliveryZone?.name ?? '';

  double get selectedDeliveryFee =>
      _selectedDeliveryZone?.fee ?? 0;

  bool get hasSelectedDeliveryZone => _selectedDeliveryZone != null;

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

  String get deliveryFeeLabel {
    if (_items.isEmpty) return '—';

    if (_selectedDeliveryZone == null) {
      return 'Select at checkout';
    }

    return 'GHS ${_selectedDeliveryZone!.fee.toStringAsFixed(2)}';
  }

  String get deliveryNote {
    if (_items.isEmpty) {
      return 'Delivery cost depends on your selected zone.';
    }

    if (_selectedDeliveryZone == null) {
      return 'Select your delivery zone at checkout to calculate the final delivery fee.';
    }

    return 'Delivery zone: ${_selectedDeliveryZone!.name}';
  }

  double get estimatedTotal => subtotal + selectedDeliveryFee;

  bool get isEmpty => _items.isEmpty;

  void selectDeliveryZone(DeliveryZone zone) {
    _selectedDeliveryZone = zone;
    notifyListeners();
  }

  void clearSelectedDeliveryZone() {
    _selectedDeliveryZone = null;
    notifyListeners();
  }

  void addToCart(ProductItem product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _items[index].product = product;
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
    _selectedDeliveryZone = null;
    notifyListeners();
  }
}
