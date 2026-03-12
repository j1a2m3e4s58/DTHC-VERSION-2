import 'package:flutter/foundation.dart';

import '../models/category_item.dart';
import '../models/food_item.dart';
import '../models/food_pack.dart';
import '../models/hero_banner_item.dart';
import '../models/store_settings.dart';
import 'mock_store_data.dart';

class StoreController extends ChangeNotifier {
  static final StoreController _instance = StoreController._internal();

  factory StoreController() => _instance;

  StoreController._internal();

  StoreSettings getStoreSettings() {
    return MockStoreData.storeSettings;
  }

  List<HeroBannerItem> getHeroBanners() {
    final items = [...MockStoreData.heroBanners];
    items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return items.where((item) => item.isActive).toList();
  }

  List<HeroBannerItem> getAllHeroBanners() {
    final items = [...MockStoreData.heroBanners];
    items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return items;
  }

  HeroBannerItem? getHeroBannerById(String id) {
    try {
      return MockStoreData.heroBanners.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  void addHeroBanner(HeroBannerItem item) {
    MockStoreData.heroBanners.add(item);
    notifyListeners();
  }

  void updateHeroBanner(String id, HeroBannerItem updatedItem) {
    final index = MockStoreData.heroBanners.indexWhere((item) => item.id == id);
    if (index != -1) {
      MockStoreData.heroBanners[index] = updatedItem;
      notifyListeners();
    }
  }

  void deleteHeroBanner(String id) {
    MockStoreData.heroBanners.removeWhere((item) => item.id == id);
    notifyListeners();
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

  ProductItem? getProductById(String id) {
    try {
      return MockStoreData.foodItems.firstWhere((product) => product.id == id);
    } catch (_) {
      return null;
    }
  }

  List<CollectionModel> getCollections() {
    return [...MockStoreData.collections];
  }

  List<CollectionModel> getFeaturedCollections() {
    return MockStoreData.collections
        .where((collection) => collection.isFeatured)
        .toList();
  }

  CollectionModel? getCollectionById(String id) {
    try {
      return MockStoreData.collections.firstWhere(
        (collection) => collection.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  void addCollection(CollectionModel collection) {
    MockStoreData.collections = [
      ...MockStoreData.collections,
      collection,
    ];
    notifyListeners();
  }

  void updateCollection(String id, CollectionModel updatedCollection) {
    final index = MockStoreData.collections.indexWhere(
      (collection) => collection.id == id,
    );

    if (index != -1) {
      final updatedList = [...MockStoreData.collections];
      updatedList[index] = updatedCollection;
      MockStoreData.collections = updatedList;
      notifyListeners();
    }
  }

  void deleteCollection(String id) {
    MockStoreData.collections = MockStoreData.collections
        .where((collection) => collection.id != id)
        .toList();
    notifyListeners();
  }

  void toggleCollectionFeatured(String id) {
    final index = MockStoreData.collections.indexWhere(
      (collection) => collection.id == id,
    );

    if (index != -1) {
      final current = MockStoreData.collections[index];
      final updatedList = [...MockStoreData.collections];
      updatedList[index] = CollectionModel(
        id: current.id,
        name: current.name,
        description: current.description,
        imageUrl: current.imageUrl,
        isFeatured: !current.isFeatured,
      );
      MockStoreData.collections = updatedList;
      notifyListeners();
    }
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

  static const List<String> lookbookTargetTypes = [
    'collection',
    'category',
    'product',
    'none',
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
    return MockStoreData.lookbookEntries
        .map((entry) => Map<String, dynamic>.from(entry))
        .toList();
  }

  Map<String, dynamic>? getLookbookEntryById(String id) {
    try {
      final entry = MockStoreData.lookbookEntries.firstWhere(
        (item) => (item['id'] ?? '').toString() == id,
      );
      return Map<String, dynamic>.from(entry);
    } catch (_) {
      return null;
    }
  }

  void addLookbookEntry(Map<String, dynamic> entry) {
    MockStoreData.lookbookEntries = [
      ...MockStoreData.lookbookEntries,
      {
        'id': (entry['id'] ?? '').toString(),
        'title': (entry['title'] ?? '').toString(),
        'subtitle': (entry['subtitle'] ?? '').toString(),
        'imageUrl': (entry['imageUrl'] ?? '').toString(),
        'tag': (entry['tag'] ?? '').toString(),
        'ctaText': (entry['ctaText'] ?? '').toString(),
        'targetType': (entry['targetType'] ?? 'none').toString(),
        'targetValue': (entry['targetValue'] ?? '').toString(),
      },
    ];
    notifyListeners();
  }

  void updateLookbookEntry(String id, Map<String, dynamic> updatedEntry) {
    final index = MockStoreData.lookbookEntries.indexWhere(
      (entry) => (entry['id'] ?? '').toString() == id,
    );

    if (index != -1) {
      final updatedList = MockStoreData.lookbookEntries
          .map((entry) => Map<String, dynamic>.from(entry))
          .toList();

      updatedList[index] = {
        'id': id,
        'title': (updatedEntry['title'] ?? '').toString(),
        'subtitle': (updatedEntry['subtitle'] ?? '').toString(),
        'imageUrl': (updatedEntry['imageUrl'] ?? '').toString(),
        'tag': (updatedEntry['tag'] ?? '').toString(),
        'ctaText': (updatedEntry['ctaText'] ?? '').toString(),
        'targetType': (updatedEntry['targetType'] ?? 'none').toString(),
        'targetValue': (updatedEntry['targetValue'] ?? '').toString(),
      };

      MockStoreData.lookbookEntries = updatedList;
      notifyListeners();
    }
  }

  void deleteLookbookEntry(String id) {
    MockStoreData.lookbookEntries = MockStoreData.lookbookEntries
        .where((entry) => (entry['id'] ?? '').toString() != id)
        .map((entry) => Map<String, dynamic>.from(entry))
        .toList();
    notifyListeners();
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