import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../data/store_controller.dart';
import '../models/category_item.dart';
import '../models/food_item.dart';
import '../models/store_settings.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/hero_section.dart';
import '../widgets/order_banner.dart';
import 'admin/admin_dashboard_page.dart';
import 'cart_page.dart';
import 'menu_page.dart';
import '../data/cart_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StoreController>();
    final storeSettings = controller.getStoreSettings();
    final categories = controller.getCategories();
    final featuredFoods = controller.getFeaturedFoods();
    return Scaffold(
      backgroundColor: AppColors.softCream,
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
                  MaterialPageRoute(builder: (_) => const MenuPage()),
                );
              },
              onCartTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
              onContactTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Contact section coming next.'),
                  ),
                );
              },
              onTrackOrderTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Your order tracking feature will be available after the store confirms your order.',
                    ),
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
            ),
            _QuickCategorySection(categories: categories),
            const OrderBanner(),
            _FeaturedSection(featuredFoods: featuredFoods),
            const _WhyChooseUsSection(),
            _FooterSection(storeSettings: storeSettings),
          ],
        ),
      ),
    );
  }
}

class _QuickCategorySection extends StatelessWidget {
  final List<CategoryItem> categories;

  const _QuickCategorySection({
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 26,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Browse by category',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.darkGreen,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Help customers quickly jump into the kind of food or drink they want.',
                style: TextStyle(
                  color: AppColors.greyText,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: categories
                    .map(
                      (category) => InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MenuPage(),
                            ),
                          );
                        },
                        child: _CategoryChip(
                          title: category.name,
                          icon: _mapCategoryIcon(category.icon),
                          active: category.id == 'all',
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
      case 'rice':
        return Icons.rice_bowl_outlined;
      case 'snack':
        return Icons.cookie_outlined;
      case 'drink':
        return Icons.local_drink_outlined;
      case 'offer':
        return Icons.local_offer_outlined;
      case 'bakery':
        return Icons.bakery_dining_outlined;
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
        color: active ? AppColors.primaryGreen : AppColors.softCream,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: active ? AppColors.primaryGreen : AppColors.border,
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
              color: active ? AppColors.white : AppColors.darkGreen,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: active ? AppColors.white : AppColors.darkGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  final List<FoodItem> featuredFoods;

  const _FeaturedSection({
    required this.featuredFoods,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      color: AppColors.white,
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
                'Featured Favorites',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppColors.darkGreen,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Make the homepage feel like a real food-ordering platform with quick, attractive meal cards.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.greyText,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              GridView.builder(
                itemCount: featuredFoods.length,
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
                  final food = featuredFoods[index];
                  return _FoodPreviewCard(food: food);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoodPreviewCard extends StatelessWidget {
  final FoodItem food;

  const _FoodPreviewCard({
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.softCream,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
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
              color: AppColors.lightGreen,
              child: food.imageUrl.trim().isEmpty
                  ? Center(
                      child: Icon(
                        _foodIcon(food.category),
                        size: 56,
                        color: AppColors.white,
                      ),
                    )
                  : Image.network(
                      food.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            _foodIcon(food.category),
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
            food.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            food.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.greyText,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            'GHC ${food.price.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.deepOrange,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: food.isAvailable
                      ? () {
                          context.read<CartController>().addToCart(food);

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${food.name} added to cart'),
                              duration: const Duration(milliseconds: 900),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.border,
                    disabledForegroundColor: AppColors.greyText,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    food.isAvailable ? 'Add to Cart' : 'Out of Stock',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${food.name} saved for later.'),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.favorite_border,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _foodIcon(String category) {
    switch (category) {
      case 'Rice Meals':
        return Icons.rice_bowl;
      case 'Drinks':
        return Icons.local_drink;
      case 'Bakery':
        return Icons.bakery_dining;
      case 'Snacks':
        return Icons.cookie;
      case 'Special Packs':
        return Icons.local_offer;
      default:
        return Icons.fastfood;
    }
  }
}

class _WhyChooseUsSection extends StatelessWidget {
  const _WhyChooseUsSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      color: AppColors.cream,
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
                'Why customers will love SuperFoods',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppColors.darkGreen,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Responsive design, clear ordering flow, colorful presentation, and attractive packs for every kind of buyer.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.greyText,
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
                    subtitle: 'Looks great on phones, tablets, and desktop.',
                  ),
                  _ReasonCard(
                    icon: Icons.lock_clock,
                    title: 'Fast Ordering',
                    subtitle: 'Quick item selection, cart, and checkout flow.',
                  ),
                  _ReasonCard(
                    icon: Icons.palette,
                    title: 'Colorful Branding',
                    subtitle: 'Matches the flyer feel in a modern UI.',
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
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
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryGreen,
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
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.greyText,
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
      color: AppColors.darkGreen,
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
                color: Color(0xFFD1FAE5),
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Call: ${storeSettings.phoneNumber}',
              style: const TextStyle(
                color: AppColors.accentGold,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}