class HeroBannerItem {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String ctaText;
  final String targetProductId;
  final bool isActive;
  final int sortOrder;

  const HeroBannerItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.ctaText,
    this.targetProductId = '',
    this.isActive = true,
    this.sortOrder = 0,
  });

  HeroBannerItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imageUrl,
    String? ctaText,
    String? targetProductId,
    bool? isActive,
    int? sortOrder,
  }) {
    return HeroBannerItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      ctaText: ctaText ?? this.ctaText,
      targetProductId: targetProductId ?? this.targetProductId,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'ctaText': ctaText,
      'targetProductId': targetProductId,
      'isActive': isActive,
      'sortOrder': sortOrder,
    };
  }

  factory HeroBannerItem.fromMap(Map<String, dynamic> map) {
    return HeroBannerItem(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      subtitle: (map['subtitle'] ?? '').toString(),
      imageUrl: (map['imageUrl'] ?? '').toString(),
      ctaText: (map['ctaText'] ?? '').toString(),
      targetProductId: (map['targetProductId'] ?? '').toString(),
      isActive: map['isActive'] is bool ? map['isActive'] as bool : true,
      sortOrder: map['sortOrder'] is num
          ? (map['sortOrder'] as num).toInt()
          : int.tryParse((map['sortOrder'] ?? '').toString()) ?? 0,
    );
  }
}
