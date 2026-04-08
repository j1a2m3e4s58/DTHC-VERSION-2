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
  final String themeMode;
  final String homeSearchTitle;
  final String homeSearchSubtitle;
  final String marketplaceBannerLabel;
  final String marketplaceBannerTitle;
  final String marketplaceBannerSubtitle;
  final String marketplacePrimaryCta;
  final String marketplaceSecondaryCta;
  final String promoSneakersTitle;
  final String promoSneakersSubtitle;
  final String promoSneakersCta;
  final String promoTeesTitle;
  final String promoTeesSubtitle;
  final String promoTeesCta;
  final String promoBestSellersTitle;
  final String promoBestSellersSubtitle;
  final String promoBestSellersCta;
  final String dealsStripLabel;
  final String dealsStripTitle;
  final String dealsStripSubtitle;
  final String dealsPrimaryCta;
  final String dealsSecondaryCta;
  final String dealsCountdownEndsAt;
  final String shopHeaderBadge;
  final String shopSearchTitle;
  final String shopSearchSubtitle;
  final String adminAccessPassword;

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
    required this.themeMode,
    required this.homeSearchTitle,
    required this.homeSearchSubtitle,
    required this.marketplaceBannerLabel,
    required this.marketplaceBannerTitle,
    required this.marketplaceBannerSubtitle,
    required this.marketplacePrimaryCta,
    required this.marketplaceSecondaryCta,
    required this.promoSneakersTitle,
    required this.promoSneakersSubtitle,
    required this.promoSneakersCta,
    required this.promoTeesTitle,
    required this.promoTeesSubtitle,
    required this.promoTeesCta,
    required this.promoBestSellersTitle,
    required this.promoBestSellersSubtitle,
    required this.promoBestSellersCta,
    required this.dealsStripLabel,
    required this.dealsStripTitle,
    required this.dealsStripSubtitle,
    required this.dealsPrimaryCta,
    required this.dealsSecondaryCta,
    required this.dealsCountdownEndsAt,
    required this.shopHeaderBadge,
    required this.shopSearchTitle,
    required this.shopSearchSubtitle,
    required this.adminAccessPassword,
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
    String? themeMode,
    String? homeSearchTitle,
    String? homeSearchSubtitle,
    String? marketplaceBannerLabel,
    String? marketplaceBannerTitle,
    String? marketplaceBannerSubtitle,
    String? marketplacePrimaryCta,
    String? marketplaceSecondaryCta,
    String? promoSneakersTitle,
    String? promoSneakersSubtitle,
    String? promoSneakersCta,
    String? promoTeesTitle,
    String? promoTeesSubtitle,
    String? promoTeesCta,
    String? promoBestSellersTitle,
    String? promoBestSellersSubtitle,
    String? promoBestSellersCta,
    String? dealsStripLabel,
    String? dealsStripTitle,
    String? dealsStripSubtitle,
    String? dealsPrimaryCta,
    String? dealsSecondaryCta,
    String? dealsCountdownEndsAt,
    String? shopHeaderBadge,
    String? shopSearchTitle,
    String? shopSearchSubtitle,
    String? adminAccessPassword,
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
      themeMode: themeMode ?? this.themeMode,
      homeSearchTitle: homeSearchTitle ?? this.homeSearchTitle,
      homeSearchSubtitle: homeSearchSubtitle ?? this.homeSearchSubtitle,
      marketplaceBannerLabel:
          marketplaceBannerLabel ?? this.marketplaceBannerLabel,
      marketplaceBannerTitle:
          marketplaceBannerTitle ?? this.marketplaceBannerTitle,
      marketplaceBannerSubtitle:
          marketplaceBannerSubtitle ?? this.marketplaceBannerSubtitle,
      marketplacePrimaryCta:
          marketplacePrimaryCta ?? this.marketplacePrimaryCta,
      marketplaceSecondaryCta:
          marketplaceSecondaryCta ?? this.marketplaceSecondaryCta,
      promoSneakersTitle: promoSneakersTitle ?? this.promoSneakersTitle,
      promoSneakersSubtitle:
          promoSneakersSubtitle ?? this.promoSneakersSubtitle,
      promoSneakersCta: promoSneakersCta ?? this.promoSneakersCta,
      promoTeesTitle: promoTeesTitle ?? this.promoTeesTitle,
      promoTeesSubtitle: promoTeesSubtitle ?? this.promoTeesSubtitle,
      promoTeesCta: promoTeesCta ?? this.promoTeesCta,
      promoBestSellersTitle:
          promoBestSellersTitle ?? this.promoBestSellersTitle,
      promoBestSellersSubtitle:
          promoBestSellersSubtitle ?? this.promoBestSellersSubtitle,
      promoBestSellersCta:
          promoBestSellersCta ?? this.promoBestSellersCta,
      dealsStripLabel: dealsStripLabel ?? this.dealsStripLabel,
      dealsStripTitle: dealsStripTitle ?? this.dealsStripTitle,
      dealsStripSubtitle: dealsStripSubtitle ?? this.dealsStripSubtitle,
      dealsPrimaryCta: dealsPrimaryCta ?? this.dealsPrimaryCta,
      dealsSecondaryCta: dealsSecondaryCta ?? this.dealsSecondaryCta,
      dealsCountdownEndsAt:
          dealsCountdownEndsAt ?? this.dealsCountdownEndsAt,
      shopHeaderBadge: shopHeaderBadge ?? this.shopHeaderBadge,
      shopSearchTitle: shopSearchTitle ?? this.shopSearchTitle,
      shopSearchSubtitle: shopSearchSubtitle ?? this.shopSearchSubtitle,
      adminAccessPassword: adminAccessPassword ?? this.adminAccessPassword,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      freeDeliveryThreshold:
          freeDeliveryThreshold ?? this.freeDeliveryThreshold,
      instagram: instagram ?? this.instagram,
      twitter: twitter ?? this.twitter,
      tiktok: tiktok ?? this.tiktok,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storeName': storeName,
      'tagline': tagline,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'logoUrl': logoUrl,
      'heroTitle': heroTitle,
      'heroSubtitle': heroSubtitle,
      'announcementText': announcementText,
      'themeMode': themeMode,
      'homeSearchTitle': homeSearchTitle,
      'homeSearchSubtitle': homeSearchSubtitle,
      'marketplaceBannerLabel': marketplaceBannerLabel,
      'marketplaceBannerTitle': marketplaceBannerTitle,
      'marketplaceBannerSubtitle': marketplaceBannerSubtitle,
      'marketplacePrimaryCta': marketplacePrimaryCta,
      'marketplaceSecondaryCta': marketplaceSecondaryCta,
      'promoSneakersTitle': promoSneakersTitle,
      'promoSneakersSubtitle': promoSneakersSubtitle,
      'promoSneakersCta': promoSneakersCta,
      'promoTeesTitle': promoTeesTitle,
      'promoTeesSubtitle': promoTeesSubtitle,
      'promoTeesCta': promoTeesCta,
      'promoBestSellersTitle': promoBestSellersTitle,
      'promoBestSellersSubtitle': promoBestSellersSubtitle,
      'promoBestSellersCta': promoBestSellersCta,
      'dealsStripLabel': dealsStripLabel,
      'dealsStripTitle': dealsStripTitle,
      'dealsStripSubtitle': dealsStripSubtitle,
      'dealsPrimaryCta': dealsPrimaryCta,
      'dealsSecondaryCta': dealsSecondaryCta,
      'dealsCountdownEndsAt': dealsCountdownEndsAt,
      'shopHeaderBadge': shopHeaderBadge,
      'shopSearchTitle': shopSearchTitle,
      'shopSearchSubtitle': shopSearchSubtitle,
      'adminAccessPassword': adminAccessPassword,
      'deliveryFee': deliveryFee,
      'freeDeliveryThreshold': freeDeliveryThreshold,
      'instagram': instagram,
      'twitter': twitter,
      'tiktok': tiktok,
    };
  }

  factory StoreSettings.fromMap(Map<String, dynamic> map) {
    double parseDouble(dynamic value, double fallback) {
      if (value is num) return value.toDouble();
      return double.tryParse((value ?? '').toString()) ?? fallback;
    }

    return StoreSettings(
      storeName: (map['storeName'] ?? '').toString(),
      tagline: (map['tagline'] ?? '').toString(),
      phoneNumber: (map['phoneNumber'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      address: (map['address'] ?? '').toString(),
      logoUrl: (map['logoUrl'] ?? '').toString(),
      heroTitle: (map['heroTitle'] ?? '').toString(),
      heroSubtitle: (map['heroSubtitle'] ?? '').toString(),
      announcementText: (map['announcementText'] ?? '').toString(),
      themeMode: (map['themeMode'] ?? 'light').toString(),
      homeSearchTitle: (map['homeSearchTitle'] ?? '').toString(),
      homeSearchSubtitle: (map['homeSearchSubtitle'] ?? '').toString(),
      marketplaceBannerLabel: (map['marketplaceBannerLabel'] ?? '').toString(),
      marketplaceBannerTitle: (map['marketplaceBannerTitle'] ?? '').toString(),
      marketplaceBannerSubtitle:
          (map['marketplaceBannerSubtitle'] ?? '').toString(),
      marketplacePrimaryCta: (map['marketplacePrimaryCta'] ?? '').toString(),
      marketplaceSecondaryCta:
          (map['marketplaceSecondaryCta'] ?? '').toString(),
      promoSneakersTitle: (map['promoSneakersTitle'] ?? '').toString(),
      promoSneakersSubtitle: (map['promoSneakersSubtitle'] ?? '').toString(),
      promoSneakersCta: (map['promoSneakersCta'] ?? '').toString(),
      promoTeesTitle: (map['promoTeesTitle'] ?? '').toString(),
      promoTeesSubtitle: (map['promoTeesSubtitle'] ?? '').toString(),
      promoTeesCta: (map['promoTeesCta'] ?? '').toString(),
      promoBestSellersTitle:
          (map['promoBestSellersTitle'] ?? '').toString(),
      promoBestSellersSubtitle:
          (map['promoBestSellersSubtitle'] ?? '').toString(),
      promoBestSellersCta: (map['promoBestSellersCta'] ?? '').toString(),
      dealsStripLabel: (map['dealsStripLabel'] ?? '').toString(),
      dealsStripTitle: (map['dealsStripTitle'] ?? '').toString(),
      dealsStripSubtitle: (map['dealsStripSubtitle'] ?? '').toString(),
      dealsPrimaryCta: (map['dealsPrimaryCta'] ?? '').toString(),
      dealsSecondaryCta: (map['dealsSecondaryCta'] ?? '').toString(),
      dealsCountdownEndsAt: (map['dealsCountdownEndsAt'] ?? '').toString(),
      shopHeaderBadge: (map['shopHeaderBadge'] ?? '').toString(),
      shopSearchTitle: (map['shopSearchTitle'] ?? '').toString(),
      shopSearchSubtitle: (map['shopSearchSubtitle'] ?? '').toString(),
      adminAccessPassword:
          (map['adminAccessPassword'] ?? 'T4N4AMEG8F5').toString(),
      deliveryFee: parseDouble(map['deliveryFee'], 0),
      freeDeliveryThreshold: parseDouble(map['freeDeliveryThreshold'], 0),
      instagram: (map['instagram'] ?? '').toString(),
      twitter: (map['twitter'] ?? '').toString(),
      tiktok: (map['tiktok'] ?? '').toString(),
    );
  }
}
