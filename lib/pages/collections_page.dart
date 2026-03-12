import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contact_page.dart';
import '../core/app_colors.dart';
import '../data/store_controller.dart';
import '../models/food_item.dart';
import '../models/food_pack.dart';
import '../widgets/custom_navbar.dart';
import 'admin/admin_dashboard_page.dart';
import 'cart_page.dart';
import 'home_page.dart';
import 'lookbook_page.dart';
import 'menu_page.dart';
import 'payment_delivery_page.dart';
import 'track_order_page.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StoreController>();
    final featuredCollections = controller.getFeaturedCollections();
    final allCollections = controller.getCollections();

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNavbar(context),
            const _CollectionsHeroSection(),
            if (allCollections.isEmpty)
              const _CollectionsEmptyState()
            else ...[
              if (featuredCollections.isNotEmpty)
                _CollectionsGridSection(
                  title: 'Featured Collections',
                  subtitle:
                      'Explore DTHC curated drops built for premium streetwear energy and bold styling.',
                  collections: featuredCollections,
                ),
              _CollectionsGridSection(
                title:
                    featuredCollections.isNotEmpty ? 'All Collections' : 'Collections',
                subtitle:
                    'From essentials to statement pieces, each collection gives shoppers a different style mood.',
                collections: allCollections,
              ),
            ],
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildNavbar(BuildContext context) {
    return CustomNavbar(
      activeItem: 'Collections',
      onHomeTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      },
      onMenuTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MenuPage()),
        );
      },
      onContactTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ContactPage()),
         );
       },
      onSpecialPacksTap: () {},
      onCartTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CartPage()),
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
          MaterialPageRoute(builder: (_) => const PaymentDeliveryPage()),
        );
      },
      onOrderNowTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MenuPage()),
        );
      },
      onTrackOrderTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TrackOrderPage()),
        );
      },
      onAdminTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
        );
      },
    );
  }
}

class CollectionProductsPage extends StatelessWidget {
  final CollectionModel collection;

  const CollectionProductsPage({
    super.key,
    required this.collection,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StoreController>();
    final products = controller.getProductsByCollection(collection.name);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNavbar(context),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 32,
                vertical: isMobile ? 24 : 34,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1280),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1A1A1A),
                          Color(0xFF0E0E0E),
                        ],
                      ),
                      border: Border.all(color: AppColors.charcoal),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 24,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isMobile ? 18 : 28),
                      child: isMobile
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _CollectionDetailImage(
                                  imageUrl: collection.imageUrl,
                                  height: 260,
                                ),
                                const SizedBox(height: 18),
                                _CollectionDetailText(
                                  collection: collection,
                                  productsCount: products.length,
                                  isMobile: true,
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: _CollectionDetailText(
                                    collection: collection,
                                    productsCount: products.length,
                                    isMobile: false,
                                  ),
                                ),
                                const SizedBox(width: 22),
                                Expanded(
                                  flex: 4,
                                  child: _CollectionDetailImage(
                                    imageUrl: collection.imageUrl,
                                    height: 360,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 32,
                vertical: 8,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1280),
                  child: isMobile
                      ? Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Back to Collections'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.white,
                                  side: const BorderSide(color: AppColors.charcoal),
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MenuPage(
                                        collectionFilter: collection.name,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.shopping_bag_outlined),
                                label: const Text('Open Full Shop'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.gold,
                                  foregroundColor: AppColors.primaryBlack,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Back to Collections'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.white,
                                  side: const BorderSide(color: AppColors.charcoal),
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MenuPage(
                                        collectionFilter: collection.name,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.shopping_bag_outlined),
                                label: const Text('Open Full Shop'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.gold,
                                  foregroundColor: AppColors.primaryBlack,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 32,
                vertical: 22,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1280),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Products in ${collection.name}',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: isMobile ? 24 : 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Browse every piece currently grouped under this collection.',
                        style: TextStyle(
                          color: Color(0xFFBDBDBD),
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (products.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.softBlack,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.charcoal),
                          ),
                          child: const Text(
                            'No products have been added to this collection yet.',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final gridConfig =
                                _ResponsiveGridConfig.forProducts(
                              constraints.maxWidth,
                            );

                            return GridView.builder(
                              itemCount: products.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: gridConfig.crossAxisCount,
                                crossAxisSpacing: 18,
                                mainAxisSpacing: 18,
                                childAspectRatio: gridConfig.childAspectRatio,
                              ),
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return _CollectionDetailProductCard(
                                  product: product,
                                  collectionName: collection.name,
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }

  Widget _buildNavbar(BuildContext context) {
    return CustomNavbar(
      activeItem: 'Collections',
      onHomeTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      },
      onMenuTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MenuPage()),
        );
      },
      onSpecialPacksTap: () {},
      onCartTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CartPage()),
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
          MaterialPageRoute(builder: (_) => const PaymentDeliveryPage()),
        );
      },
      onOrderNowTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MenuPage()),
        );
      },
      onTrackOrderTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TrackOrderPage()),
        );
      },
      onAdminTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
        );
      },
    );
  }
}

