import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../data/store_controller.dart';
import '../models/food_item.dart';
import '../models/store_settings.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback? onOrderNowTap;
  final VoidCallback? onViewMenuTap;

  const HeroSection({
    super.key,
    this.onOrderNowTap,
    this.onViewMenuTap,
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

    final featuredProducts =
        context.read<StoreController>().getFeaturedProducts();

    if (featuredProducts.length > 1) {
      _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (!_pageController.hasClients) return;

        final products = context.read<StoreController>().getFeaturedProducts();
        if (products.length <= 1) return;

        final nextPage = (_currentIndex + 1) % products.length;

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
        );
      });
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
    final StoreSettings storeSettings = storeController.getStoreSettings();
    final List<ProductItem> featuredProducts =
        storeController.getFeaturedProducts();

    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1100;

    if (_currentIndex >= featuredProducts.length && featuredProducts.isNotEmpty) {
      _currentIndex = 0;
    }

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 32,
          vertical: isMobile ? 24 : 48,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: isMobile
                ? _buildMobileLayout(storeSettings, featuredProducts)
                : _buildDesktopLayout(
                    isTablet,
                    storeSettings,
                    featuredProducts,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    bool isTablet,
    StoreSettings storeSettings,
    List<ProductItem> featuredProducts,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 11,
          child: _HeroTextContent(
            isMobile: false,
            storeSettings: storeSettings,
            onOrderNowTap: widget.onOrderNowTap,
            onViewMenuTap: widget.onViewMenuTap,
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 9,
          child: _HeroImageCard(
            isTablet: isTablet,
            featuredProducts: featuredProducts,
            pageController: _pageController,
            currentIndex: _currentIndex,
            onPageChanged: (index) {
              if (mounted) {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    StoreSettings storeSettings,
    List<ProductItem> featuredProducts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeroTextContent(
          isMobile: true,
          storeSettings: storeSettings,
          onOrderNowTap: widget.onOrderNowTap,
          onViewMenuTap: widget.onViewMenuTap,
        ),
        const SizedBox(height: 24),
        _HeroImageCard(
          isTablet: false,
          featuredProducts: featuredProducts,
          pageController: _pageController,
          currentIndex: _currentIndex,
          onPageChanged: (index) {
            if (mounted) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
        ),
      ],
    );
  }
}

class _HeroTextContent extends StatelessWidget {
  final bool isMobile;
  final StoreSettings storeSettings;
  final VoidCallback? onOrderNowTap;
  final VoidCallback? onViewMenuTap;

  const _HeroTextContent({
    required this.isMobile,
    required this.storeSettings,
    this.onOrderNowTap,
    this.onViewMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            storeSettings.tagline,
            style: const TextStyle(
              color: AppColors.primaryBlack,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          storeSettings.heroTitle,
          style: TextStyle(
            fontSize: isMobile ? 34 : 56,
            height: 1.05,
            fontWeight: FontWeight.w900,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          storeSettings.heroSubtitle,
          style: const TextStyle(
            fontSize: 16,
            height: 1.7,
            color: Color(0xFFBDBDBD),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 28),
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
              label: const Text(
                'Shop Now',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: onViewMenuTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.white,
                side: const BorderSide(color: AppColors.gold),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.auto_awesome_outlined),
              label: const Text(
                'Explore Collections',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _MiniInfoCard(
              title: 'Premium Streetwear',
              icon: Icons.auto_awesome,
            ),
            _MiniInfoCard(
              title: 'New Drops',
              icon: Icons.local_fire_department_outlined,
            ),
            _MiniInfoCard(
              title: 'Ghana Delivery',
              icon: Icons.local_shipping_outlined,
            ),
            _MiniInfoCard(
              title: 'Easy Checkout',
              icon: Icons.shopping_cart_checkout,
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroImageCard extends StatelessWidget {
  final bool isTablet;
  final List<ProductItem> featuredProducts;
  final PageController pageController;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const _HeroImageCard({
    required this.isTablet,
    required this.featuredProducts,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentProduct = featuredProducts.isEmpty
        ? null
        : featuredProducts[currentIndex % featuredProducts.length];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(28),
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
          Container(
            height: isTablet ? 320 : 380,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0F0F0F),
                  Color(0xFF262626),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                if (featuredProducts.isEmpty)
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
                      itemCount: featuredProducts.length,
                      onPageChanged: onPageChanged,
                      itemBuilder: (context, index) {
                        final product = featuredProducts[index];
                        return Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.charcoal,
                              child: Center(
                                child: Icon(
                                  Icons.shopping_bag,
                                  size: isTablet ? 110 : 140,
                                  color: AppColors.white.withValues(alpha: 0.95),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                Positioned(
                  top: 18,
                  left: 18,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Featured Drop',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlack,
                      ),
                    ),
                  ),
                ),
                if (featuredProducts.isNotEmpty)
                  Positioned(
                    left: 18,
                    bottom: 18,
                    child: Row(
                      children: List.generate(
                        featuredProducts.length,
                        (index) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: currentIndex == index ? 22 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentIndex == index
                                ? AppColors.white
                                : AppColors.white.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: 18,
                  bottom: 18,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentProduct?.name ?? 'Featured Product',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: AppColors.primaryBlack,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentProduct == null
                              ? 'GHS 0'
                              : 'GHS ${currentProduct.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
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
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: _HeroStatCard(
                  title: 'New Arrivals',
                  subtitle: 'Fresh weekly drops',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _HeroStatCard(
                  title: 'Easy Shopping',
                  subtitle: 'Smooth checkout flow',
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

  const _HeroStatCard({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFFBDBDBD),
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

  const _MiniInfoCard({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.gold, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}