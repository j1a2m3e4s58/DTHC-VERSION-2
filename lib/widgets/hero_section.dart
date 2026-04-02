import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../data/cart_controller.dart';
import '../data/store_controller.dart';
import '../data/theme_controller.dart';
import '../models/food_item.dart';
import '../models/hero_banner_item.dart';
import '../models/store_settings.dart';
import '../pages/cart_page.dart';
import 'store_image.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback? onOrderNowTap;
  final VoidCallback? onViewMenuTap;
  final void Function(ProductItem product)? onHeroProductTap;

  const HeroSection({
    super.key,
    this.onOrderNowTap,
    this.onViewMenuTap,
    this.onHeroProductTap,
  });


  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _autoSlideTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _restartAutoSlide();
  }

  void _restartAutoSlide() {
    _autoSlideTimer?.cancel();

    final banners = context.read<StoreController>().getHeroBanners();

    if (banners.length > 1) {
      _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (!_pageController.hasClients) return;

        final currentBanners = context.read<StoreController>().getHeroBanners();
        if (currentBanners.length <= 1) return;

        final nextPage = (_currentIndex + 1) % currentBanners.length;

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

    void _handleHeroTap(
    BuildContext context,
    HeroBannerItem? banner,
    ProductItem? targetProduct,
  ) {
    if (targetProduct != null && targetProduct.isAvailable) {
      if (widget.onHeroProductTap != null) {
        widget.onHeroProductTap!(targetProduct);
      } else {
        context.read<CartController>().addToCart(targetProduct);

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${targetProduct.name} added to cart'),
            duration: const Duration(milliseconds: 900),
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CartPage()),
        );
      }
      return;
    }

    if (widget.onOrderNowTap != null) {
      widget.onOrderNowTap!.call();
    }
  }


  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final storeController = context.watch<StoreController>();
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);
    final StoreSettings storeSettings = storeController.getStoreSettings();
    final List<HeroBannerItem> heroBanners = storeController.getHeroBanners();

    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1100;

    if (_currentIndex >= heroBanners.length && heroBanners.isNotEmpty) {
      _currentIndex = 0;
    }

    final HeroBannerItem? currentBanner = heroBanners.isEmpty
        ? null
        : heroBanners[_currentIndex % heroBanners.length];

    final ProductItem? targetProduct = currentBanner == null ||
            currentBanner.targetProductId.trim().isEmpty
        ? null
        : storeController.getProductById(currentBanner.targetProductId);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: palette.heroGradient,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 14 : 32,
          vertical: isMobile ? 18 : 48,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: isMobile
                ? _buildMobileLayout(
                    context: context,
                    storeSettings: storeSettings,
                    heroBanners: heroBanners,
                    currentBanner: currentBanner,
                    targetProduct: targetProduct,
                    palette: palette,
                  )
                : _buildDesktopLayout(
                    context: context,
                    isTablet: isTablet,
                    storeSettings: storeSettings,
                    heroBanners: heroBanners,
                    currentBanner: currentBanner,
                    targetProduct: targetProduct,
                    palette: palette,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout({
    required BuildContext context,
    required bool isTablet,
    required StoreSettings storeSettings,
    required List<HeroBannerItem> heroBanners,
    required HeroBannerItem? currentBanner,
    required ProductItem? targetProduct,
    required AppPalette palette,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 11,
          child: _HeroTextContent(
            isMobile: false,
            storeSettings: storeSettings,
            currentBanner: currentBanner,
            targetProduct: targetProduct,
            palette: palette,
            onOrderNowTap: () => _handleHeroTap(context, currentBanner, targetProduct),
            onViewMenuTap: widget.onViewMenuTap,
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 9,
          child: _HeroImageCard(
            isTablet: isTablet,
            heroBanners: heroBanners,
            currentBanner: currentBanner,
            targetProduct: targetProduct,
            palette: palette,
            pageController: _pageController,
            currentIndex: _currentIndex,
            onPageChanged: (index) {
              if (mounted) {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            onBannerTap: () => _handleHeroTap(context, currentBanner, targetProduct),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout({
    required BuildContext context,
    required StoreSettings storeSettings,
    required List<HeroBannerItem> heroBanners,
    required HeroBannerItem? currentBanner,
    required ProductItem? targetProduct,
    required AppPalette palette,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeroTextContent(
          isMobile: true,
          storeSettings: storeSettings,
          currentBanner: currentBanner,
          targetProduct: targetProduct,
          palette: palette,
          onOrderNowTap: () => _handleHeroTap(context, currentBanner, targetProduct),
          onViewMenuTap: widget.onViewMenuTap,
        ),
        const SizedBox(height: 18),
        _HeroImageCard(
          isTablet: false,
          heroBanners: heroBanners,
          currentBanner: currentBanner,
          targetProduct: targetProduct,
          palette: palette,
          pageController: _pageController,
          currentIndex: _currentIndex,
          onPageChanged: (index) {
            if (mounted) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          onBannerTap: () => _handleHeroTap(context, currentBanner, targetProduct),
        ),
      ],
    );
  }
}

class _HeroTextContent extends StatelessWidget {
  final bool isMobile;
  final StoreSettings storeSettings;
  final HeroBannerItem? currentBanner;
  final ProductItem? targetProduct;
  final AppPalette palette;
  final VoidCallback? onOrderNowTap;
  final VoidCallback? onViewMenuTap;

  const _HeroTextContent({
    required this.isMobile,
    required this.storeSettings,
    required this.currentBanner,
    required this.targetProduct,
    required this.palette,
    this.onOrderNowTap,
    this.onViewMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final headline = currentBanner?.title.trim().isNotEmpty == true
        ? currentBanner!.title
        : storeSettings.heroTitle;

    final subheadline = currentBanner?.subtitle.trim().isNotEmpty == true
        ? currentBanner!.subtitle
        : storeSettings.heroSubtitle;

    final primaryButtonText = currentBanner?.ctaText.trim().isNotEmpty == true
        ? currentBanner!.ctaText
        : 'Shop Now';

    final targetPrice =
        targetProduct == null ? null : 'GHS ${targetProduct!.price.toStringAsFixed(0)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 14,
            vertical: isMobile ? 7 : 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            storeSettings.tagline,
            style: TextStyle(
              color: AppColors.primaryBlack,
              fontWeight: FontWeight.w700,
              fontSize: isMobile ? 11.5 : 13,
            ),
          ),
        ),
        SizedBox(height: isMobile ? 16 : 20),
        Text(
          headline,
          style: TextStyle(
            fontSize: isMobile ? 28 : 56,
            height: 1.05,
            fontWeight: FontWeight.w900,
            color: palette.textOnStrong,
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        Text(
          subheadline,
        style: TextStyle(
          fontSize: isMobile ? 14 : 16,
          height: isMobile ? 1.55 : 1.7,
          color: palette.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        ),
        SizedBox(height: isMobile ? 14 : 18),
        if (targetProduct != null)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 14,
              vertical: isMobile ? 9 : 10,
            ),
            decoration: BoxDecoration(
              color: palette.surfaceStrong,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: palette.border),
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  targetProduct!.name,
                  style: TextStyle(
                    color: palette.textOnStrong,
                    fontWeight: FontWeight.w800,
                    fontSize: isMobile ? 13.5 : 14,
                  ),
                ),
                if (targetPrice != null)
                  Text(
                    targetPrice,
                    style: TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w900,
                      fontSize: isMobile ? 13.5 : 14,
                    ),
                  ),
              ],
            ),
          ),
        SizedBox(height: isMobile ? 20 : 28),
        if (isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: onOrderNowTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.primaryBlack,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                label: Text(
                  primaryButtonText,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onViewMenuTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: palette.textOnStrong,
                  side: BorderSide(color: palette.textOnStrong),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icon(
                  Icons.auto_awesome_outlined,
                  size: 18,
                  color: palette.textOnStrong,
                ),
                label: Text(
                  'Explore Collections',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: palette.textOnStrong,
                  ),
                ),
              ),
            ],
          )
        else
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              ElevatedButton.icon(
                onPressed: onOrderNowTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.primaryBlack,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.shopping_bag_outlined),
                label: Text(
                  primaryButtonText,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onViewMenuTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: palette.textOnStrong,
                  side: BorderSide(color: palette.textOnStrong),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icon(
                  Icons.auto_awesome_outlined,
                  color: palette.textOnStrong,
                ),
                label: Text(
                  'Explore Collections',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: palette.textOnStrong,
                  ),
                ),
              ),
            ],
          ),
        SizedBox(height: isMobile ? 20 : 28),
        Wrap(
          spacing: isMobile ? 10 : 12,
          runSpacing: isMobile ? 10 : 12,
          children: [
            _MiniInfoCard(
              title: 'Premium Streetwear',
              icon: Icons.auto_awesome,
              palette: palette,
              compact: isMobile,
            ),
            _MiniInfoCard(
              title: 'New Drops',
              icon: Icons.local_fire_department_outlined,
              palette: palette,
              compact: isMobile,
            ),
            _MiniInfoCard(
              title: 'Ghana Delivery',
              icon: Icons.local_shipping_outlined,
              palette: palette,
              compact: isMobile,
            ),
            _MiniInfoCard(
              title: 'Easy Checkout',
              icon: Icons.shopping_cart_checkout,
              palette: palette,
              compact: isMobile,
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroImageCard extends StatelessWidget {
  final bool isTablet;
  final List<HeroBannerItem> heroBanners;
  final HeroBannerItem? currentBanner;
  final ProductItem? targetProduct;
  final AppPalette palette;
  final PageController pageController;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final VoidCallback? onBannerTap;

  const _HeroImageCard({
    required this.isTablet,
    required this.heroBanners,
    required this.currentBanner,
    required this.targetProduct,
    required this.palette,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
    this.onBannerTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final bannerLabel =
        currentBanner?.ctaText.trim().isNotEmpty == true ? currentBanner!.ctaText : 'Featured Drop';

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 18),
      decoration: BoxDecoration(
        color: palette.surfaceStrong,
        borderRadius: BorderRadius.circular(isMobile ? 24 : 28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onBannerTap,
            child: Container(
              height: isMobile ? 300 : (isTablet ? 320 : 380),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: palette.heroGradient,
              ),
              child: Stack(
                children: [
                  if (heroBanners.isEmpty)
                    Center(
                      child: Icon(
                        Icons.shopping_bag,
                        size: isTablet ? 110 : 140,
                        color: AppColors.white.withValues(alpha: 0.95),
                      ),
                    )
                  else
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: heroBanners.length,
                        onPageChanged: onPageChanged,
                        itemBuilder: (context, index) {
                          final banner = heroBanners[index];
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              StoreImage(
                                imageUrl: banner.imageUrl,
                                fit: BoxFit.cover,
                                errorWidget: Container(
                                  color: palette.surfaceAlt,
                                  child: Center(
                                    child: Icon(
                                      Icons.shopping_bag,
                                      size: isTablet ? 110 : 140,
                                      color: AppColors.white.withValues(alpha: 0.95),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.08),
                                      Colors.black.withValues(alpha: 0.04),
                                      Colors.black.withValues(alpha: 0.42),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  Positioned(
                    top: isMobile ? 12 : 18,
                    left: isMobile ? 12 : 18,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 12 : 14,
                        vertical: isMobile ? 7 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        bannerLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryBlack,
                        ),
                      ),
                    ),
                  ),
                  if (heroBanners.isNotEmpty)
                    Positioned(
                      left: isMobile ? 12 : 18,
                      bottom: isMobile ? 12 : 18,
                      child: Row(
                        children: List.generate(
                          heroBanners.length,
                          (index) => Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: currentIndex == index ? 22 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: currentIndex == index
                                  ? palette.textOnStrong
                                  : palette.textOnStrong.withValues(alpha: 0.45),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    right: isMobile ? 12 : 18,
                    bottom: isMobile ? 12 : 18,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: isMobile ? 170 : 250),
                      padding: EdgeInsets.all(isMobile ? 12 : 14),
                        decoration: BoxDecoration(
                        color: palette.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: palette.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            targetProduct?.name ?? currentBanner?.title ?? 'Featured Product',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: isMobile ? 15 : 18,
                              color: palette.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            targetProduct == null
                                ? (currentBanner?.ctaText ?? 'Shop DTHC')
                                : 'GHS ${targetProduct!.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: isMobile ? 17 : 20,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Row(
            children: [
              Expanded(
                child: _HeroStatCard(
                  title: 'New Arrivals',
                  subtitle: 'Fresh weekly drops',
                  palette: palette,
                ),
              ),
              SizedBox(width: isMobile ? 10 : 12),
              Expanded(
                child: _HeroStatCard(
                  title: 'Easy Shopping',
                  subtitle: 'Smooth checkout flow',
                  palette: palette,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final AppPalette palette;

  const _HeroStatCard({
    required this.title,
    required this.subtitle,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: palette.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniInfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final AppPalette palette;
  final bool compact;

  const _MiniInfoCard({
    required this.title,
    required this.icon,
    required this.palette,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 14,
        vertical: compact ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: palette.surfaceStrong,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(color: palette.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.gold, size: compact ? 18 : 20),
          SizedBox(width: compact ? 7 : 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: compact ? 13 : 14,
              color: palette.textOnStrong,
            ),
          ),
        ],
      ),
    );
  }
}
