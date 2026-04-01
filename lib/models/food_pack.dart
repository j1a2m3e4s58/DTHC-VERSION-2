class CollectionModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final bool isFeatured;

  const CollectionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.isFeatured,
  });

  CollectionModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    bool? isFeatured,
  }) {
    return CollectionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}