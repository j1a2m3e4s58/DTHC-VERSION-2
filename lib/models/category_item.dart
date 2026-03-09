class CategoryItem {
  final String id;
  final String name;
  final String icon;
  final bool isActive;
  final int sortOrder;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.isActive,
    required this.sortOrder,
  });

  CategoryItem copyWith({
    String? id,
    String? name,
    String? icon,
    bool? isActive,
    int? sortOrder,
  }) {
    return CategoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}