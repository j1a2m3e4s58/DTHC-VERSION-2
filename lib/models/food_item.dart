class ProductItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> imageUrls;
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
    required this.imageUrls,
    required this.isAvailable,
    required this.isFeatured,
    required this.stockQuantity,
    this.collection = 'General Collection',
    this.isNewArrival = false,
    this.isBestSeller = false,
  });

  String get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  ProductItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? imageUrls,
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
      imageUrls: imageUrls ?? this.imageUrls,
      isAvailable: isAvailable ?? this.isAvailable,
      isFeatured: isFeatured ?? this.isFeatured,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      collection: collection ?? this.collection,
      isNewArrival: isNewArrival ?? this.isNewArrival,
      isBestSeller: isBestSeller ?? this.isBestSeller,
    );
  }
}

typedef FoodItem = ProductItem;