import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'lookbook_page.dart';
import '../core/app_colors.dart';
import '../data/cart_controller.dart';
import '../data/store_controller.dart';
import '../models/food_item.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/food_card.dart';
import 'admin/admin_dashboard_page.dart';
import 'cart_page.dart';
import 'collections_page.dart';
import 'contact_page.dart';
import 'home_page.dart';
import 'payment_delivery_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final storeController = context.watch<StoreController>();
    final allProducts = storeController.getAvailableProducts();

    final bool isMobile = width < 700;
    final bool isTablet = width >= 700 && width < 1100;

    final List<ProductItem> filteredProducts = selectedCategory == 'All'
        ? allProducts
        : allProducts.where((p) => p.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
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
            onCartTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
            onContactTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactPage()),
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
            onOrderNowTap: () {},
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

    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shop DTHC',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Premium streetwear. Limited drops. Built for real drip.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Color(0xFFBDBDBD),
                ),
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
                    cartCount > 0 ? 'Cart ($cartCount)' : 'Open Cart',
                  ),
                ),
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shop DTHC',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Streetwear collections designed for bold expression.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xFFBDBDBD),
                      ),
                    ),
                  ],
                ),
              ),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined),
                label: Text(
                  cartCount > 0 ? 'Cart ($cartCount)' : 'Open Cart',
                ),
              ),
            ],
          );
  }

  Widget _buildCategoryFilters(bool isMobile) {
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
                  color: isSelected ? AppColors.gold : AppColors.softBlack,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? AppColors.gold : AppColors.charcoal,
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppColors.primaryBlack
                        : AppColors.white,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

    Widget _buildProductGrid({
    required BuildContext context,
    required List<ProductItem> products,
    required bool isMobile,
    required bool isTablet,
  }) {
    if (products.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.softBlack,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.charcoal),
        ),
        child: const Text(
          'No products available in this category yet.',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
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
        ? 0.86
        : isTablet
            ? 0.70
            : 0.63;

    return GridView.builder(
      itemCount: products.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final product = products[index];

        return FoodCard(
          food: product,
          onAddToCart: () {
            context.read<CartController>().addToCart(product);

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.name} added to cart'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }
}