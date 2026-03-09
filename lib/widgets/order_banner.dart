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
    final foods = StoreController().getAvailableFoods();

    return Container(
      width: double.infinity,
      color: AppColors.softCream,
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
                'Our Day Specials',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.darkGreen,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Inspired by your flyer design, these pack offers make the homepage colorful, attractive, and ready for real customers.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: AppColors.greyText,
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
                    title: 'Joy Pack',
                    price: 'GHC 100',
                    description:
                        '1 pack jollof or fried rice with grilled chicken, 1 fresh juice, 1 meat pie or spring roll, popcorn and complimentary gifts.',
                    backgroundColor: AppColors.primaryGreen,
                    thumbnailFood: foods.isNotEmpty ? foods[0] : null,
                  ),
                  _SpecialCard(
                    title: 'Friend’s Pack',
                    price: 'GHC 250',
                    description:
                        '2 packs rice with grilled chicken, 4 fresh juices, 4 meat pies, 8 spring rolls, 4 popcorn and complimentary gifts.',
                    backgroundColor: AppColors.deepOrange,
                    thumbnailFood: foods.length > 1 ? foods[1] : null,
                  ),
                  _SpecialCard(
                    title: 'Happy Snack Pack',
                    price: 'GHC 55',
                    description:
                        'Fresh juice, meat pie, spring rolls, popcorn and complimentary gifts for quick enjoyment and light hunger.',
                    backgroundColor: AppColors.darkGreen,
                    thumbnailFood: foods.length > 2 ? foods[2] : null,
                  ),
                  _SpecialCard(
                    title: 'Teacher’s Love Pack',
                    price: 'GHC 120',
                    description:
                        '1 pack jollof or fried rice with grilled chicken, juice, meat pie or sausage roll and complimentary gifts.',
                    backgroundColor: AppColors.warmBrown,
                    thumbnailFood: foods.length > 3 ? foods[3] : null,
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
  final FoodItem? thumbnailFood;

  const _SpecialCard({
    required this.title,
    required this.price,
    required this.description,
    required this.backgroundColor,
    required this.thumbnailFood,
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
                    color: AppColors.white,
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
                      child: _FoodThumb(food: thumbnailFood),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGold,
                    foregroundColor: AppColors.black,
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
                    'Order Pack',
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
                          color: AppColors.white,
                          height: 1.5,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGold,
                          foregroundColor: AppColors.black,
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
                          'Order Pack',
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
                      _FoodThumb(food: thumbnailFood),
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
        color: AppColors.accentGold,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        price,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _FoodThumb extends StatelessWidget {
  final FoodItem? food;

  const _FoodThumb({
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: food == null || food!.imageUrl.trim().isEmpty
          ? const Icon(
              Icons.fastfood,
              size: 42,
              color: AppColors.white,
            )
          : Image.network(
              food!.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.fastfood,
                  size: 42,
                  color: AppColors.white,
                );
              },
            ),
    );
  }
}