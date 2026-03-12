import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'track_order_page.dart';
import '../core/app_colors.dart';
import '../data/cart_controller.dart';
import '../data/store_controller.dart';
import '../models/category_item.dart';
import '../models/food_item.dart';
import '../models/store_settings.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/hero_section.dart';
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
    final categories = controller.getCategories();
    final featuredProducts = controller.getFeaturedProducts();
    final newArrivals = controller.getNewArrivals();
    final bestSellers = controller.getBestSellers();
    final allProducts = controller.getAvailableProducts();
    final trendingProducts = _buildTrendingProducts(allProducts);
    final limitedEditionProducts = _buildLimitedEditionProducts(allProducts);
    final searchResults = _buildSearchResults(allProducts);

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
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
              categories: categories,
              onCategoryTap: _openShopCategory,
            ),
            const _SiteHighlightsSection(),
            _ConversionHeroStrip(
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
            const _CollectionsPreviewSection(),
            const _LookbookPreviewSection(),
            const _PaymentDeliveryPreviewSection(),
            const _WhyChooseUsSection(),
            _FooterSection(storeSettings: storeSettings),
          ],
        ),
      ),
    );
  }
}

class _HomeSearchSection extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final List<ProductItem> results;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final ValueChanged<ProductItem> onResultTap;

  const _HomeSearchSection({
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
      color: AppColors.primaryBlack,
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 32,
        26,
        isMobile ? 16 : 32,
        8,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            decoration: BoxDecoration(
              color: AppColors.softBlack,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppColors.charcoal),
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
                const Text(
                  'Search DTHC',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Live product search with quick image results for a more premium shopping flow.',
                  style: TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlack,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.charcoal),
                  ),
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    style: const TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      hintText: 'Search tees, sneakers, caps, chains, belts...',
                      hintStyle: const TextStyle(color: Color(0xFF8D8D8D)),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.gold,
                      ),
                      suffixIcon: hasQuery
                          ? IconButton(
                              onPressed: onClear,
                              icon: const Icon(
                                Icons.close_rounded,
                                color: AppColors.white,
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
                        color: AppColors.primaryBlack,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.charcoal),
                      ),
                      child: const Text(
                        'No matching products found yet.',
                        style: TextStyle(
                          color: Color(0xFFBDBDBD),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlack,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.charcoal),
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
                color: AppColors.charcoal,
                child: imageUrl.isEmpty
                    ? const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.white,
                      )
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.shopping_bag_outlined,
                            color: AppColors.white,
                          );
                        },
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
                      color: AppColors.white,
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
                      color: Color(0xFFBDBDBD),
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
  final List<CategoryItem> categories;
  final ValueChanged<String> onCategoryTap;

  const _QuickCategorySection({
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      color: AppColors.softBlack,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 30,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shop by category',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Explore premium streetwear pieces from tees, sneakers, caps, chains, belts, and socks.',
                style: TextStyle(
                  color: Color(0xFFBDBDBD),
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
    return Container(
      decoration: BoxDecoration(
        color: active ? AppColors.gold : AppColors.charcoal,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: active ? AppColors.gold : AppColors.charcoal,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: active ? AppColors.primaryBlack : AppColors.white,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: active ? AppColors.primaryBlack : AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SiteHighlightsSection extends StatelessWidget {
  const _SiteHighlightsSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      color: AppColors.primaryBlack,
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
    return Container(
      width: 400,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.charcoal),
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
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFFBDBDBD),
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
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;

  const _ConversionHeroStrip({
    required this.onPrimaryTap,
    required this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      color: AppColors.softBlack,
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
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.charcoal),
            ),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'The latest DTHC drop is live.',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Push visitors straight into the strongest buying paths: fresh arrivals and exclusive premium pieces.',
                        style: TextStyle(
                          color: Color(0xFFDBDBDB),
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
                          child: const Text(
                            'Shop New Drops',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: onSecondaryTap,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.white,
                            side: const BorderSide(color: AppColors.gold),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Open Limited Edition',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'The latest DTHC drop is live.',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                height: 1.05,
                              ),
                            ),
                            SizedBox(height: 14),
                            Text(
                              'Push visitors straight into the strongest buying paths: fresh arrivals and exclusive premium pieces.',
                              style: TextStyle(
                                color: Color(0xFFDBDBDB),
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
                              child: const Text(
                                'Shop New Drops',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 220,
                            child: OutlinedButton(
                              onPressed: onSecondaryTap,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.white,
                                side: const BorderSide(color: AppColors.gold),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Open Limited Edition',
                                style: TextStyle(fontWeight: FontWeight.w800),
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

    return Container(
      width: double.infinity,
      color: darkSection ? AppColors.softBlack : AppColors.primaryBlack,
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
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFFBDBDBD),
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
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                subtitle,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFFBDBDBD),
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
                    color: AppColors.charcoal,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.charcoal),
                  ),
                  child: const Text(
                    'No products available in this section yet.',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                GridView.builder(
                  itemCount: displayProducts.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width > 1100
                        ? 4
                        : width > 700
                            ? 2
                            : 1,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: width > 1100
                        ? 0.72
                        : width > 700
                            ? 0.82
                            : 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final product = displayProducts[index];
                    return _ProductPreviewCard(
                      product: product,
                      onAddToCart: () => onAddToCart(product),
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

    return Container(
      width: double.infinity,
      color: AppColors.primaryBlack,
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
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFFBDBDBD),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              GridView.builder(
                itemCount: products.take(4).length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: width > 1100
                      ? 4
                      : width > 700
                          ? 2
                          : 1,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: width > 1100
                      ? 0.72
                      : width > 700
                          ? 0.82
                          : 0.95,
                ),
                itemBuilder: (context, index) {
                  final product = products.take(4).toList()[index];
                  return _ProductPreviewCard(
                    product: product,
                    onAddToCart: () => onAddToCart(product),
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

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.charcoal),
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
              height: 130,
              width: double.infinity,
              color: AppColors.charcoal,
              child: imageUrl.isEmpty
                  ? Center(
                      child: Icon(
                        _productIcon(product.category),
                        size: 56,
                        color: AppColors.white,
                      ),
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            _productIcon(product.category),
                            size: 56,
                            color: AppColors.white,
                          ),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            primaryEntry.title.isNotEmpty ? primaryEntry.title : product.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            primaryEntry.description.isNotEmpty
                ? primaryEntry.description
                : product.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFBDBDBD),
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
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
                  backgroundColor: AppColors.white,
                  textColor: AppColors.primaryBlack,
                ),
              if (product.isFeatured)
                _TagChip(
                  label: 'Trending',
                  backgroundColor: AppColors.charcoal,
                  textColor: AppColors.white,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'GHS ${primaryEntry.price.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.gold,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
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
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.charcoal,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.charcoal),
                ),
                child: IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} saved for later.'),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.favorite_border,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
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
  const _CollectionsPreviewSection();

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
      color: AppColors.softBlack,
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
              const Text(
                'Featured Collections',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Give shoppers a structured way to explore drops, premium essentials, and bold statement pieces.',
                style: TextStyle(
                  color: Color(0xFFBDBDBD),
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
                    width: cardWidth,
                    title: 'Urban Essentials',
                    subtitle:
                        'Minimal black-and-gold everyday pieces for clean city styling.',
                    icon: Icons.layers_outlined,
                  ),
                  _CollectionPreviewCard(
                    width: cardWidth,
                    title: 'Weekend Heat',
                    subtitle:
                        'Statement sneakers, graphic tees, and standout accessories.',
                    icon: Icons.local_fire_department_outlined,
                  ),
                  _CollectionPreviewCard(
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
  final double width;
  final String title;
  final String subtitle;
  final IconData icon;

  const _CollectionPreviewCard({
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
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
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
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFFBDBDBD),
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
  const _LookbookPreviewSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      color: AppColors.primaryBlack,
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
              const Text(
                'Lookbook Preview',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'A premium fashion gallery section helps the brand feel more editorial and high-end.',
                style: TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 768) {
                    return Column(
                      children: const [
                        _LookbookTile(
                          height: 180,
                          icon: Icons.camera_alt_outlined,
                          title: 'Street Fit 01',
                          subtitle: 'Monochrome layering with statement sneakers',
                        ),
                        SizedBox(height: 16),
                        _LookbookTile(
                          height: 180,
                          icon: Icons.flash_on_outlined,
                          title: 'Street Fit 02',
                          subtitle: 'Bold drop styling with premium accessories',
                        ),
                        SizedBox(height: 16),
                        _LookbookTile(
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
                    children: const [
                      Expanded(
                        flex: 2,
                        child: _LookbookTile(
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
                              height: 182,
                              icon: Icons.flash_on_outlined,
                              title: 'Street Fit 02',
                              subtitle:
                                  'Bold drop styling with premium accessories',
                            ),
                            SizedBox(height: 16),
                            _LookbookTile(
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
  final double height;
  final IconData icon;
  final String title;
  final String subtitle;

  const _LookbookTile({
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2B2B2B),
            Color(0xFF121212),
          ],
        ),
        border: Border.all(color: AppColors.charcoal),
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
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFFD0D0D0),
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
  const _PaymentDeliveryPreviewSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      color: AppColors.softBlack,
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
              const Text(
                'Payment & Delivery',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Show customers how they can pay, how deliveries work, and what to expect after ordering.',
                style: TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                children: const [
                  _InfoCard(
                    icon: Icons.phone_iphone_outlined,
                    title: 'MoMo Payments',
                    subtitle:
                        'Accept MTN MoMo and other convenient local payment options.',
                  ),
                  _InfoCard(
                    icon: Icons.credit_card_outlined,
                    title: 'Card Payments',
                    subtitle:
                        'Support debit and card payment flow for flexible checkout.',
                  ),
                  _InfoCard(
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
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
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
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
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
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFFBDBDBD),
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
  const _WhyChooseUsSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      color: AppColors.softBlack,
      padding: EdgeInsets.symmetric(
        horizontal: width < 768 ? 16 : 32,
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              const Text(
                'Why people will love DTHC',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Premium styling, mobile-friendly shopping, bold product presentation, and a clean streetwear brand experience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 26),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                alignment: WrapAlignment.center,
                children: const [
                  _ReasonCard(
                    icon: Icons.phone_android,
                    title: 'Mobile Friendly',
                    subtitle: 'Looks clean on phone, tablet, and desktop.',
                  ),
                  _ReasonCard(
                    icon: Icons.local_shipping_outlined,
                    title: 'Easy Ordering',
                    subtitle: 'Smooth product selection, cart, and checkout.',
                  ),
                  _ReasonCard(
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
  final IconData icon;
  final String title;
  final String subtitle;

  const _ReasonCard({
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
        color: AppColors.charcoal,
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFBDBDBD),
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
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Center(
        child: Column(
          children: [
            Text(
              storeSettings.storeName,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              storeSettings.heroSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFBDBDBD),
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
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}