import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/food_item.dart';

class FoodCard extends StatefulWidget {
  final FoodItem food;
  final VoidCallback? onAddToCart;

  const FoodCard({
    super.key,
    required this.food,
    this.onAddToCart,
  });

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;
    final isTablet = width >= 700 && width < 1100;

    final imageHeight = isMobile ? 140.0 : (isTablet ? 160.0 : 170.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translateByDouble(0.0, _isHovered ? -4.0 : 0.0, 0.0, 1.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _isHovered
                ? AppColors.primaryGreen.withValues(alpha: 0.20)
                : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.08 : 0.05),
              blurRadius: _isHovered ? 22 : 14,
              offset: Offset(0, _isHovered ? 12 : 8),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FoodImageSection(
                food: widget.food,
                height: imageHeight,
                isMobile: isMobile,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _CategoryBadge(label: widget.food.category),
                  if (widget.food.isFeatured)
                    const _MiniBadge(
                      label: 'Featured',
                      icon: Icons.star_rounded,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.food.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.food.description,
                maxLines: isMobile ? 2 : 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isMobile ? 12.5 : 13.5,
                  height: 1.45,
                  color: AppColors.greyText,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 10 : 12,
                  vertical: isMobile ? 8 : 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.softCream,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                              fontSize: isMobile ? 10.5 : 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.greyText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'GHS ${widget.food.price.toStringAsFixed(2)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isMobile ? 15 : 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _AddButton(
                      onTap: widget.food.isAvailable ? widget.onAddToCart : null,
                      isMobile: isMobile,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoodImageSection extends StatelessWidget {
  final FoodItem food;
  final double height;
  final bool isMobile;

  const _FoodImageSection({
    required this.food,
    required this.height,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = food.imageUrl.trim();
    final hasImage = imageUrl.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: height,
        width: double.infinity,
        color: AppColors.softCream,
        child: hasImage
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
                errorBuilder: (context, error, stackTrace) {
                  return _ImageFallback(isMobile: isMobile);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _ImageFallback(
                    isMobile: isMobile,
                    showLoader: true,
                  );
                },
              )
            : _ImageFallback(isMobile: isMobile),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  final bool isMobile;
  final bool showLoader;

  const _ImageFallback({
    required this.isMobile,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      child: Center(
        child: showLoader
            ? SizedBox(
                width: isMobile ? 22 : 26,
                height: isMobile ? 22 : 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.primaryGreen,
                ),
              )
            : Container(
                padding: EdgeInsets.all(isMobile ? 12 : 14),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.75),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.fastfood_rounded,
                  size: isMobile ? 32 : 38,
                  color: AppColors.primaryGreen,
                ),
              ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;

  const _CategoryBadge({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String label;
  final IconData icon;

  const _MiniBadge({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.deepOrange.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: AppColors.deepOrange,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isMobile;

  const _AddButton({
    required this.onTap,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 14,
          vertical: isMobile ? 10 : 11,
        ),
        decoration: BoxDecoration(
          color: disabled ? AppColors.border : AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(14),
          boxShadow: disabled
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_shopping_cart_rounded,
              size: isMobile ? 15 : 16,
              color: disabled ? AppColors.greyText : AppColors.white,
            ),
            const SizedBox(width: 5),
            Text(
              disabled ? 'N/A' : 'Add',
              style: TextStyle(
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w700,
                color: disabled ? AppColors.greyText : AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}