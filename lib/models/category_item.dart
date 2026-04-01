class CategoryItem {
  final String id;
  final String name;
  final String icon;
  final String imageUrl;
  final bool isActive;
  final int sortOrder;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.imageUrl,
    required this.isActive,
    required this.sortOrder,
  });

  CategoryItem copyWith({
    String? id,
    String? name,
    String? icon,
    String? imageUrl,
    bool? isActive,
    int? sortOrder,
  }) {
    return CategoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}