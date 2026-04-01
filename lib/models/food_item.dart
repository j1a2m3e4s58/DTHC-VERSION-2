class ProductImageEntry {
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final double? oldPrice;

  const ProductImageEntry({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    this.oldPrice,
  });

  bool get hasDiscount => oldPrice != null && oldPrice! > price;

  int get discountPercent {
    if (!hasDiscount) return 0;
    return (((oldPrice! - price) / oldPrice!) * 100).round();
  }

  ProductImageEntry copyWith({
    String? imageUrl,
    String? title,
    String? description,
    double? price,
    double? oldPrice,
  }) {
    return ProductImageEntry(
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'price': price,
      'oldPrice': oldPrice,
    };
  }

  factory ProductImageEntry.fromMap(Map<dynamic, dynamic> map) {
    return ProductImageEntry(
      imageUrl: (map['imageUrl'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      price: (map['price'] ?? 0).toDouble(),
      oldPrice: map['oldPrice'] == null
          ? null
          : (map['oldPrice'] is num
              ? (map['oldPrice'] as num).toDouble()
              : double.tryParse(map['oldPrice'].toString())),
    );
  }
}

class ProductItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<ProductImageEntry> imageEntries;
  final double? oldPrice;
  final String dealLabel;
  final String dealEndsAt;
  final bool isAvailable;
  final bool isFeatured;
  final int stockQuantity;
  final String collection;
  final bool isNewArrival;
  final bool isBestSeller;

  const ProductItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageEntries,
    this.oldPrice,
    this.dealLabel = '',
    this.dealEndsAt = '',
    required this.isAvailable,
    required this.isFeatured,
    required this.stockQuantity,
    this.collection = 'General Collection',
    this.isNewArrival = false,
    this.isBestSeller = false,
  });

  List<String> get imageUrls => imageEntries
      .map((entry) => entry.imageUrl.trim())
      .where((url) => url.isNotEmpty)
      .toList();

  String get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  bool get hasDiscount => oldPrice != null && oldPrice! > price;

  int get discountPercent {
    if (!hasDiscount) return 0;
    return (((oldPrice! - price) / oldPrice!) * 100).round();
  }

  ProductImageEntry get primaryImageEntry {
    if (imageEntries.isNotEmpty) {
      return imageEntries.first;
    }

    return ProductImageEntry(
      imageUrl: '',
      title: name,
      description: description,
      price: price,
      oldPrice: oldPrice,
    );
  }

  ProductImageEntry imageEntryAt(int index) {
    if (imageEntries.isEmpty) {
      return primaryImageEntry;
    }

    final safeIndex = index.clamp(0, imageEntries.length - 1);
    return imageEntries[safeIndex];
  }

  ProductItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    List<ProductImageEntry>? imageEntries,
    double? oldPrice,
    String? dealLabel,
    String? dealEndsAt,
    bool? isAvailable,
    bool? isFeatured,
    int? stockQuantity,
    String? collection,
    bool? isNewArrival,
    bool? isBestSeller,
  }) {
    return ProductItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageEntries: imageEntries ?? this.imageEntries,
      oldPrice: oldPrice ?? this.oldPrice,
      dealLabel: dealLabel ?? this.dealLabel,
      dealEndsAt: dealEndsAt ?? this.dealEndsAt,
      isAvailable: isAvailable ?? this.isAvailable,
      isFeatured: isFeatured ?? this.isFeatured,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      collection: collection ?? this.collection,
      isNewArrival: isNewArrival ?? this.isNewArrival,
      isBestSeller: isBestSeller ?? this.isBestSeller,
    );
  }

  ProductItem withPrimaryImageAt(int index) {
    if (imageEntries.isEmpty) {
      return this;
    }

    final safeIndex = index.clamp(0, imageEntries.length - 1);
    final selectedEntry = imageEntries[safeIndex];
    final reorderedEntries = [
      selectedEntry,
      ...imageEntries.asMap().entries
          .where((entry) => entry.key != safeIndex)
          .map((entry) => entry.value),
    ];

    return copyWith(
      name: selectedEntry.title,
      description: selectedEntry.description,
      price: selectedEntry.price,
      oldPrice: selectedEntry.oldPrice,
      imageEntries: reorderedEntries,
    );
  }
}

typedef FoodItem = ProductItem;
