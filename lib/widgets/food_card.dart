import 'dart:async';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/food_item.dart';

class FoodCard extends StatefulWidget {
  final ProductItem food;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;
    final isTablet = screenWidth >= 700 && screenWidth < 1100;

    final imageHeight = isMobile ? 145.0 : (isTablet ? 175.0 : 205.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translateByDouble(0, _isHovered ? -4.0 : 0, 0, 1),
        decoration: BoxDecoration(
          color: AppColors.softBlack,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _isHovered ? AppColors.gold : AppColors.charcoal,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.18 : 0.10),
              blurRadius: _isHovered ? 22 : 12,
              offset: Offset(0, _isHovered ? 10 : 7),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FoodImageSection(
                food: widget.food,
                height: imageHeight,
                isMobile: isMobile,
              ),
              SizedBox(height: isMobile ? 10 : 12),
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
                  if (widget.food.isNewArrival)
                    const _MiniBadge(
                      label: 'New',
                      icon: Icons.local_fire_department_outlined,
                    ),
                  if (widget.food.isBestSeller)
                    const _MiniBadge(
                      label: 'Best Seller',
                      icon: Icons.workspace_premium_outlined,
                    ),
                ],
              ),
              SizedBox(height: isMobile ? 10 : 12),
              Text(
                widget.food.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.food.description,
                maxLines: isMobile ? 2 : 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isMobile ? 12.5 : 13.5,
                  height: 1.4,
                  color: const Color(0xFFBDBDBD),
                ),
              ),
              SizedBox(height: isMobile ? 12 : 14),
              _PriceAndActionSection(
                food: widget.food,
                onAddToCart: widget.food.isAvailable ? widget.onAddToCart : null,
                isMobile: isMobile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceAndActionSection extends StatelessWidget {
  final ProductItem food;
  final VoidCallback? onAddToCart;
  final bool isMobile;

  const _PriceAndActionSection({
    required this.food,
    required this.onAddToCart,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 10 : 12),
      decoration: BoxDecoration(
        color: AppColors.primaryBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greyText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'GHS ${food.price.toStringAsFixed(2)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: _AddButton(
                    onTap: onAddToCart,
                    isMobile: isMobile,
                    fullWidth: true,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Price',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.greyText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'GHS ${food.price.toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _AddButton(
                  onTap: onAddToCart,
                  isMobile: isMobile,
                ),
              ],
            ),
    );
  }
}

class _FoodImageSection extends StatefulWidget {
  final ProductItem food;
  final double height;
  final bool isMobile;

  const _FoodImageSection({
    required this.food,
    required this.height,
    required this.isMobile,
  });

  @override
  State<_FoodImageSection> createState() => _FoodImageSectionState();
}

class _FoodImageSectionState extends State<_FoodImageSection> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  List<String> get _images =>
      widget.food.imageUrls.where((url) => url.trim().isNotEmpty).toList();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  @override
  void didUpdateWidget(covariant _FoodImageSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.food.id != widget.food.id ||
        oldWidget.food.imageUrls.length != widget.food.imageUrls.length) {
      _currentIndex = 0;
      _stopAutoSlide();
      _startAutoSlide();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController.hasClients) {
          _pageController.jumpToPage(0);
        }
      });
    }
  }

  void _startAutoSlide() {
    if (_images.length <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_pageController.hasClients || _images.isEmpty) return;

      final nextPage = (_currentIndex + 1) % _images.length;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoSlide() {
    _timer?.cancel();
    _timer = null;
  }

  void _openGallery() {
    if (_images.isEmpty) return;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.88),
      builder: (_) => _ProductGalleryDialog(
        productName: widget.food.name,
        category: widget.food.category,
        imageUrls: _images,
        initialIndex: _currentIndex,
      ),
    );
  }

  @override
  void dispose() {
    _stopAutoSlide();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = _images.isNotEmpty;

    return GestureDetector(
      onTap: _openGallery,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: widget.height,
          width: double.infinity,
          color: AppColors.charcoal,
          child: hasImages
              ? Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: _images.length,
                      onPageChanged: (index) {
                        if (mounted) {
                          setState(() {
                            _currentIndex = index;
                          });
                        }
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          _images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          filterQuality: FilterQuality.medium,
                          errorBuilder: (context, error, stackTrace) {
                            return _ImageFallback(
                              isMobile: widget.isMobile,
                              category: widget.food.category,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return _ImageFallback(
                              isMobile: widget.isMobile,
                              category: widget.food.category,
                              showLoader: true,
                            );
                          },
                        );
                      },
                    ),

                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.10),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.photo_library_outlined,
                              size: 14,
                              color: AppColors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${_currentIndex + 1}/${_images.length}',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_images.length, (index) {
                          final isActive = index == _currentIndex;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 7,
                            width: isActive ? 20 : 7,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.gold
                                  : AppColors.white.withValues(alpha: 0.45),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          );
                        }),
                      ),
                    ),

                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.05),
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : _ImageFallback(
                  isMobile: widget.isMobile,
                  category: widget.food.category,
                ),
        ),
      ),
    );
  }
}

