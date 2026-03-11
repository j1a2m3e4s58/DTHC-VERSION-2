import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../data/store_controller.dart';
import '../models/food_item.dart';

class OrderBanner extends StatelessWidget {
  const OrderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final products = StoreController().getAvailableProducts();

    return Container(
      width: double.infinity,
      color: AppColors.softBlack,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 28 : 42,
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
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Highlight your strongest DTHC drops with bold visuals and premium streetwear presentation.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Color(0xFFBDBDBD),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: width > 1100
                    ? 2
                    : width > 700
                        ? 2
                        : 1,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: width < 700 ? 1.05 : 1.45,
                children: [
                  _SpecialCard(
                    title: 'Essentials Drop',
                    price: 'From GHS 85',
                    description:
                        'Clean everyday pieces designed for simple premium fits, easy layering, and all-day drip.',
                    backgroundColor: AppColors.primaryBlack,
                    thumbnailProduct: products.isNotEmpty ? products[0] : null,
                  ),
                  _SpecialCard(
                    title: 'Street Kings',
                    price: 'From GHS 140',
                    description:
                        'Bold statement pieces made for standout styling, confident looks, and attention-grabbing streetwear.',
                    backgroundColor: AppColors.charcoal,
                    thumbnailProduct: products.length > 1 ? products[1] : null,
                  ),
                  _SpecialCard(
                    title: 'Urban Motion',
                    price: 'From GHS 295',
                    description:
                        'Sneaker-led collection focused on movement, comfort, and polished city-ready fashion.',
                    backgroundColor: AppColors.primaryBlack,
                    thumbnailProduct: products.length > 2 ? products[2] : null,
                  ),
                  _SpecialCard(
                    title: 'Luxury Street',
                    price: 'From GHS 95',
                    description:
                        'Accessories and elevated fashion essentials with a sharper premium edge.',
                    backgroundColor: AppColors.charcoal,
                    thumbnailProduct: products.length > 3 ? products[3] : null,
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

class _SpecialCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final Color backgroundColor;
  final ProductItem? thumbnailProduct;

  const _SpecialCard({
    required this.title,
    required this.price,
    required this.description,
    required this.backgroundColor,
    required this.thumbnailProduct,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.charcoal),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFFDDDDDD),
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _PriceBadge(price: price),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _ProductThumb(product: thumbnailProduct),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.primaryBlack,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Shop Collection',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Color(0xFFDDDDDD),
                          height: 1.5,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          foregroundColor: AppColors.primaryBlack,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Shop Collection',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _PriceBadge(price: price),
                      const SizedBox(height: 18),
                      _ProductThumb(product: thumbnailProduct),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final String price;

  const _PriceBadge({
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        price,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: AppColors.primaryBlack,
        ),
      ),
    );
  }
}

class _ProductThumb extends StatelessWidget {
  final ProductItem? product;

  const _ProductThumb({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: product == null || product!.imageUrl.trim().isEmpty
          ? const Icon(
              Icons.shopping_bag_outlined,
              size: 42,
              color: AppColors.white,
            )
          : Image.network(
              product!.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.shopping_bag_outlined,
                  size: 42,
                  color: AppColors.white,
                );
              },
            ),
    );
  }
}