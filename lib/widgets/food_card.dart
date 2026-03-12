import 'dart:async';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/food_item.dart';

class FoodCard extends StatefulWidget {
  final ProductItem food;
  final VoidCallback? onAddToCart;
  final VoidCallback? onGoToCart;

  const FoodCard({
    super.key,
    required this.food,
    this.onAddToCart,
    this.onGoToCart,
  });

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool _isHovered = false;
  int _currentImageIndex = 0;

  ProductImageEntry get _currentEntry =>
      widget.food.imageEntryAt(_currentImageIndex);

  void _handleAddAndGoToCart() {
    widget.onAddToCart?.call();
    widget.onGoToCart?.call();
  }

  @override
  void didUpdateWidget(covariant FoodCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.food.id != widget.food.id) {
      _currentImageIndex = 0;
    }
  }

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
                initialIndex: _currentImageIndex,
                onIndexChanged: (index) {
                  if (!mounted) return;
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                onAddToCart: widget.food.isAvailable ? widget.onAddToCart : null,
                onGoToCart: widget.onGoToCart,
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
                _currentEntry.title,
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
                _currentEntry.description,
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
                entry: _currentEntry,
                onAddToCart:
                    widget.food.isAvailable ? _handleAddAndGoToCart : null,
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
  final ProductImageEntry entry;
  final VoidCallback? onAddToCart;
  final bool isMobile;

  const _PriceAndActionSection({
    required this.entry,
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
                  'GHS ${entry.price.toStringAsFixed(2)}',
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
                        'GHS ${entry.price.toStringAsFixed(2)}',
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
  final int initialIndex;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback? onAddToCart;
  final VoidCallback? onGoToCart;

  const _FoodImageSection({
    required this.food,
    required this.height,
    required this.isMobile,
    required this.initialIndex,
    required this.onIndexChanged,
    this.onAddToCart,
    this.onGoToCart,
  });

  @override
  State<_FoodImageSection> createState() => _FoodImageSectionState();
}

class _FoodImageSectionState extends State<_FoodImageSection> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  List<ProductImageEntry> get _entries => widget.food.imageEntries
      .where((entry) => entry.imageUrl.trim().isNotEmpty)
      .toList();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _startAutoSlide();
  }

  @override
  void didUpdateWidget(covariant _FoodImageSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.food.id != widget.food.id ||
        oldWidget.food.imageEntries.length != widget.food.imageEntries.length) {
      _currentIndex = 0;
      widget.onIndexChanged(0);
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
    if (_entries.length <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_pageController.hasClients || _entries.isEmpty) return;

      final nextPage = (_currentIndex + 1) % _entries.length;

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
    if (_entries.isEmpty) return;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.88),
      builder: (_) => _ProductGalleryDialog(
        food: widget.food,
        entries: _entries,
        initialIndex: _currentIndex,
        onAddToCart: widget.onAddToCart,
        onGoToCart: widget.onGoToCart,
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
    final hasImages = _entries.isNotEmpty;

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
                      itemCount: _entries.length,
                      onPageChanged: (index) {
                        if (mounted) {
                          setState(() {
                            _currentIndex = index;
                          });
                          widget.onIndexChanged(index);
                        }
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          _entries[index].imageUrl,
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
                              '${_currentIndex + 1}/${_entries.length}',
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
                        children: List.generate(_entries.length, (index) {
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
  final ProductItem food;
  final List<ProductImageEntry> entries;
  final int initialIndex;
  final VoidCallback? onAddToCart;
  final VoidCallback? onGoToCart;

  const _ProductGalleryDialog({
    required this.food,
    required this.entries,
    required this.initialIndex,
    this.onAddToCart,
    this.onGoToCart,
  });

  @override
  State<_ProductGalleryDialog> createState() => _ProductGalleryDialogState();
}

class _ProductGalleryDialogState extends State<_ProductGalleryDialog> {
  late final PageController _pageController;
  late int _currentIndex;

  ProductImageEntry get _currentEntry => widget.entries[_currentIndex];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.entries.length - 1);
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
    if (_currentIndex < widget.entries.length - 1) {
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleAddToCartOnly() {
    widget.onAddToCart?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.softBlack,
        content: Text(
          '${_currentEntry.title} added to cart',
          style: const TextStyle(color: AppColors.white),
        ),
      ),
    );
  }

  void _handleAddAndGoToCart() {
    widget.onAddToCart?.call();
    Navigator.pop(context);
    widget.onGoToCart?.call();
  }

  void _handleGoToCart() {
    Navigator.pop(context);
    widget.onGoToCart?.call();
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
          maxWidth: isMobile ? double.infinity : 1080,
          maxHeight: isMobile ? 760 : 820,
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
        child: isMobile
            ? Column(
                children: [
                  _GalleryHeader(
                    title: _currentEntry.title,
                    subtitle:
                        '${widget.food.category} • ${_currentIndex + 1} of ${widget.entries.length}',
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _GalleryImageArea(
                            pageController: _pageController,
                            entries: widget.entries,
                            currentIndex: _currentIndex,
                            category: widget.food.category,
                            isMobile: isMobile,
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                          ),
                          const SizedBox(height: 14),
                          _ProductPreviewDetails(
                            food: widget.food,
                            entry: _currentEntry,
                            galleryCount: widget.entries.length,
                          ),
                          const SizedBox(height: 14),
                          _PreviewActionButtons(
                            isMobile: true,
                            isAvailable: widget.food.isAvailable,
                            onAddToCart: widget.food.isAvailable
                                ? _handleAddToCartOnly
                                : null,
                            onAddAndGoToCart: widget.food.isAvailable
                                ? _handleAddAndGoToCart
                                : null,
                            onGoToCart: widget.onGoToCart != null
                                ? _handleGoToCart
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  _GalleryHeader(
                    title: _currentEntry.title,
                    subtitle:
                        '${widget.food.category} • ${_currentIndex + 1} of ${widget.entries.length}',
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: _GalleryImageArea(
                              pageController: _pageController,
                              entries: widget.entries,
                              currentIndex: _currentIndex,
                              category: widget.food.category,
                              isMobile: isMobile,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                              leftArrow: widget.entries.length > 1
                                  ? _GalleryArrowButton(
                                      icon: Icons.chevron_left_rounded,
                                      onTap:
                                          _currentIndex > 0 ? _goToPrevious : null,
                                    )
                                  : null,
                              rightArrow: widget.entries.length > 1
                                  ? _GalleryArrowButton(
                                      icon: Icons.chevron_right_rounded,
                                      onTap: _currentIndex <
                                              widget.entries.length - 1
                                          ? _goToNext
                                          : null,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlack,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: AppColors.charcoal),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: _ProductPreviewDetails(
                                        food: widget.food,
                                        entry: _currentEntry,
                                        galleryCount: widget.entries.length,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _PreviewActionButtons(
                                    isMobile: false,
                                    isAvailable: widget.food.isAvailable,
                                    onAddToCart: widget.food.isAvailable
                                        ? _handleAddToCartOnly
                                        : null,
                                    onAddAndGoToCart: widget.food.isAvailable
                                        ? _handleAddAndGoToCart
                                        : null,
                                    onGoToCart: widget.onGoToCart != null
                                        ? _handleGoToCart
                                        : null,
                                  ),
                                ],
                              ),
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

class _GalleryHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _GalleryHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Padding(
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
                  title,
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
                  subtitle,
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
    );
  }
}

class _GalleryImageArea extends StatelessWidget {
  final PageController pageController;
  final List<ProductImageEntry> entries;
  final int currentIndex;
  final String category;
  final bool isMobile;
  final ValueChanged<int> onPageChanged;
  final Widget? leftArrow;
  final Widget? rightArrow;

  const _GalleryImageArea({
    required this.pageController,
    required this.entries,
    required this.currentIndex,
    required this.category,
    required this.isMobile,
    required this.onPageChanged,
    this.leftArrow,
    this.rightArrow,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            height: isMobile ? 320 : double.infinity,
            color: AppColors.primaryBlack,
            child: PageView.builder(
              controller: pageController,
              itemCount: entries.length,
              onPageChanged: onPageChanged,
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Image.network(
                    entries[index].imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _ImageFallback(
                        isMobile: isMobile,
                        category: category,
                        showLoader: true,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _ImageFallback(
                        isMobile: isMobile,
                        category: category,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        if (leftArrow != null)
          Positioned(
            left: 12,
            top: 0,
            bottom: 0,
            child: Center(child: leftArrow!),
          ),
        if (rightArrow != null)
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Center(child: rightArrow!),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 14,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(entries.length, (index) {
              final isActive = index == currentIndex;

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
    );
  }
}

class _ProductPreviewDetails extends StatelessWidget {
  final ProductItem food;
  final ProductImageEntry entry;
  final int galleryCount;

  const _ProductPreviewDetails({
    required this.food,
    required this.entry,
    required this.galleryCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _CategoryBadge(label: food.category),
            if (food.isFeatured)
              const _MiniBadge(
                label: 'Featured',
                icon: Icons.star_rounded,
              ),
            if (food.isNewArrival)
              const _MiniBadge(
                label: 'New',
                icon: Icons.local_fire_department_outlined,
              ),
            if (food.isBestSeller)
              const _MiniBadge(
                label: 'Best Seller',
                icon: Icons.workspace_premium_outlined,
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          entry.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'GHS ${entry.price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: 14),
        _DetailTile(
          label: 'Description',
          value: entry.description,
        ),
        const SizedBox(height: 12),
        _DetailTile(
          label: 'Category',
          value: food.category,
        ),
        const SizedBox(height: 12),
        _DetailTile(
          label: 'Collection',
          value: food.collection,
        ),
        const SizedBox(height: 12),
        _DetailTile(
          label: 'Availability',
          value: food.isAvailable ? 'In stock' : 'Currently unavailable',
          valueColor: food.isAvailable
              ? const Color(0xFF9BE59B)
              : const Color(0xFFFF8A80),
        ),
        if (galleryCount > 0) ...[
          const SizedBox(height: 12),
          _DetailTile(
            label: 'Gallery',
            value: '$galleryCount image(s)',
          ),
        ],
      ],
    );
  }
}

class _DetailTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailTile({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.greyText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewActionButtons extends StatelessWidget {
  final bool isMobile;
  final bool isAvailable;
  final VoidCallback? onAddToCart;
  final VoidCallback? onAddAndGoToCart;
  final VoidCallback? onGoToCart;

  const _PreviewActionButtons({
    required this.isMobile,
    required this.isAvailable,
    this.onAddToCart,
    this.onAddAndGoToCart,
    this.onGoToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: _PrimaryActionButton(
            label: isAvailable ? 'Add to Cart' : 'Unavailable',
            icon: Icons.add_shopping_cart_rounded,
            onTap: isAvailable ? onAddToCart : null,
            isGold: true,
            isMobile: isMobile,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: _PrimaryActionButton(
            label: isAvailable ? 'Add & Go to Cart' : 'Go to Cart',
            icon: Icons.shopping_bag_outlined,
            onTap: isAvailable ? onAddAndGoToCart : onGoToCart,
            isGold: false,
            isMobile: isMobile,
          ),
        ),
        if (onGoToCart != null && isAvailable) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: _PrimaryActionButton(
              label: 'View Cart',
              icon: Icons.arrow_forward_rounded,
              onTap: onGoToCart,
              isGold: false,
              isMobile: isMobile,
            ),
          ),
        ],
      ],
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isGold;
  final bool isMobile;

  const _PrimaryActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isGold,
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
          horizontal: isMobile ? 14 : 16,
          vertical: isMobile ? 13 : 14,
        ),
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.charcoal
              : (isGold
                  ? AppColors.gold
                  : AppColors.white.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: disabled
                ? AppColors.charcoal
                : (isGold
                    ? AppColors.gold
                    : AppColors.white.withValues(alpha: 0.12)),
          ),
          boxShadow: disabled || !isGold
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isMobile ? 17 : 18,
              color: disabled
                  ? AppColors.greyText
                  : (isGold ? AppColors.primaryBlack : AppColors.white),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: isMobile ? 13 : 14,
                fontWeight: FontWeight.w700,
                color: disabled
                    ? AppColors.greyText
                    : (isGold ? AppColors.primaryBlack : AppColors.white),
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