class _ProductGalleryDialog extends StatefulWidget {
  final String productName;
  final String category;
  final List<String> imageUrls;
  final int initialIndex;

  const _ProductGalleryDialog({
    required this.productName,
    required this.category,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<_ProductGalleryDialog> createState() => _ProductGalleryDialogState();
}

class _ProductGalleryDialogState extends State<_ProductGalleryDialog> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.imageUrls.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _pageController.animateToPage(
        _currentIndex - 1,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (_currentIndex < widget.imageUrls.length - 1) {
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 40,
        vertical: isMobile ? 24 : 32,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 980,
          maxHeight: isMobile ? 620 : 760,
        ),
        decoration: BoxDecoration(
          color: AppColors.softBlack,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.charcoal),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 30,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 14 : 20,
                isMobile ? 14 : 18,
                isMobile ? 10 : 14,
                10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.category} • ${_currentIndex + 1} of ${widget.imageUrls.length}',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFFBDBDBD),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 12 : 18,
                  8,
                  isMobile ? 12 : 18,
                  12,
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: AppColors.primaryBlack,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: widget.imageUrls.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return InteractiveViewer(
                              minScale: 1,
                              maxScale: 4,
                              child: Image.network(
                                widget.imageUrls[index],
                                fit: BoxFit.contain,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return _ImageFallback(
                                    isMobile: isMobile,
                                    category: widget.category,
                                    showLoader: true,
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return _ImageFallback(
                                    isMobile: isMobile,
                                    category: widget.category,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    if (!isMobile && widget.imageUrls.length > 1)
                      Positioned(
                        left: 12,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: _GalleryArrowButton(
                            icon: Icons.chevron_left_rounded,
                            onTap: _currentIndex > 0 ? _goToPrevious : null,
                          ),
                        ),
                      ),

                    if (!isMobile && widget.imageUrls.length > 1)
                      Positioned(
                        right: 12,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: _GalleryArrowButton(
                            icon: Icons.chevron_right_rounded,
                            onTap: _currentIndex < widget.imageUrls.length - 1
                                ? _goToNext
                                : null,
                          ),
                        ),
                      ),

                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 14,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(widget.imageUrls.length, (index) {
                          final isActive = index == _currentIndex;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: isActive ? 22 : 8,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.gold
                                  : AppColors.white.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GalleryArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _GalleryArrowButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: disabled
              ? Colors.black.withValues(alpha: 0.22)
              : Colors.black.withValues(alpha: 0.52),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.10),
          ),
        ),
        child: Icon(
          icon,
          size: 28,
          color: disabled
              ? AppColors.white.withValues(alpha: 0.35)
              : AppColors.white,
        ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  final bool isMobile;
  final String category;
  final bool showLoader;

  const _ImageFallback({
    required this.isMobile,
    required this.category,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      child: Center(
        child: showLoader
            ? SizedBox(
                width: isMobile ? 22 : 26,
                height: isMobile ? 22 : 26,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.gold,
                ),
              )
            : Container(
                padding: EdgeInsets.all(isMobile ? 12 : 14),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _categoryIcon(category),
                  size: isMobile ? 32 : 38,
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }

  static IconData _categoryIcon(String category) {
    switch (category) {
      case 'Tees':
        return Icons.checkroom_rounded;
      case 'Sneakers':
        return Icons.run_circle_outlined;
      case 'Caps':
        return Icons.workspace_premium_outlined;
      case 'Chains':
        return Icons.link_rounded;
      case 'Belts':
        return Icons.style_outlined;
      case 'Socks':
        return Icons.sports_outlined;
      default:
        return Icons.shopping_bag_outlined;
    }
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
      constraints: const BoxConstraints(maxWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.gold,
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
      constraints: const BoxConstraints(maxWidth: 130),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: AppColors.white,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
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
  final bool fullWidth;

  const _AddButton({
    required this.onTap,
    required this.isMobile,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 14,
          vertical: isMobile ? 10 : 11,
        ),
        decoration: BoxDecoration(
          color: disabled ? AppColors.charcoal : AppColors.gold,
          borderRadius: BorderRadius.circular(14),
          boxShadow: disabled
              ? []
              : [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.20),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment:
              fullWidth ? MainAxisAlignment.center : MainAxisAlignment.start,
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Icon(
              Icons.add_shopping_cart_rounded,
              size: isMobile ? 15 : 16,
              color: disabled ? AppColors.greyText : AppColors.primaryBlack,
            ),
            const SizedBox(width: 5),
            Text(
              disabled ? 'N/A' : 'Add',
              style: TextStyle(
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w700,
                color: disabled ? AppColors.greyText : AppColors.primaryBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}