class _CollectionsHeroSection extends StatelessWidget {
  const _CollectionsHeroSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 26 : 42,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 20 : 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1A1A),
                  Color(0xFF0E0E0E),
                ],
              ),
              border: Border.all(color: AppColors.charcoal),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 22,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: isMobile
                ? const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroBadge(),
                      SizedBox(height: 18),
                      _HeroTextBlock(isMobile: true),
                      SizedBox(height: 22),
                      _HeroStatsBlock(),
                    ],
                  )
                : const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HeroBadge(),
                            SizedBox(height: 18),
                            _HeroTextBlock(isMobile: false),
                          ],
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: _HeroStatsBlock(),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _CollectionsEmptyState extends StatelessWidget {
  const _CollectionsEmptyState();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 12,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 20 : 28),
            decoration: BoxDecoration(
              color: AppColors.softBlack,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppColors.charcoal),
            ),
            child: Column(
              children: [
                Container(
                  height: 68,
                  width: 68,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.grid_view_rounded,
                    color: AppColors.primaryBlack,
                    size: 34,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'No collections available yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Create collections from the admin panel to organize DTHC drops and give shoppers a more premium browsing experience.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminDashboardPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.primaryBlack,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.admin_panel_settings_outlined),
                  label: const Text(
                    'Open Admin',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Text(
        'DTHC Collections',
        style: TextStyle(
          color: AppColors.primaryBlack,
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _HeroTextBlock extends StatelessWidget {
  final bool isMobile;

  const _HeroTextBlock({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Curated fashion drops for every premium streetwear mood.',
          style: TextStyle(
            color: AppColors.white,
            fontSize: isMobile ? 28 : 34,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Collections make the store feel more complete by grouping pieces into stronger style stories shoppers can easily browse.',
          style: TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 15,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _HeroStatsBlock extends StatelessWidget {
  const _HeroStatsBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroStatTile(
            title: 'Premium Drops',
            subtitle: 'Structured collections for a stronger brand feel.',
          ),
          SizedBox(height: 14),
          _HeroStatTile(
            title: 'Style Stories',
            subtitle: 'Each collection carries its own fashion energy.',
          ),
          SizedBox(height: 14),
          _HeroStatTile(
            title: 'Easy Browsing',
            subtitle: 'Customers can discover products by mood and fit.',
          ),
        ],
      ),
    );
  }
}

class _HeroStatTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HeroStatTile({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: AppColors.primaryBlack,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CollectionsGridSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<CollectionModel> collections;

  const _CollectionsGridSection({
    required this.title,
    required this.subtitle,
    required this.collections,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StoreController>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              double cardWidth;
              if (width >= 1180) {
                cardWidth = (width - 36) / 3;
              } else if (width >= 760) {
                cardWidth = (width - 18) / 2;
              } else {
                cardWidth = width;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: width < 768 ? 24 : 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: collections.map((collection) {
                      final products = controller.getProductsByCollection(
                        collection.name,
                      );

                      return SizedBox(
                        width: cardWidth,
                        child: _CollectionCard(
                          collection: collection,
                          products: products,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final CollectionModel collection;
  final List<ProductItem> products;

  const _CollectionCard({
    required this.collection,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;
    final previewProducts = products.take(isMobile ? 2 : 3).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(28),
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
          _CollectionImage(
            imageUrl: collection.imageUrl,
            height: isMobile ? 180 : 210,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 14 : 18,
              isMobile ? 14 : 18,
              isMobile ? 14 : 18,
              isMobile ? 14 : 18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (collection.isFeatured)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Featured',
                          style: TextStyle(
                            color: AppColors.primaryBlack,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.charcoal,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '${products.length} items',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  collection.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  collection.description,
                  maxLines: isMobile ? 3 : 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                if (previewProducts.isNotEmpty) ...[
                  const Text(
                    'Collection Picks',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...previewProducts.map(
                    (product) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _CollectionProductRow(product: product),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MenuPage(
                            collectionFilter: collection.name,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.primaryBlack,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Explore Collection',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
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

class _CollectionDetailText extends StatelessWidget {
  final CollectionModel collection;
  final int productsCount;
  final bool isMobile;

  const _CollectionDetailText({
    required this.collection,
    required this.productsCount,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Collection View',
                style: TextStyle(
                  color: AppColors.primaryBlack,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.charcoal,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                '$productsCount items',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
            if (collection.isFeatured)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2212),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.gold),
                ),
                child: const Text(
                  'Featured Drop',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          collection.name,
          style: TextStyle(
            color: AppColors.white,
            fontSize: isMobile ? 28 : 34,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          collection.description,
          style: const TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 15,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.softBlack,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.charcoal),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CollectionDetailPoint(
                icon: Icons.auto_awesome,
                title: 'Curated premium styling',
                subtitle:
                    'This collection is grouped to feel intentional, strong, and brand-led.',
              ),
              SizedBox(height: 14),
              _CollectionDetailPoint(
                icon: Icons.checkroom,
                title: 'Faster product discovery',
                subtitle:
                    'Customers can browse a full mood instead of searching piece by piece.',
              ),
              SizedBox(height: 14),
              _CollectionDetailPoint(
                icon: Icons.shopping_bag_outlined,
                title: 'Ready for next shop upgrade',
                subtitle:
                    'This view now connects the collection layer to actual products cleanly.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CollectionDetailPoint extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _CollectionDetailPoint({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryBlack,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 13,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CollectionDetailImage extends StatelessWidget {
  final String imageUrl;
  final double height;

  const _CollectionDetailImage({
    required this.imageUrl,
    this.height = 320,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: height,
        width: double.infinity,
        color: AppColors.charcoal,
        child: imageUrl.trim().isEmpty
            ? const Center(
                child: Icon(
                  Icons.layers_outlined,
                  size: 64,
                  color: AppColors.white,
                ),
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.layers_outlined,
                      size: 64,
                      color: AppColors.white,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _CollectionDetailProductCard extends StatelessWidget {
  final ProductItem product;
  final String collectionName;

  const _CollectionDetailProductCard({
    required this.product,
    required this.collectionName,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.charcoal),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(26),
            ),
            child: Container(
              height: isMobile ? 180 : 210,
              width: double.infinity,
              color: AppColors.charcoal,
              child: product.imageUrl.trim().isEmpty
                  ? Center(
                      child: Icon(
                        _productIcon(product.category),
                        color: AppColors.white,
                        size: 56,
                      ),
                    )
                  : Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            _productIcon(product.category),
                            color: AppColors.white,
                            size: 56,
                          ),
                        );
                      },
                    ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 14 : 18,
                isMobile ? 14 : 18,
                isMobile ? 14 : 18,
                isMobile ? 14 : 18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.charcoal,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          product.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2212),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.gold),
                        ),
                        child: Text(
                          collectionName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: isMobile ? 17 : 19,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    maxLines: isMobile ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 14,
                      height: 1.55,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 14),
                  if (isMobile)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GHS ${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MenuPage(
                                    collectionFilter: collectionName,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gold,
                              foregroundColor: AppColors.primaryBlack,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Shop',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'GHS ${product.price.toStringAsFixed(0)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MenuPage(
                                  collectionFilter: collectionName,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.primaryBlack,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 11,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Shop',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionImage extends StatelessWidget {
  final String imageUrl;
  final double height;

  const _CollectionImage({
    required this.imageUrl,
    this.height = 210,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Container(
        height: height,
        width: double.infinity,
        color: AppColors.charcoal,
        child: imageUrl.trim().isEmpty
            ? const Center(
                child: Icon(
                  Icons.layers_outlined,
                  size: 56,
                  color: AppColors.white,
                ),
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.layers_outlined,
                      size: 56,
                      color: AppColors.white,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _CollectionProductRow extends StatelessWidget {
  final ProductItem product;

  const _CollectionProductRow({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _productIcon(product.category),
              color: AppColors.primaryBlack,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              product.name,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'GHS ${product.price.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveGridConfig {
  final int crossAxisCount;
  final double childAspectRatio;

  const _ResponsiveGridConfig({
    required this.crossAxisCount,
    required this.childAspectRatio,
  });

  factory _ResponsiveGridConfig.forProducts(double width) {
    if (width >= 1180) {
      return const _ResponsiveGridConfig(
        crossAxisCount: 3,
        childAspectRatio: 0.72,
      );
    }
    if (width >= 760) {
      return const _ResponsiveGridConfig(
        crossAxisCount: 2,
        childAspectRatio: 0.80,
      );
    }
    return const _ResponsiveGridConfig(
      crossAxisCount: 1,
      childAspectRatio: 0.95,
    );
  }
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