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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'isFeatured': isFeatured,
    };
  }

  factory CollectionModel.fromMap(Map<String, dynamic> map) {
    return CollectionModel(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      imageUrl: (map['imageUrl'] ?? '').toString(),
      isFeatured: map['isFeatured'] is bool ? map['isFeatured'] as bool : false,
    );
  }
}
