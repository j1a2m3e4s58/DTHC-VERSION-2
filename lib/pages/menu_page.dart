import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../data/cart_controller.dart';
import '../data/store_controller.dart';
import '../data/theme_controller.dart';
import '../models/food_item.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/food_card.dart';
import '../widgets/store_image.dart';
import 'admin/admin_dashboard_page.dart';
import 'cart_page.dart';
import 'collections_page.dart';
import 'contact_page.dart';
import 'home_page.dart';
import 'lookbook_page.dart';
import 'payment_delivery_page.dart';
import 'track_order_page.dart';

class MenuPage extends StatefulWidget {
  final String? collectionFilter;
  final String? categoryFilter;
  final String? sectionFilter;

  const MenuPage({
    super.key,
    this.collectionFilter,
    this.categoryFilter,
    this.sectionFilter,
  });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String? get _activeCollectionFilter {
    final value = widget.collectionFilter?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  String? get _activeCategoryFilter {
    final value = widget.categoryFilter?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  String? get _activeSectionFilter {
    final value = widget.sectionFilter?.trim().toLowerCase();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  @override
  void initState() {
    super.initState();

    if (_activeCategoryFilter != null &&
        StoreController.shopCategories.contains(_activeCategoryFilter)) {
      selectedCategory = _activeCategoryFilter!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCartPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartPage()),
    );
  }

  void _addProductToCart(BuildContext context, ProductItem product) {
    context.read<CartController>().addToCart(product);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  bool _matchesSectionFilter(ProductItem product) {
    switch (_activeSectionFilter) {
      case 'new-drops':
        return product.isNewArrival;
      case 'trending-now':
        return product.isFeatured || product.isBestSeller;
      case 'best-sellers':
        return product.isBestSeller;
      case 'limited-edition':
        final collection = product.collection.trim().toLowerCase();
        return collection == 'luxury street' || collection == 'night code';
      default:
        return true;
    }
  }

  List<ProductItem> _filterProducts(List<ProductItem> allProducts) {
    final query = _searchQuery.trim().toLowerCase();

    List<ProductItem> workingList = allProducts;

    if (_activeCollectionFilter != null) {
      workingList = workingList.where((product) {
        return product.collection.trim().toLowerCase() ==
            _activeCollectionFilter!.toLowerCase();
      }).toList();
    }

    if (_activeSectionFilter != null) {
      workingList = workingList.where(_matchesSectionFilter).toList();
    }

    final effectiveCategory = _activeCategoryFilter ?? selectedCategory;

    final categoryFiltered = effectiveCategory == 'All'
        ? workingList
        : workingList.where((product) {
            return product.category.trim().toLowerCase() ==
                effectiveCategory.trim().toLowerCase();
          }).toList();

    if (query.isEmpty) return categoryFiltered;

    return categoryFiltered.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.collection.toLowerCase().contains(query);
    }).toList();
  }

  List<ProductItem> _buildQuickSearchMatches(List<ProductItem> allProducts) {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) return [];

    List<ProductItem> workingList = allProducts;

    if (_activeCollectionFilter != null) {
      workingList = workingList.where((product) {
        return product.collection.trim().toLowerCase() ==
            _activeCollectionFilter!.toLowerCase();
      }).toList();
    }

    if (_activeSectionFilter != null) {
      workingList = workingList.where(_matchesSectionFilter).toList();
    }

    if (_activeCategoryFilter != null && _activeCategoryFilter != 'All') {
      workingList = workingList.where((product) {
        return product.category.trim().toLowerCase() ==
            _activeCategoryFilter!.toLowerCase();
      }).toList();
    }

    final matches = workingList.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.collection.toLowerCase().contains(query);
    }).toList();

    return matches.take(6).toList();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _clearCollectionFilter() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MenuPage()),
    );
  }

  void _clearCategoryFilter() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MenuPage()),
    );
  }

  void _clearSectionFilter() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MenuPage()),
    );
  }

  String _sectionTitle(String section) {
    switch (section) {
      case 'new-drops':
        return 'New Drops';
      case 'trending-now':
        return 'Trending Now';
      case 'best-sellers':
        return 'Best Sellers';
      case 'limited-edition':
        return 'Limited Edition';
      default:
        return 'Shop DTHC';
    }
  }

  String _sectionSubtitle(String section) {
    switch (section) {
      case 'new-drops':
        return 'Fresh arrivals just added to the DTHC lineup.';
      case 'trending-now':
        return 'The hottest pieces customers are checking out right now.';
      case 'best-sellers':
        return 'Top-performing products shoppers keep coming back for.';
      case 'limited-edition':
        return 'Premium statement pieces from exclusive DTHC drops.';
      default:
        return 'Premium streetwear. Limited drops. Built for real drip.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final storeController = context.watch<StoreController>();
    final storeSettings = storeController.getStoreSettings();
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);
    final allProducts = storeController.getAvailableProducts();

    final bool isMobile = width < 700;
    final bool isTablet = width >= 700 && width < 1100;

    final List<ProductItem> filteredProducts = _filterProducts(allProducts);
    final List<ProductItem> quickMatches =
        _buildQuickSearchMatches(allProducts);

    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        children: [
          CustomNavbar(
            activeItem: 'Shop',
            onHomeTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            onMenuTap: () {},
            onSpecialPacksTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CollectionsPage()),
              );
            },
            onCartTap: () => _openCartPage(context),
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
            onOrderNowTap: () => _openCartPage(context),
            onAdminTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminDashboardPage(),
                ),
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 14 : 32,
                      vertical: isMobile ? 16 : 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, isMobile),
                        if (_activeSectionFilter != null) ...[
                          const SizedBox(height: 18),
                          _FilterBanner(
                            label: 'Section Filter',
                            value: _sectionTitle(_activeSectionFilter!),
                            borderColor: AppColors.gold,
                            badgeColor: AppColors.gold,
                            badgeTextColor: AppColors.primaryBlack,
                            onClear: _clearSectionFilter,
                          ),
                        ],
                        if (_activeCollectionFilter != null) ...[
                          const SizedBox(height: 18),
                          _FilterBanner(
                            label: 'Collection Filter',
                            value: _activeCollectionFilter!,
                            borderColor: AppColors.gold,
                            badgeColor: AppColors.gold,
                            badgeTextColor: AppColors.primaryBlack,
                            onClear: _clearCollectionFilter,
                          ),
                        ],
                        if (_activeCategoryFilter != null &&
                            _activeCategoryFilter != 'All') ...[
                          const SizedBox(height: 18),
                          _FilterBanner(
                            label: 'Category Filter',
                            value: _activeCategoryFilter!,
                            borderColor: AppColors.charcoal,
                            badgeColor: AppColors.softBlack,
                            badgeTextColor: AppColors.white,
                            onClear: _clearCategoryFilter,
                          ),
                        ],
                        const SizedBox(height: 20),
                        _ShopSearchPanel(
                          palette: palette,
                          title: storeSettings.shopSearchTitle,
                          subtitle: storeSettings.shopSearchSubtitle,
                          controller: _searchController,
                          query: _searchQuery,
                          quickMatches: quickMatches,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          onClear: _clearSearch,
                          onAddQuickMatch: (product) {
                            _addProductToCart(context, product);
                            _openCartPage(context);
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildCategoryFilters(isMobile),
                        const SizedBox(height: 16),
                        _buildResultSummary(filteredProducts.length),
                        const SizedBox(height: 20),
                        _buildProductGrid(
                          context: context,
                          products: filteredProducts,
                          isMobile: isMobile,
                          isTablet: isTablet,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    final cartCount = context.watch<CartController>().totalItemsCount;
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);
    final headerBadge = context.watch<StoreController>().getStoreSettings().shopHeaderBadge;

    final title = _activeSectionFilter != null
        ? _sectionTitle(_activeSectionFilter!)
        : _activeCollectionFilter != null
            ? '${_activeCollectionFilter!} Collection'
            : _activeCategoryFilter != null && _activeCategoryFilter != 'All'
                ? '${_activeCategoryFilter!} Edit'
                : 'Shop DTHC';

    final subtitle = _activeSectionFilter != null
        ? _sectionSubtitle(_activeSectionFilter!)
        : _activeCollectionFilter != null
            ? 'Browsing products filtered from the $_activeCollectionFilter collection.'
            : _activeCategoryFilter != null && _activeCategoryFilter != 'All'
                ? 'Browsing products filtered to the $_activeCategoryFilter category.'
                : 'Premium streetwear. Limited drops. Built for real drip.';

    return isMobile
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: palette.heroGradient,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: palette.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    headerBadge,
                    style: TextStyle(
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
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: palette.textOnStrong,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _ShopInfoPill(label: 'Fast filters'),
                    _ShopInfoPill(label: 'Large previews'),
                    _ShopInfoPill(label: 'Quick add'),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.primaryBlack,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => _openCartPage(context),
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: Text(
                      cartCount > 0 ? 'Cart ($cartCount)' : 'Open Cart',
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: palette.heroGradient,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: palette.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          headerBadge,
                          style: TextStyle(
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
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: palette.textOnStrong,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: palette.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _ShopInfoPill(label: 'Fast filters'),
                          _ShopInfoPill(label: 'Large previews'),
                          _ShopInfoPill(label: 'Quick add'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                ElevatedButton.icon(
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
                  onPressed: () => _openCartPage(context),
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: Text(
                    cartCount > 0 ? 'Cart ($cartCount)' : 'Open Cart',
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildCategoryFilters(bool isMobile) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);
    const categories = [
      'All',
      'Tees',
      'Sneakers',
      'Caps',
      'Chains',
      'Belts',
      'Socks',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final effectiveSelectedCategory =
              _activeCategoryFilter ?? selectedCategory;
          final bool isSelected = effectiveSelectedCategory == category;

          return Padding(
            padding: EdgeInsets.only(right: isMobile ? 10 : 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                setState(() {
                  selectedCategory = category;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 14 : 20,
                  vertical: isMobile ? 9 : 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.gold : palette.surface,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? AppColors.gold : palette.border,
                  ),
                  boxShadow: isSelected
                      ? []
                      : const [
                          BoxShadow(
                            color: Color(0x10000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: isMobile ? 12.5 : 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppColors.primaryBlack
                        : palette.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResultSummary(int count) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);
    final hasSearch = _searchQuery.trim().isNotEmpty;
    final hasCollection = _activeCollectionFilter != null;
    final hasCategory =
        _activeCategoryFilter != null && _activeCategoryFilter != 'All';
    final hasSection = _activeSectionFilter != null;

    String label;
    if (hasSearch && hasSection) {
      label =
          '$count result${count == 1 ? '' : 's'} for "${_searchQuery.trim()}" in ${_sectionTitle(_activeSectionFilter!)}';
    } else if (hasSearch && hasCollection) {
      label =
          '$count result${count == 1 ? '' : 's'} for "${_searchQuery.trim()}" in ${_activeCollectionFilter!}';
    } else if (hasSearch && hasCategory) {
      label =
          '$count result${count == 1 ? '' : 's'} for "${_searchQuery.trim()}" in ${_activeCategoryFilter!}';
    } else if (hasSearch) {
      label =
          '$count result${count == 1 ? '' : 's'} for "${_searchQuery.trim()}"';
    } else if (hasSection) {
      label =
          '$count product${count == 1 ? '' : 's'} in ${_sectionTitle(_activeSectionFilter!)}';
    } else if (hasCollection) {
      label =
          '$count product${count == 1 ? '' : 's'} in ${_activeCollectionFilter!}';
    } else if (hasCategory) {
      label =
          '$count product${count == 1 ? '' : 's'} in ${_activeCategoryFilter!}';
    } else {
      label = '$count product${count == 1 ? '' : 's'}';
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: palette.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: palette.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid({
    required BuildContext context,
    required List<ProductItem> products,
    required bool isMobile,
    required bool isTablet,
  }) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);
    if (products.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No matching products found.',
              style: TextStyle(
                color: palette.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try another keyword or switch category to explore more drops.',
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        double cardWidth;
        if (width >= 1280) {
          cardWidth = (width - 36) / 3;
        } else if (width >= 980) {
          cardWidth = (width - 18) / 2;
        } else if (width >= 760) {
          cardWidth = (width - 18) / 2;
        } else {
          cardWidth = width;
        }

        return Wrap(
          spacing: isMobile ? 16 : 18,
          runSpacing: isMobile ? 16 : 18,
          children: products.map((product) {
            return SizedBox(
              width: cardWidth,
              child: FoodCard(
                food: product,
                preferExpandedImage: true,
                onAddToCart: (selectedProduct) =>
                    _addProductToCart(context, selectedProduct),
                onGoToCart: () => _openCartPage(context),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _FilterBanner extends StatelessWidget {
  final String label;
  final String value;
  final Color borderColor;
  final Color badgeColor;
  final Color badgeTextColor;
  final VoidCallback onClear;

  const _FilterBanner({
    required this.label,
    required this.value,
    required this.borderColor,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor == AppColors.charcoal ? palette.border : borderColor),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: badgeTextColor,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          OutlinedButton.icon(
            onPressed: onClear,
            style: OutlinedButton.styleFrom(
              foregroundColor: palette.textPrimary,
              side: BorderSide(color: palette.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.close_rounded),
            label: const Text(
              'Clear Filter',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopSearchPanel extends StatelessWidget {
  final AppPalette palette;
  final String title;
  final String subtitle;
  final TextEditingController controller;
  final String query;
  final List<ProductItem> quickMatches;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final ValueChanged<ProductItem> onAddQuickMatch;

  const _ShopSearchPanel({
    required this.palette,
    required this.title,
    required this.subtitle,
    required this.controller,
    required this.query,
    required this.quickMatches,
    required this.onChanged,
    required this.onClear,
    required this.onAddQuickMatch,
  });

  @override
  Widget build(BuildContext context) {
    final hasQuery = query.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
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
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _TopShopPill(label: 'All products'),
              _TopShopPill(label: 'Quick results'),
              _TopShopPill(label: 'Category browse'),
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
                hintText: 'Search by product name, category, collection...',
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
            const SizedBox(height: 16),
            if (quickMatches.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: palette.surfaceAlt,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: palette.border),
                ),
                child: Text(
                  'No quick matches yet. Try another keyword.',
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 13.5,
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
                  children: quickMatches
                      .map(
                        (product) => _QuickSearchTile(
                          product: product,
                          onTap: () => onAddQuickMatch(product),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _QuickSearchTile extends StatelessWidget {
  final ProductItem product;
  final VoidCallback onTap;

  const _QuickSearchTile({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.imageUrl.trim();
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 58,
                height: 58,
                color: palette.surfaceAlt,
                child: imageUrl.isEmpty
                    ? Icon(
                        Icons.shopping_bag_outlined,
                        color: palette.textPrimary,
                      )
                    : StoreImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        errorWidget: Icon(
                          Icons.shopping_bag_outlined,
                          color: palette.textPrimary,
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
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.category} • ${product.collection}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: palette.textSecondary,
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

class _ShopInfoPill extends StatelessWidget {
  final String label;

  const _ShopInfoPill({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

class _TopShopPill extends StatelessWidget {
  final String label;

  const _TopShopPill({
    required this.label,
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
      child: Text(
        label,
        style: TextStyle(
          color: palette.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
