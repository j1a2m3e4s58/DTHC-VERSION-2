import 'package:flutter/foundation.dart';

import '../models/category_item.dart';
import '../models/food_item.dart';
import '../models/store_settings.dart';
import 'mock_store_data.dart';

class StoreController extends ChangeNotifier {
  static final StoreController _instance = StoreController._internal();

  factory StoreController() => _instance;

  StoreController._internal();

  StoreSettings getStoreSettings() {
    return MockStoreData.storeSettings;
  }

  List<CategoryItem> getCategories() {
    final items = [...MockStoreData.categories];
    items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return items.where((category) => category.isActive).toList();
  }

  List<FoodItem> getAllFoods() {
    return [...MockStoreData.foodItems];
  }

  List<FoodItem> getAvailableFoods() {
    return MockStoreData.foodItems
        .where((food) => food.isAvailable && food.stockQuantity > 0)
        .toList();
  }

  List<FoodItem> getFoods() {
    return getAvailableFoods();
  }

  List<FoodItem> getFeaturedFoods() {
    return MockStoreData.foodItems
        .where(
          (food) =>
              food.isFeatured &&
              food.isAvailable &&
              food.stockQuantity > 0,
        )
        .toList();
  }

  static const List<String> menuCategories = [
    'All Items',
    'Rice Meals',
    'Snacks',
    'Drinks',
    'Special Packs',
    'Bakery',
  ];

  List<FoodItem> getFoodsByCategory(String categoryName) {
    if (categoryName == 'All Items') {
      return getAvailableFoods();
    }

    return MockStoreData.foodItems
        .where(
          (food) =>
              food.isAvailable &&
              food.stockQuantity > 0 &&
              food.category.trim().toLowerCase() ==
                  categoryName.trim().toLowerCase(),
        )
        .toList();
  }

  void updateStoreSettings(StoreSettings newSettings) {
    MockStoreData.storeSettings = newSettings;
    notifyListeners();
  }

  void updateFoodItem(String id, FoodItem updatedItem) {
    final index = MockStoreData.foodItems.indexWhere((food) => food.id == id);
    if (index != -1) {
      MockStoreData.foodItems[index] = updatedItem;
      notifyListeners();
    }
  }

  void addFoodItem(FoodItem newFood) {
    MockStoreData.foodItems.add(newFood);
    notifyListeners();
  }

  void deleteFoodItem(String id) {
    MockStoreData.foodItems.removeWhere((food) => food.id == id);
    notifyListeners();
  }
}