import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'track_order_page.dart';
import '../core/app_colors.dart';
import '../data/cart_controller.dart';
import '../data/store_controller.dart';
import '../data/theme_controller.dart';
import '../models/category_item.dart';
import '../models/food_item.dart';
import '../models/store_settings.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/hero_section.dart';
import '../widgets/store_image.dart';
import 'admin/admin_dashboard_page.dart';
import 'cart_page.dart';
import 'collections_page.dart';
import 'contact_page.dart';
import 'lookbook_page.dart';
import 'menu_page.dart';
import 'payment_delivery_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartPage()),
    );
  }

  void _openShopSection(String sectionFilter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MenuPage(sectionFilter: sectionFilter),
      ),
    );
  }

  void _openShopCategory(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MenuPage(categoryFilter: category),
      ),
    );
  }

  void _addToCartAndOpenCart(ProductItem product) {
    context.read<CartController>().addToCart(product);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
      ),
    );

    _openCartPage();
  }

  List<ProductItem> _buildSearchResults(List<ProductItem> products) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return [];

    return products.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.collection.toLowerCase().contains(query);
    }).take(6).toList();
  }

  List<ProductItem> _buildTrendingProducts(List<ProductItem> products) {
    final trending = products
        .where((product) => product.isFeatured || product.isBestSeller)
        .toList();

    if (trending.isNotEmpty) {
      return trending.take(8).toList();
    }

    return products.take(8).toList();
  }

  List<ProductItem> _buildLimitedEditionProducts(List<ProductItem> products) {
    final limited = products.where((product) {
      final collection = product.collection.trim().toLowerCase();
      return collection == 'luxury street' || collection == 'night code';
    }).toList();

    if (limited.isNotEmpty) {
      return limited.take(8).toList();
    }

    return products.reversed.take(8).toList();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StoreController>();
    final storeSettings = controller.getStoreSettings();
    final isDarkMode = context.watch<ThemeController>().isDarkMode;
    final palette = AppColors.palette(isDarkMode);
    final categories = controller.getCategories();
    final featuredProducts = controller.getFeaturedProducts();
    final newArrivals = controller.getNewArrivals();
    final bestSellers = controller.getBestSellers();
    final allProducts = controller.getAvailableProducts();
    final trendingProducts = _buildTrendingProducts(allProducts);
    final limitedEditionProducts = _buildLimitedEditionProducts(allProducts);
    final searchResults = _buildSearchResults(allProducts);

    return Scaffold(
      backgroundColor: palette.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomNavbar(
              activeItem: 'Home',
              onHomeTap: () {},
              onMenuTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MenuPage()),
                );
              },
              onSpecialPacksTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CollectionsPage()),
                );
              },
              onCartTap: _openCartPage,
              onContactTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactPage()),
                );
              },
              onTrackOrderTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TrackOrderPage()),
                );
              },
              onLookbookTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LookbookPage()),
                );
              },
              onDeliveryTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentDeliveryPage(),
                  ),
                );
              },
              onOrderNowTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MenuPage()),
                );
              },
              onAdminTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminDashboardPage(),
                  ),
                );
              },
            ),
            HeroSection(
              onOrderNowTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MenuPage()),
                );
              },
              onViewMenuTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MenuPage()),
                );
              },
              onHeroProductTap: _addToCartAndOpenCart,
            ),
            _HomeSearchSection(
              palette: palette,
              title: storeSettings.homeSearchTitle,
              subtitle: storeSettings.homeSearchSubtitle,
              controller: _searchController,
              query: _searchQuery,
              results: searchResults,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              onClear: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              onResultTap: _addToCartAndOpenCart,
            ),
            _QuickCategorySection(
              palette: palette,
              categories: categories,
              onCategoryTap: _openShopCategory,
            ),
            _MarketplacePromoSection(
              palette: palette,
              label: storeSettings.marketplaceBannerLabel,
              title: storeSettings.marketplaceBannerTitle,
              subtitle: storeSettings.marketplaceBannerSubtitle,
              primaryCta: storeSettings.marketplacePrimaryCta,
              secondaryCta: storeSettings.marketplaceSecondaryCta,
              promoSneakersTitle: storeSettings.promoSneakersTitle,
              promoSneakersSubtitle: storeSettings.promoSneakersSubtitle,
              promoSneakersCta: storeSettings.promoSneakersCta,
              promoTeesTitle: storeSettings.promoTeesTitle,
              promoTeesSubtitle: storeSettings.promoTeesSubtitle,
              promoTeesCta: storeSettings.promoTeesCta,
              promoBestSellersTitle: storeSettings.promoBestSellersTitle,
              promoBestSellersSubtitle: storeSettings.promoBestSellersSubtitle,
              promoBestSellersCta: storeSettings.promoBestSellersCta,
              onOpenNewDrops: () => _openShopSection('new-drops'),
              onOpenBestSellers: () => _openShopSection('best-sellers'),
              onOpenSneakers: () => _openShopCategory('Sneakers'),
              onOpenTees: () => _openShopCategory('Tees'),
            ),
            _SiteHighlightsSection(palette: palette),
            _ConversionHeroStrip(
              palette: palette,
              label: storeSettings.dealsStripLabel,
              title: storeSettings.dealsStripTitle,
              subtitle: storeSettings.dealsStripSubtitle,
              primaryCta: storeSettings.dealsPrimaryCta,
              secondaryCta: storeSettings.dealsSecondaryCta,
              countdownEndsAt: storeSettings.dealsCountdownEndsAt,
              onPrimaryTap: () => _openShopSection('new-drops'),
              onSecondaryTap: () => _openShopSection('limited-edition'),
            ),
            _ConversionSection(
              title: 'New Drops',
              subtitle:
                  'Fresh arrivals just landed. Push the latest DTHC pieces first so returning visitors see something new immediately.',
              products: newArrivals,
              onAddToCart: _addToCartAndOpenCart,
              onViewAll: () => _openShopSection('new-drops'),
            ),
            _ConversionSection(
              title: 'Trending Now',
              subtitle:
                  'Top attention-grabbers across the store. This section turns interest into action with products already pulling attention.',
              products: trendingProducts,
              onAddToCart: _addToCartAndOpenCart,
              onViewAll: () => _openShopSection('trending-now'),
              darkSection: true,
            ),
            _ConversionSection(
              title: 'Best Sellers',
              subtitle:
                  'Show social proof through your strongest products. These are the pieces shoppers are most likely to trust and buy fast.',
              products: bestSellers,
              onAddToCart: _addToCartAndOpenCart,
              onViewAll: () => _openShopSection('best-sellers'),
            ),
            _ConversionSection(
              title: 'Limited Edition',
              subtitle:
                  'Premium exclusive pieces for customers who want standout looks. This section should feel more rare, elevated, and high-value.',
              products: limitedEditionProducts,
              onAddToCart: _addToCartAndOpenCart,
              onViewAll: () => _openShopSection('limited-edition'),
              darkSection: true,
            ),
            _FeaturedSection(
              title: 'Featured Products',
              subtitle:
                  'Top pieces from the latest DTHC drops, styled for bold everyday wear.',
              products: featuredProducts,
              onAddToCart: _addToCartAndOpenCart,
            ),
            _CollectionsPreviewSection(palette: palette),
            _LookbookPreviewSection(palette: palette),
            _PaymentDeliveryPreviewSection(palette: palette),
            _WhyChooseUsSection(palette: palette),
            _FooterSection(storeSettings: storeSettings),
          ],
        ),
      ),
    );
  }
}

