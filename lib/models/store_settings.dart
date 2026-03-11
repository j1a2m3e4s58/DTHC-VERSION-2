class StoreSettings {
  final String storeName;
  final String tagline;
  final String phoneNumber;
  final String email;
  final String address;

  final String logoUrl;

  final String heroTitle;
  final String heroSubtitle;

  final String announcementText;

  final double deliveryFee;
  final double freeDeliveryThreshold;

  final String instagram;
  final String twitter;
  final String tiktok;

  const StoreSettings({
    required this.storeName,
    required this.tagline,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.logoUrl,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.announcementText,
    required this.deliveryFee,
    required this.freeDeliveryThreshold,
    required this.instagram,
    required this.twitter,
    required this.tiktok,
  });

  StoreSettings copyWith({
    String? storeName,
    String? tagline,
    String? phoneNumber,
    String? email,
    String? address,
    String? logoUrl,
    String? heroTitle,
    String? heroSubtitle,
    String? announcementText,
    double? deliveryFee,
    double? freeDeliveryThreshold,
    String? instagram,
    String? twitter,
    String? tiktok,
  }) {
    return StoreSettings(
      storeName: storeName ?? this.storeName,
      tagline: tagline ?? this.tagline,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      logoUrl: logoUrl ?? this.logoUrl,
      heroTitle: heroTitle ?? this.heroTitle,
      heroSubtitle: heroSubtitle ?? this.heroSubtitle,
      announcementText: announcementText ?? this.announcementText,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      freeDeliveryThreshold:
          freeDeliveryThreshold ?? this.freeDeliveryThreshold,
      instagram: instagram ?? this.instagram,
      twitter: twitter ?? this.twitter,
      tiktok: tiktok ?? this.tiktok,
    );
  }
}