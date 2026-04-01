import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';
import '../models/delivery_zone.dart';
import '../models/category_item.dart';
import '../models/food_item.dart';
import '../models/food_pack.dart';
import '../models/hero_banner_item.dart';
import '../models/store_settings.dart';
import 'mock_store_data.dart';

class StoreController extends ChangeNotifier {
  static final StoreController _instance = StoreController._internal();
  static const String _storeSettingsKey = 'dthc_store_settings';
  static const String _heroBannersKey = 'dthc_hero_banners';
  static const String _productsKey = 'dthc_products';
  static const String _collectionsKey = 'dthc_collections';
  static const String _lookbookEntriesKey = 'dthc_lookbook_entries';
  static const String _deliveryZonesKey = 'dthc_delivery_zones';

  factory StoreController() => _instance;

  StoreController._internal() {
    _loadPersistedData();
  }

  Future<void> _loadPersistedData() async {
    final prefs = await SharedPreferences.getInstance();

    final storeSettingsJson = prefs.getString(_storeSettingsKey);
    if (storeSettingsJson != null && storeSettingsJson.isNotEmpty) {
      MockStoreData.storeSettings = StoreSettings.fromMap(
        Map<String, dynamic>.from(jsonDecode(storeSettingsJson)),
      );
    }

    final heroBannersJson = prefs.getString(_heroBannersKey);
    if (heroBannersJson != null && heroBannersJson.isNotEmpty) {
      final decoded = List<Map<String, dynamic>>.from(
        (jsonDecode(heroBannersJson) as List).map(
          (item) => Map<String, dynamic>.from(item),
        ),
      );
      MockStoreData.heroBanners = decoded
          .map((item) => HeroBannerItem.fromMap(item))
          .toList();
    }

    final productsJson = prefs.getString(_productsKey);
    if (productsJson != null && productsJson.isNotEmpty) {
      final decoded = List<Map<String, dynamic>>.from(
        (jsonDecode(productsJson) as List).map(
          (item) => Map<String, dynamic>.from(item),
        ),
      );
      MockStoreData.foodItems = decoded
          .map((item) => ProductItem.fromMap(item))
          .toList();
    }

    final collectionsJson = prefs.getString(_collectionsKey);
    if (collectionsJson != null && collectionsJson.isNotEmpty) {
      final decoded = List<Map<String, dynamic>>.from(
        (jsonDecode(collectionsJson) as List).map(
          (item) => Map<String, dynamic>.from(item),
        ),
      );
      MockStoreData.collections = decoded
          .map((item) => CollectionModel.fromMap(item))
          .toList();
    }

    final lookbookEntriesJson = prefs.getString(_lookbookEntriesKey);
    if (lookbookEntriesJson != null && lookbookEntriesJson.isNotEmpty) {
      MockStoreData.lookbookEntries = List<Map<String, dynamic>>.from(
        (jsonDecode(lookbookEntriesJson) as List).map(
          (item) => Map<String, dynamic>.from(item),
        ),
      );
    }

    final deliveryZonesJson = prefs.getString(_deliveryZonesKey);
    if (deliveryZonesJson != null && deliveryZonesJson.isNotEmpty) {
      final decoded = List<Map<String, dynamic>>.from(
        (jsonDecode(deliveryZonesJson) as List).map(
          (item) => Map<String, dynamic>.from(item),
        ),
      );
      MockStoreData.deliveryZones = decoded
          .map(
            (item) => DeliveryZone.fromMap(
              (item['id'] ?? '').toString(),
              item,
            ),
          )
          .toList();
    }

    notifyListeners();
  }

  Future<void> _persistData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storeSettingsKey,
      jsonEncode(MockStoreData.storeSettings.toMap()),
    );
    await prefs.setString(
      _heroBannersKey,
      jsonEncode(MockStoreData.heroBanners.map((item) => item.toMap()).toList()),
    );
    await prefs.setString(
      _productsKey,
      jsonEncode(MockStoreData.foodItems.map((item) => item.toMap()).toList()),
    );
    await prefs.setString(
      _collectionsKey,
      jsonEncode(MockStoreData.collections.map((item) => item.toMap()).toList()),
    );
    await prefs.setString(
      _lookbookEntriesKey,
      jsonEncode(MockStoreData.lookbookEntries),
    );
    await prefs.setString(
      _deliveryZonesKey,
      jsonEncode(
        MockStoreData.deliveryZones
            .map(
              (zone) => {
                'id': zone.id,
                ...zone.toMap(),
              },
            )
            .toList(),
      ),
    );
  }

  StoreSettings getStoreSettings() {
    return MockStoreData.storeSettings;
  }

  void updateStoreSettings(StoreSettings settings) {
    MockStoreData.storeSettings = settings;
    _persistData();
    notifyListeners();
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
    _persistData();
    notifyListeners();
  }

  void updateHeroBanner(String id, HeroBannerItem updatedItem) {
    final index = MockStoreData.heroBanners.indexWhere((item) => item.id == id);
    if (index != -1) {
      MockStoreData.heroBanners[index] = updatedItem;
      _persistData();
      notifyListeners();
    }
  }

  void deleteHeroBanner(String id) {
    MockStoreData.heroBanners.removeWhere((item) => item.id == id);
    _persistData();
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
    _persistData();
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
      _persistData();
      notifyListeners();
    }
  }

  void deleteCollection(String id) {
    MockStoreData.collections = MockStoreData.collections
        .where((collection) => collection.id != id)
        .toList();
    _persistData();
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
      _persistData();
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
    List<DeliveryZone> getDeliveryZones() {
    final zones = [...MockStoreData.deliveryZones];
    zones.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return zones;
  }

  DeliveryZone? getDeliveryZoneById(String id) {
    try {
      return MockStoreData.deliveryZones.firstWhere((zone) => zone.id == id);
    } catch (_) {
      return null;
    }
  }

  void addDeliveryZone(DeliveryZone zone) {
    MockStoreData.deliveryZones = [
      ...MockStoreData.deliveryZones,
      zone,
    ];
    _persistData();
    notifyListeners();
  }

  void updateDeliveryZone(String id, DeliveryZone updatedZone) {
    final index = MockStoreData.deliveryZones.indexWhere(
      (zone) => zone.id == id,
    );

    if (index != -1) {
      final updatedList = [...MockStoreData.deliveryZones];
      updatedList[index] = updatedZone;
      MockStoreData.deliveryZones = updatedList;
      _persistData();
      notifyListeners();
    }
  }

  void deleteDeliveryZone(String id) {
    MockStoreData.deliveryZones = MockStoreData.deliveryZones
        .where((zone) => zone.id != id)
        .toList();
    _persistData();
    notifyListeners();
  }
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
    _persistData();
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
      _persistData();
      notifyListeners();
    }
  }

  void deleteLookbookEntry(String id) {
    MockStoreData.lookbookEntries = MockStoreData.lookbookEntries
        .where((entry) => (entry['id'] ?? '').toString() != id)
        .map((entry) => Map<String, dynamic>.from(entry))
        .toList();
    _persistData();
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

  void updateProductItem(String id, ProductItem updatedItem) {
    final index =
        MockStoreData.foodItems.indexWhere((product) => product.id == id);
    if (index != -1) {
      MockStoreData.foodItems[index] = updatedItem;
      _persistData();
      notifyListeners();
    }
  }

  void addProductItem(ProductItem newProduct) {
    MockStoreData.foodItems.add(newProduct);
    _persistData();
    notifyListeners();
  }

  void deleteProductItem(String id) {
    MockStoreData.foodItems.removeWhere((product) => product.id == id);
    _persistData();
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
