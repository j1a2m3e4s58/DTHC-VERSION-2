import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../data/cart_controller.dart';
import '../data/store_controller.dart';
import '../models/food_item.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/food_card.dart';
import 'admin/admin_dashboard_page.dart';
import 'cart_page.dart';
import 'home_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final StoreController controller = StoreController();

  String selectedCategory = 'All Items';
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final storeController = context.watch<StoreController>();
    final allFoods = storeController.getAvailableFoods();

    final bool isMobile = width < 700;
    final bool isTablet = width >= 700 && width < 1100;

    final List<FoodItem> filteredFoods = selectedCategory == 'All Items'
        ? allFoods
        : allFoods
            .where((food) => food.category == selectedCategory)
            .toList();

    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: Column(
        children: [
          CustomNavbar(
            activeItem: 'Menu',
            onHomeTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            onMenuTap: () {},
            onSpecialPacksTap: () {
              setState(() {
                selectedCategory = 'Special Packs';
              });
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
                MaterialPageRoute(builder: (_) => const CartPage()),
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
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 32,
                      vertical: isMobile ? 20 : 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, isMobile),
                        const SizedBox(height: 24),
                        _buildCategoryFilters(isMobile),
                        const SizedBox(height: 28),
                        _buildFoodSection(
                          context: context,
                          foods: filteredFoods,
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

    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Our Menu',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Browse delicious meals, snacks, drinks, bakery items, and special packs prepared for every craving.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.greyText,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartPage()),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: Text(
                    cartCount > 0 ? 'Open Cart ($cartCount)' : 'Open Cart',
                  ),
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
                      'Our Menu',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Browse delicious meals, snacks, drinks, bakery items, and special packs prepared for every craving.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined),
                label: Text(
                  cartCount > 0 ? 'Open Cart ($cartCount)' : 'Open Cart',
                ),
              ),
            ],
          );
  }

  Widget _buildCategoryFilters(bool isMobile) {
    final categories = StoreController.menuCategories;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final bool isSelected = selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
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
                  horizontal: isMobile ? 16 : 20,
                  vertical: isMobile ? 10 : 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryGreen : AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryGreen
                        : AppColors.primaryGreen.withValues(alpha: 0.18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.white : AppColors.black,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFoodSection({
    required BuildContext context,
    required List<FoodItem> foods,
    required bool isMobile,
    required bool isTablet,
  }) {
    if (foods.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          'No available items found in this category yet.',
          style: TextStyle(
            fontSize: isMobile ? 14 : 15,
            color: AppColors.greyText,
          ),
        ),
      );
    }

    final int crossAxisCount = isMobile
        ? 1
        : isTablet
            ? 2
            : 4;

    final double childAspectRatio = isMobile
        ? 0.88
        : isTablet
            ? 0.80
            : 0.72;

    return GridView.builder(
      itemCount: foods.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final food = foods[index];

        return FoodCard(
          food: food,
          onAddToCart: () {
            context.read<CartController>().addToCart(food);

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${food.name} added to cart'),
                duration: const Duration(milliseconds: 900),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }
}