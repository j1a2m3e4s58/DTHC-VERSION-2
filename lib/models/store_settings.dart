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
      deliveryFee: deliveryFee ?? this.deliveryFee,
      freeDeliveryThreshold:
          freeDeliveryThreshold ?? this.freeDeliveryThreshold,
      instagram: instagram ?? this.instagram,
      twitter: twitter ?? this.twitter,
      tiktok: tiktok ?? this.tiktok,
    );
  }
}
