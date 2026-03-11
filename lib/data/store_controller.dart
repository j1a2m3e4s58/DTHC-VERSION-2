import 'package:flutter/foundation.dart';

import '../models/category_item.dart';
import '../models/food_item.dart';
import '../models/food_pack.dart';
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

  List<ProductItem> getAllProducts() {
    return [...MockStoreData.foodItems];
  }

  List<ProductItem> getAvailableProducts() {
    return MockStoreData.foodItems
        .where(
          (product) =>
              product.isAvailable &&
              product.stockQuantity > 0 &&
              product.imageUrls.isNotEmpty,
        )
        .toList();
  }

  List<ProductItem> getProducts() {
    return getAvailableProducts();
  }

  List<ProductItem> getFeaturedProducts() {
    return MockStoreData.foodItems
        .where(
          (product) =>
              product.isFeatured &&
              product.isAvailable &&
              product.stockQuantity > 0 &&
              product.imageUrls.isNotEmpty,
        )
        .toList();
  }

  List<ProductItem> getNewArrivals() {
    return MockStoreData.foodItems
        .where(
          (product) =>
              product.isNewArrival &&
              product.isAvailable &&
              product.stockQuantity > 0 &&
              product.imageUrls.isNotEmpty,
        )
        .toList();
  }

  List<ProductItem> getBestSellers() {
    return MockStoreData.foodItems
        .where(
          (product) =>
              product.isBestSeller &&
              product.isAvailable &&
              product.stockQuantity > 0 &&
              product.imageUrls.isNotEmpty,
        )
        .toList();
  }

  List<CollectionModel> getCollections() {
    return [...MockStoreData.collections];
  }

  List<CollectionModel> getFeaturedCollections() {
    return MockStoreData.collections
        .where((collection) => collection.isFeatured)
        .toList();
  }

  static const List<String> shopCategories = [
    'All',
    'Tees',
    'Sneakers',
    'Caps',
    'Chains',
    'Belts',
    'Socks',
  ];

  List<ProductItem> getProductsByCategory(String categoryName) {
    if (categoryName == 'All') {
      return getAvailableProducts();
    }

    return MockStoreData.foodItems
        .where(
          (product) =>
              product.isAvailable &&
              product.stockQuantity > 0 &&
              product.imageUrls.isNotEmpty &&
              product.category.trim().toLowerCase() ==
                  categoryName.trim().toLowerCase(),
        )
        .toList();
  }

  List<ProductItem> getProductsByCollection(String collectionName) {
    return MockStoreData.foodItems
        .where(
          (product) =>
              product.isAvailable &&
              product.stockQuantity > 0 &&
              product.imageUrls.isNotEmpty &&
              product.collection.trim().toLowerCase() ==
                  collectionName.trim().toLowerCase(),
        )
        .toList();
  }

  List<Map<String, dynamic>> getLookbookEntries() {
    return List<Map<String, dynamic>>.from(MockStoreData.lookbookEntries);
  }

  List<Map<String, dynamic>> getPaymentMethods() {
    return List<Map<String, dynamic>>.from(MockStoreData.paymentMethods);
  }

  List<Map<String, dynamic>> getDeliverySteps() {
    return List<Map<String, dynamic>>.from(MockStoreData.deliverySteps);
  }

  List<Map<String, dynamic>> getReturnExchangeNotes() {
    return List<Map<String, dynamic>>.from(MockStoreData.returnExchangeNotes);
  }

  List<Map<String, dynamic>> getContactChannels() {
    return List<Map<String, dynamic>>.from(MockStoreData.contactChannels);
  }

  void updateStoreSettings(StoreSettings newSettings) {
    MockStoreData.storeSettings = newSettings;
    notifyListeners();
  }

  void updateProductItem(String id, ProductItem updatedItem) {
    final index =
        MockStoreData.foodItems.indexWhere((product) => product.id == id);
    if (index != -1) {
      MockStoreData.foodItems[index] = updatedItem;
      notifyListeners();
    }
  }

  void addProductItem(ProductItem newProduct) {
    MockStoreData.foodItems.add(newProduct);
    notifyListeners();
  }

  void deleteProductItem(String id) {
    MockStoreData.foodItems.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  // Legacy compatibility wrappers
  List<FoodItem> getAllFoods() => getAllProducts();
  List<FoodItem> getAvailableFoods() => getAvailableProducts();
  List<FoodItem> getFoods() => getProducts();
  List<FoodItem> getFeaturedFoods() => getFeaturedProducts();

  static const List<String> menuCategories = [
    'All',
    'Tees',
    'Sneakers',
    'Caps',
    'Chains',
    'Belts',
    'Socks',
  ];

  List<FoodItem> getFoodsByCategory(String categoryName) =>
      getProductsByCategory(categoryName);

  void updateFoodItem(String id, FoodItem updatedItem) =>
      updateProductItem(id, updatedItem);

  void addFoodItem(FoodItem newFood) => addProductItem(newFood);

  void deleteFoodItem(String id) => deleteProductItem(id);
}