class _HomeSearchSection extends StatelessWidget {
  final AppPalette palette;
  final String title;
  final String subtitle;
  final TextEditingController controller;
  final String query;
  final List<ProductItem> results;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final ValueChanged<ProductItem> onResultTap;

  const _HomeSearchSection({
    required this.palette,
    required this.title,
    required this.subtitle,
    required this.controller,
    required this.query,
    required this.results,
    required this.onChanged,
    required this.onClear,
    required this.onResultTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final hasQuery = query.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      color: palette.background,
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 32,
        26,
        isMobile ? 16 : 32,
        18,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: palette.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _TopInfoPill(
                      label: 'Fast search',
                      icon: Icons.search_rounded,
                    ),
                    _TopInfoPill(
                      label: 'New arrivals',
                      icon: Icons.local_fire_department_outlined,
                    ),
                    _TopInfoPill(
                      label: 'Best deals',
                      icon: Icons.sell_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: palette.surfaceAlt,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: palette.border),
                  ),
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    style: TextStyle(color: palette.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search tees, sneakers, caps, chains, belts...',
                      hintStyle: TextStyle(color: palette.textSecondary),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.gold,
                      ),
                      suffixIcon: hasQuery
                          ? IconButton(
                              onPressed: onClear,
                              icon: Icon(
                                Icons.close_rounded,
                                color: palette.textPrimary,
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                    ),
                  ),
                ),
                if (hasQuery) ...[
                  const SizedBox(height: 14),
                  if (results.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: palette.surfaceAlt,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: palette.border),
                      ),
                      child: Text(
                        'No matching products found yet.',
                        style: TextStyle(
                          color: palette.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: palette.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: palette.border),
                      ),
                      child: Column(
                        children: results
                            .map(
                              (product) => _SearchResultTile(
                                product: product,
                                onTap: () => onResultTap(product),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final ProductItem product;
  final VoidCallback onTap;

  const _SearchResultTile({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.imageUrl.trim();

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 60,
                height: 60,
                color: AppColors.lightGrey,
                child: imageUrl.isEmpty
                    ? const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.primaryBlack,
                      )
                    : StoreImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        errorWidget: const Icon(
                          Icons.shopping_bag_outlined,
                          color: AppColors.primaryBlack,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.primaryBlack,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.category} • ${product.collection}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.greyText,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'GHS ${product.price.toStringAsFixed(0)}',
              style: const TextStyle(
                color: AppColors.gold,
                fontWeight: FontWeight.w800,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickCategorySection extends StatelessWidget {
  final AppPalette palette;
  final List<CategoryItem> categories;
  final ValueChanged<String> onCategoryTap;

  const _QuickCategorySection({
    required this.palette,
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      color: palette.background,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 12,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shop by category',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Explore premium streetwear pieces from tees, sneakers, caps, chains, belts, and socks.',
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: categories
                    .where((category) => category.name.trim().toLowerCase() != 'all')
                    .map(
                      (category) => InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => onCategoryTap(category.name),
                        child: _CategoryChip(
                          title: category.name,
                          icon: _mapCategoryIcon(category.icon),
                          active: false,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _mapCategoryIcon(String iconName) {
    switch (iconName) {
      case 'shirt':
        return Icons.checkroom_outlined;
      case 'shoe':
        return Icons.run_circle_outlined;
      case 'cap':
        return Icons.workspace_premium_outlined;
      case 'chain':
        return Icons.link_rounded;
      case 'belt':
        return Icons.style_outlined;
      case 'socks':
        return Icons.sports_outlined;
      case 'grid':
      default:
        return Icons.grid_view_rounded;
    }
  }
}

class _CategoryChip extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool active;

  const _CategoryChip({
    required this.title,
    required this.icon,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Container(
      decoration: BoxDecoration(
        color: active ? AppColors.gold : palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: active ? AppColors.gold : palette.border,
        ),
        boxShadow: active
            ? []
            : const [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: palette.textPrimary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: palette.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketplacePromoSection extends StatelessWidget {
  final AppPalette palette;
  final String label;
  final String title;
  final String subtitle;
  final String primaryCta;
  final String secondaryCta;
  final String promoSneakersTitle;
  final String promoSneakersSubtitle;
  final String promoSneakersCta;
  final String promoTeesTitle;
  final String promoTeesSubtitle;
  final String promoTeesCta;
  final String promoBestSellersTitle;
  final String promoBestSellersSubtitle;
  final String promoBestSellersCta;
  final VoidCallback onOpenNewDrops;
  final VoidCallback onOpenBestSellers;
  final VoidCallback onOpenSneakers;
  final VoidCallback onOpenTees;

  const _MarketplacePromoSection({
    required this.palette,
    required this.label,
    required this.title,
    required this.subtitle,
    required this.primaryCta,
    required this.secondaryCta,
    required this.promoSneakersTitle,
    required this.promoSneakersSubtitle,
    required this.promoSneakersCta,
    required this.promoTeesTitle,
    required this.promoTeesSubtitle,
    required this.promoTeesCta,
    required this.promoBestSellersTitle,
    required this.promoBestSellersSubtitle,
    required this.promoBestSellersCta,
    required this.onOpenNewDrops,
    required this.onOpenBestSellers,
    required this.onOpenSneakers,
    required this.onOpenTees,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      color: palette.background,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 18,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: isMobile
              ? Column(
                  children: [
                    _PrimaryMarketplaceBanner(
                      palette: palette,
                      label: label,
                      title: title,
                      subtitle: subtitle,
                      primaryCta: primaryCta,
                      secondaryCta: secondaryCta,
                      onPrimaryTap: onOpenNewDrops,
                      onSecondaryTap: onOpenBestSellers,
                    ),
                    const SizedBox(height: 16),
                    _PromoShortcutGrid(
                      isMobile: true,
                      palette: palette,
                      sneakersTitle: promoSneakersTitle,
                      sneakersSubtitle: promoSneakersSubtitle,
                      sneakersCta: promoSneakersCta,
                      teesTitle: promoTeesTitle,
                      teesSubtitle: promoTeesSubtitle,
                      teesCta: promoTeesCta,
                      bestSellersTitle: promoBestSellersTitle,
                      bestSellersSubtitle: promoBestSellersSubtitle,
                      bestSellersCta: promoBestSellersCta,
                      onOpenSneakers: onOpenSneakers,
                      onOpenTees: onOpenTees,
                      onOpenBestSellers: onOpenBestSellers,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _PrimaryMarketplaceBanner(
                        palette: palette,
                        label: label,
                        title: title,
                        subtitle: subtitle,
                        primaryCta: primaryCta,
                        secondaryCta: secondaryCta,
                        onPrimaryTap: onOpenNewDrops,
                        onSecondaryTap: onOpenBestSellers,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 4,
                      child: _PromoShortcutGrid(
                        isMobile: false,
                        palette: palette,
                        sneakersTitle: promoSneakersTitle,
                        sneakersSubtitle: promoSneakersSubtitle,
                        sneakersCta: promoSneakersCta,
                        teesTitle: promoTeesTitle,
                        teesSubtitle: promoTeesSubtitle,
                        teesCta: promoTeesCta,
                        bestSellersTitle: promoBestSellersTitle,
                        bestSellersSubtitle: promoBestSellersSubtitle,
                        bestSellersCta: promoBestSellersCta,
                        onOpenSneakers: onOpenSneakers,
                        onOpenTees: onOpenTees,
                        onOpenBestSellers: onOpenBestSellers,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _PrimaryMarketplaceBanner extends StatelessWidget {
  final AppPalette palette;
  final String label;
  final String title;
  final String subtitle;
  final String primaryCta;
  final String secondaryCta;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;

  const _PrimaryMarketplaceBanner({
    required this.palette,
    required this.label,
    required this.title,
    required this.subtitle,
    required this.primaryCta,
    required this.secondaryCta,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        gradient: palette.heroGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.primaryBlack,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: palette.textOnStrong,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _DarkInfoPill(label: 'New arrivals'),
              _DarkInfoPill(label: 'Top sellers'),
              _DarkInfoPill(label: 'Premium fits'),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton(
                onPressed: onPrimaryTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.primaryBlack,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  primaryCta,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              OutlinedButton(
                onPressed: onSecondaryTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: palette.textOnStrong,
                  side: BorderSide(color: palette.textOnStrong),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  secondaryCta,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PromoShortcutGrid extends StatelessWidget {
  final bool isMobile;
  final AppPalette palette;
  final String sneakersTitle;
  final String sneakersSubtitle;
  final String sneakersCta;
  final String teesTitle;
  final String teesSubtitle;
  final String teesCta;
  final String bestSellersTitle;
  final String bestSellersSubtitle;
  final String bestSellersCta;
  final VoidCallback onOpenSneakers;
  final VoidCallback onOpenTees;
  final VoidCallback onOpenBestSellers;

  const _PromoShortcutGrid({
    required this.isMobile,
    required this.palette,
    required this.sneakersTitle,
    required this.sneakersSubtitle,
    required this.sneakersCta,
    required this.teesTitle,
    required this.teesSubtitle,
    required this.teesCta,
    required this.bestSellersTitle,
    required this.bestSellersSubtitle,
    required this.bestSellersCta,
    required this.onOpenSneakers,
    required this.onOpenTees,
    required this.onOpenBestSellers,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _PromoShortcutData(
        title: sneakersTitle,
        subtitle: sneakersSubtitle,
        cta: sneakersCta,
        icon: Icons.run_circle_outlined,
        color: palette.surfaceStrong,
        onTap: onOpenSneakers,
      ),
      _PromoShortcutData(
        title: teesTitle,
        subtitle: teesSubtitle,
        cta: teesCta,
        icon: Icons.checkroom_outlined,
        color: palette.surfaceAlt,
        onTap: onOpenTees,
      ),
      _PromoShortcutData(
        title: bestSellersTitle,
        subtitle: bestSellersSubtitle,
        cta: bestSellersCta,
        icon: Icons.workspace_premium_outlined,
        color: AppColors.gold.withValues(alpha: 0.18),
        onTap: onOpenBestSellers,
      ),
    ];

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: items.map((item) {
        final width = isMobile ? double.infinity : 220.0;
        return SizedBox(
          width: width,
          child: _PromoShortcutCard(
            data: item,
            palette: palette,
          ),
        );
      }).toList(),
    );
  }
}

class _PromoShortcutData {
  final String title;
  final String subtitle;
  final String cta;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _PromoShortcutData({
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _PromoShortcutCard extends StatelessWidget {
  final _PromoShortcutData data;
  final AppPalette palette;

  const _PromoShortcutCard({
    required this.data,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: palette.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: data.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                data.icon,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              data.title,
              style: TextStyle(
                color: palette.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data.subtitle,
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 13.5,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              data.cta,
              style: TextStyle(
                color: palette.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DarkInfoPill extends StatelessWidget {
  final String label;

  const _DarkInfoPill({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: palette.textOnStrong.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: palette.textOnStrong,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SiteHighlightsSection extends StatelessWidget {
  final AppPalette palette;

  const _SiteHighlightsSection({
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      color: palette.background,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 28,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Wrap(
            spacing: 18,
            runSpacing: 18,
            children: const [
              _MiniHighlightCard(
                icon: Icons.local_fire_department_outlined,
                title: 'Weekly Drops',
                subtitle: 'Fresh premium pieces added regularly.',
              ),
              _MiniHighlightCard(
                icon: Icons.verified_outlined,
                title: 'Curated Style',
                subtitle: 'Bold looks selected for the DTHC brand vibe.',
              ),
              _MiniHighlightCard(
                icon: Icons.local_shipping_outlined,
                title: 'Nationwide Delivery',
                subtitle: 'Fast dispatch and simple delivery flow.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniHighlightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MiniHighlightCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Container(
      width: 400,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryBlack,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversionHeroStrip extends StatelessWidget {
  final AppPalette palette;
  final String label;
  final String title;
  final String subtitle;
  final String primaryCta;
  final String secondaryCta;
  final String countdownEndsAt;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;

  const _ConversionHeroStrip({
    required this.palette,
    required this.label,
    required this.title,
    required this.subtitle,
    required this.primaryCta,
    required this.secondaryCta,
    required this.countdownEndsAt,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
  });

  String? _buildCountdownText() {
    final parsed = DateTime.tryParse(countdownEndsAt);
    if (parsed == null) return null;

    final remaining = parsed.difference(DateTime.now());
    if (remaining.isNegative) return null;

    final totalHours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);

    return '${totalHours.toString().padLeft(2, '0')}h '
        '${minutes.toString().padLeft(2, '0')}m '
        '${seconds.toString().padLeft(2, '0')}s left';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final countdownText = _buildCountdownText();

    return Container(
      width: double.infinity,
      color: palette.background,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 34,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 18 : 26),
            decoration: BoxDecoration(
              gradient: palette.promoGradient,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: palette.border),
            ),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _TagChip(
                            label: label,
                            backgroundColor: AppColors.gold,
                            textColor: AppColors.primaryBlack,
                          ),
                          if (countdownText != null)
                            _TagChip(
                              label: countdownText,
                              backgroundColor: palette.surface,
                              textColor: palette.textPrimary,
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: palette.textSecondary,
                          fontSize: 14,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onPrimaryTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.primaryBlack,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            primaryCta,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: onSecondaryTap,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: palette.textPrimary,
                            side: BorderSide(color: palette.textPrimary),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            secondaryCta,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _TagChip(
                                  label: label,
                                  backgroundColor: AppColors.gold,
                                  textColor: AppColors.primaryBlack,
                                ),
                                if (countdownText != null)
                                  _TagChip(
                                    label: countdownText,
                                    backgroundColor: palette.surface,
                                    textColor: palette.textPrimary,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              title,
                              style: TextStyle(
                                color: palette.textPrimary,
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                height: 1.05,
                              ),
                            ),
                            SizedBox(height: 14),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: palette.textSecondary,
                                fontSize: 15,
                                height: 1.7,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Column(
                        children: [
                          SizedBox(
                            width: 220,
                            child: ElevatedButton(
                              onPressed: onPrimaryTap,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.gold,
                                foregroundColor: AppColors.primaryBlack,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                primaryCta,
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 220,
                            child: OutlinedButton(
                              onPressed: onSecondaryTap,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: palette.textPrimary,
                                side: BorderSide(color: palette.textPrimary),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                secondaryCta,
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _TopInfoPill extends StatelessWidget {
  final String label;
  final IconData icon;

  const _TopInfoPill({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palette.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: palette.textPrimary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: palette.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversionSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<ProductItem> products;
  final ValueChanged<ProductItem> onAddToCart;
  final VoidCallback onViewAll;
  final bool darkSection;

  const _ConversionSection({
    required this.title,
    required this.subtitle,
    required this.products,
    required this.onAddToCart,
    required this.onViewAll,
    this.darkSection = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final displayProducts = products.take(4).toList();
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Container(
      width: double.infinity,
      color: palette.background,
      padding: EdgeInsets.symmetric(
        horizontal: width < 768 ? 16 : 32,
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              width < 900
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 15,
                            color: palette.textSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 18),
                        OutlinedButton(
                          onPressed: onViewAll,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.gold,
                            side: const BorderSide(color: AppColors.gold),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'View All in Shop',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: palette.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: palette.textSecondary,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 18),
                        OutlinedButton(
                          onPressed: onViewAll,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.gold,
                            side: const BorderSide(color: AppColors.gold),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'View All in Shop',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 24),
              if (displayProducts.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: palette.card,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: palette.border),
                  ),
                  child: Text(
                    'No products available in this section yet.',
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final sectionWidth = constraints.maxWidth;
                    final cardWidth = sectionWidth > 1100
                        ? (sectionWidth - 36) / 3
                        : sectionWidth > 700
                            ? (sectionWidth - 18) / 2
                            : sectionWidth;

                    return Wrap(
                      spacing: 18,
                      runSpacing: 18,
                      children: displayProducts.map((product) {
                        return SizedBox(
                          width: cardWidth,
                          child: _ProductPreviewCard(
                            product: product,
                            onAddToCart: () => onAddToCart(product),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<ProductItem> products;
  final ValueChanged<ProductItem> onAddToCart;

  const _FeaturedSection({
    required this.title,
    required this.subtitle,
    required this.products,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Container(
      width: double.infinity,
      color: palette.background,
      padding: EdgeInsets.symmetric(
        horizontal: width < 768 ? 16 : 32,
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 15,
                  color: palette.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final sectionWidth = constraints.maxWidth;
                  final featuredProducts = products.take(4).toList();
                  final cardWidth = sectionWidth > 1100
                      ? (sectionWidth - 36) / 3
                      : sectionWidth > 700
                          ? (sectionWidth - 18) / 2
                          : sectionWidth;

                  return Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: featuredProducts.map((product) {
                      return SizedBox(
                        width: cardWidth,
                        child: _ProductPreviewCard(
                          product: product,
                          onAddToCart: () => onAddToCart(product),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductPreviewCard extends StatelessWidget {
  final ProductItem product;
  final VoidCallback onAddToCart;

  const _ProductPreviewCard({
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final primaryEntry = product.primaryImageEntry;
    final imageUrl = primaryEntry.imageUrl.trim();
    final width = MediaQuery.of(context).size.width;
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);
    final imageHeight = width > 1100
        ? 260.0
        : width > 700
            ? 220.0
            : 240.0;
    final hasDiscount = primaryEntry.hasDiscount;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: imageHeight,
              width: double.infinity,
              color: palette.surfaceAlt,
              child: imageUrl.isEmpty
                  ? Center(
                      child: Icon(
                        _productIcon(product.category),
                        size: 56,
                        color: palette.textPrimary,
                      ),
                    )
                  : StoreImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      errorWidget: Center(
                        child: Icon(
                          _productIcon(product.category),
                          size: 56,
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            primaryEntry.title.isNotEmpty ? primaryEntry.title : product.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            primaryEntry.description.isNotEmpty
                ? primaryEntry.description
                : product.description,
            style: TextStyle(
              fontSize: 14,
              color: palette.textSecondary,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (product.isNewArrival)
                _TagChip(
                  label: 'New',
                  backgroundColor: AppColors.gold,
                  textColor: AppColors.primaryBlack,
                ),
              if (product.isBestSeller)
                _TagChip(
                  label: 'Best Seller',
                  backgroundColor: AppColors.lightGrey,
                  textColor: AppColors.primaryBlack,
                ),
              if (product.isFeatured)
                _TagChip(
                  label: 'Trending',
                  backgroundColor: palette.surfaceAlt,
                  textColor: palette.textPrimary,
                ),
              if (product.dealLabel.trim().isNotEmpty)
                _TagChip(
                  label: product.dealLabel,
                  backgroundColor: AppColors.gold.withValues(alpha: 0.18),
                  textColor: AppColors.gold,
                ),
              if (hasDiscount)
                _TagChip(
                  label: '-${primaryEntry.discountPercent}%',
                  backgroundColor: AppColors.gold.withValues(alpha: 0.18),
                  textColor: AppColors.gold,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: palette.surfaceAlt,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: palette.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GHS ${primaryEntry.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: palette.textPrimary,
                  ),
                ),
                if (hasDiscount) ...[
                  const SizedBox(height: 4),
                  Text(
                    'GHS ${primaryEntry.oldPrice!.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: palette.textSecondary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: product.isAvailable ? onAddToCart : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.primaryBlack,
                disabledBackgroundColor: AppColors.border,
                disabledForegroundColor: AppColors.greyText,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                product.isAvailable ? 'Add to Cart' : 'Out of Stock',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _productIcon(String category) {
    switch (category) {
      case 'Tees':
        return Icons.checkroom;
      case 'Sneakers':
        return Icons.run_circle;
      case 'Caps':
        return Icons.workspace_premium;
      case 'Chains':
        return Icons.link;
      case 'Belts':
        return Icons.style;
      case 'Socks':
        return Icons.sports;
      default:
        return Icons.shopping_bag;
    }
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _TagChip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _CollectionsPreviewSection extends StatelessWidget {
  final AppPalette palette;

  const _CollectionsPreviewSection({
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width > 1100
        ? 400.0
        : width > 700
            ? (width - 98) / 2
            : double.infinity;

    return Container(
      width: double.infinity,
      color: palette.background,
      padding: EdgeInsets.symmetric(
        horizontal: width < 768 ? 16 : 32,
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Featured Collections',
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Give shoppers a structured way to explore drops, premium essentials, and bold statement pieces.',
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  _CollectionPreviewCard(
                    palette: palette,
                    width: cardWidth,
                    title: 'Urban Essentials',
                    subtitle:
                        'Minimal black-and-gold everyday pieces for clean city styling.',
                    icon: Icons.layers_outlined,
                  ),
                  _CollectionPreviewCard(
                    palette: palette,
                    width: cardWidth,
                    title: 'Weekend Heat',
                    subtitle:
                        'Statement sneakers, graphic tees, and standout accessories.',
                    icon: Icons.local_fire_department_outlined,
                  ),
                  _CollectionPreviewCard(
                    palette: palette,
                    width: cardWidth,
                    title: 'Luxury Street',
                    subtitle:
                        'Premium curated fits built for a bold upscale streetwear vibe.',
                    icon: Icons.workspace_premium_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollectionPreviewCard extends StatelessWidget {
  final AppPalette palette;
  final double width;
  final String title;
  final String subtitle;
  final IconData icon;

  const _CollectionPreviewCard({
    required this.palette,
    required this.width,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 62,
            width: 62,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryBlack,
              size: 30,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CollectionsPage()),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.gold,
              side: const BorderSide(color: AppColors.gold),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Explore Collection',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _LookbookPreviewSection extends StatelessWidget {
  final AppPalette palette;

  const _LookbookPreviewSection({
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      color: palette.background,
      padding: EdgeInsets.symmetric(
        horizontal: width < 768 ? 16 : 32,
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lookbook Preview',
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'A premium fashion gallery section helps the brand feel more editorial and high-end.',
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 768) {
                    return Column(
                      children: [
                        _LookbookTile(
                          palette: palette,
                          height: 180,
                          icon: Icons.camera_alt_outlined,
                          title: 'Street Fit 01',
                          subtitle: 'Monochrome layering with statement sneakers',
                        ),
                        SizedBox(height: 16),
                        _LookbookTile(
                          palette: palette,
                          height: 180,
                          icon: Icons.flash_on_outlined,
                          title: 'Street Fit 02',
                          subtitle: 'Bold drop styling with premium accessories',
                        ),
                        SizedBox(height: 16),
                        _LookbookTile(
                          palette: palette,
                          height: 180,
                          icon: Icons.nightlife_outlined,
                          title: 'Street Fit 03',
                          subtitle:
                              'Clean night-out fashion with elevated essentials',
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _LookbookTile(
                          palette: palette,
                          height: 380,
                          icon: Icons.camera_alt_outlined,
                          title: 'Street Fit 01',
                          subtitle: 'Monochrome layering with statement sneakers',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            _LookbookTile(
                              palette: palette,
                              height: 182,
                              icon: Icons.flash_on_outlined,
                              title: 'Street Fit 02',
                              subtitle:
                                  'Bold drop styling with premium accessories',
                            ),
                            SizedBox(height: 16),
                            _LookbookTile(
                              palette: palette,
                              height: 182,
                              icon: Icons.nightlife_outlined,
                              title: 'Street Fit 03',
                              subtitle:
                                  'Clean night-out fashion with elevated essentials',
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LookbookPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.gold,
                    side: const BorderSide(color: AppColors.gold),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Open Lookbook',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LookbookTile extends StatelessWidget {
  final AppPalette palette;
  final double height;
  final IconData icon;
  final String title;
  final String subtitle;

  const _LookbookTile({
    required this.palette,
    required this.height,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.surface,
            palette.surfaceAlt,
          ],
        ),
        border: Border.all(color: palette.border),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 18,
            top: 18,
            child: Icon(
              icon,
              size: 38,
              color: AppColors.gold.withValues(alpha: 0.85),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: palette.textSecondary,
                    height: 1.5,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentDeliveryPreviewSection extends StatelessWidget {
  final AppPalette palette;

  const _PaymentDeliveryPreviewSection({
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      color: palette.background,
      padding: EdgeInsets.symmetric(
        horizontal: width < 768 ? 16 : 32,
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment & Delivery',
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Show customers how they can pay, how deliveries work, and what to expect after ordering.',
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  _InfoCard(
                    palette: palette,
                    icon: Icons.phone_iphone_outlined,
                    title: 'MoMo Payments',
                    subtitle:
                        'Accept MTN MoMo and other convenient local payment options.',
                  ),
                  _InfoCard(
                    palette: palette,
                    icon: Icons.credit_card_outlined,
                    title: 'Card Payments',
                    subtitle:
                        'Support debit and card payment flow for flexible checkout.',
                  ),
                  _InfoCard(
                    palette: palette,
                    icon: Icons.local_shipping_outlined,
                    title: 'Delivery Process',
                    subtitle:
                        'Explain dispatch time, delivery zones, and order confirmation.',
                  ),
                ],
              ),
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PaymentDeliveryPage(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.gold,
                  side: const BorderSide(color: AppColors.gold),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'View Payment & Delivery',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final AppPalette palette;
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.palette,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryBlack,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: palette.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _WhyChooseUsSection extends StatelessWidget {
  final AppPalette palette;

  const _WhyChooseUsSection({
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      color: palette.background,
      padding: EdgeInsets.symmetric(
        horizontal: width < 768 ? 16 : 32,
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              Text(
                'Why people will love DTHC',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Premium styling, mobile-friendly shopping, bold product presentation, and a clean streetwear brand experience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 26),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                alignment: WrapAlignment.center,
                children: [
                  _ReasonCard(
                    palette: palette,
                    icon: Icons.phone_android,
                    title: 'Mobile Friendly',
                    subtitle: 'Looks clean on phone, tablet, and desktop.',
                  ),
                  _ReasonCard(
                    palette: palette,
                    icon: Icons.local_shipping_outlined,
                    title: 'Easy Ordering',
                    subtitle: 'Smooth product selection, cart, and checkout.',
                  ),
                  _ReasonCard(
                    palette: palette,
                    icon: Icons.auto_awesome,
                    title: 'Premium Vibe',
                    subtitle: 'A bold fashion brand feel with polished visuals.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReasonCard extends StatelessWidget {
  final AppPalette palette;
  final IconData icon;
  final String title;
  final String subtitle;

  const _ReasonCard({
    required this.palette,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 62,
            width: 62,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryBlack,
              size: 30,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: palette.textSecondary,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  final StoreSettings storeSettings;

  const _FooterSection({
    required this.storeSettings,
  });

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Container(
      width: double.infinity,
      color: palette.surface,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Center(
        child: Column(
          children: [
            Text(
              storeSettings.storeName,
              style: TextStyle(
                color: palette.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              storeSettings.heroSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Call: ${storeSettings.phoneNumber}',
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Instagram: ${storeSettings.instagram}   •   TikTok: ${storeSettings.tiktok}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: palette.textPrimary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
