import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../data/cart_controller.dart';

class CustomNavbar extends StatelessWidget {
  final String activeItem;
  final VoidCallback? onHomeTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSpecialPacksTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onContactTap;
  final VoidCallback? onLookbookTap;
  final VoidCallback? onDeliveryTap;
  final VoidCallback? onOrderNowTap;
  final VoidCallback? onAdminTap;

  const CustomNavbar({
    super.key,
    this.activeItem = 'Home',
    this.onHomeTap,
    this.onMenuTap,
    this.onSpecialPacksTap,
    this.onCartTap,
    this.onContactTap,
    this.onLookbookTap,
    this.onDeliveryTap,
    this.onOrderNowTap,
    this.onAdminTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cartCount = context.watch<CartController>().totalItemsCount;

    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1180;
    final cartTitle = cartCount > 0 ? 'Cart ($cartCount)' : 'Cart';

    return Container(
      width: double.infinity,
      color: AppColors.primaryBlack,
      padding: EdgeInsets.fromLTRB(
        isMobile ? 12 : 22,
        18,
        isMobile ? 12 : 22,
        10,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 14 : 18,
              vertical: isMobile ? 12 : 14,
            ),
            decoration: BoxDecoration(
              color: AppColors.softBlack,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.charcoal),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x30000000),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: isMobile
                ? Row(
                    children: [
                      Expanded(
                        child: _LogoSection(
                          isMobile: true,
                          onTap: onHomeTap,
                          onLongPress: onAdminTap,
                        ),
                      ),
                      _MobileMenuButton(
                        cartTitle: cartTitle,
                        activeItem: activeItem,
                        onHomeTap: onHomeTap,
                        onMenuTap: onMenuTap,
                        onSpecialPacksTap: onSpecialPacksTap,
                        onCartTap: onCartTap,
                        onContactTap: onContactTap,
                        onLookbookTap: onLookbookTap,
                        onDeliveryTap: onDeliveryTap,
                        onOrderNowTap: onOrderNowTap,
                      ),
                    ],
                  )
                : _DesktopNavbarLayout(
                    isTablet: isTablet,
                    activeItem: activeItem,
                    cartTitle: cartTitle,
                    onHomeTap: onHomeTap,
                    onMenuTap: onMenuTap,
                    onSpecialPacksTap: onSpecialPacksTap,
                    onCartTap: onCartTap,
                    onContactTap: onContactTap,
                    onLookbookTap: onLookbookTap,
                    onDeliveryTap: onDeliveryTap,
                    onOrderNowTap: onOrderNowTap,
                    onAdminTap: onAdminTap,
                  ),
          ),
        ),
      ),
    );
  }
}

class _DesktopNavbarLayout extends StatelessWidget {
  final bool isTablet;
  final String activeItem;
  final String cartTitle;
  final VoidCallback? onHomeTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSpecialPacksTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onContactTap;
  final VoidCallback? onLookbookTap;
  final VoidCallback? onDeliveryTap;
  final VoidCallback? onOrderNowTap;
  final VoidCallback? onAdminTap;

  const _DesktopNavbarLayout({
    required this.isTablet,
    required this.activeItem,
    required this.cartTitle,
    this.onHomeTap,
    this.onMenuTap,
    this.onSpecialPacksTap,
    this.onCartTap,
    this.onContactTap,
    this.onLookbookTap,
    this.onDeliveryTap,
    this.onOrderNowTap,
    this.onAdminTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LogoSection(
          isMobile: false,
          onTap: onHomeTap,
          onLongPress: onAdminTap,
        ),
        SizedBox(width: isTablet ? 14 : 22),
        Expanded(
          child: _DesktopNavLinks(
            activeItem: activeItem,
            cartTitle: cartTitle,
            compact: isTablet,
            onHomeTap: onHomeTap,
            onMenuTap: onMenuTap,
            onSpecialPacksTap: onSpecialPacksTap,
            onCartTap: onCartTap,
            onContactTap: onContactTap,
            onLookbookTap: onLookbookTap,
            onDeliveryTap: onDeliveryTap,
          ),
        ),
        SizedBox(width: isTablet ? 12 : 18),
        _NavbarActions(
          isTablet: isTablet,
          onOrderNowTap: onOrderNowTap,
        ),
      ],
    );
  }
}

class _LogoSection extends StatelessWidget {
  final bool isMobile;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _LogoSection({
    required this.isMobile,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(18),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: isMobile ? 48 : 52,
            width: isMobile ? 48 : 52,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: AppColors.primaryBlack,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          if (!isMobile)
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'DTHC',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Drip Too Hard Collections',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DesktopNavLinks extends StatelessWidget {
  final String activeItem;
  final String cartTitle;
  final bool compact;
  final VoidCallback? onHomeTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSpecialPacksTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onContactTap;
  final VoidCallback? onLookbookTap;
  final VoidCallback? onDeliveryTap;

  const _DesktopNavLinks({
    required this.activeItem,
    required this.cartTitle,
    required this.compact,
    this.onHomeTap,
    this.onMenuTap,
    this.onSpecialPacksTap,
    this.onCartTap,
    this.onContactTap,
    this.onLookbookTap,
    this.onDeliveryTap,
  });

  @override
  Widget build(BuildContext context) {
    final gap = compact ? 6.0 : 8.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final navItems = [
          _NavButton(
            title: 'Home',
            icon: Icons.home_rounded,
            active: activeItem == 'Home',
            compact: compact,
            onTap: onHomeTap,
          ),
          _NavButton(
            title: 'Shop',
            icon: Icons.storefront_outlined,
            active: activeItem == 'Shop' || activeItem == 'Menu',
            compact: compact,
            onTap: onMenuTap,
          ),
          _NavButton(
            title: 'Collections',
            icon: Icons.layers_outlined,
            active: activeItem == 'Collections' || activeItem == 'Special Packs',
            compact: compact,
            onTap: onSpecialPacksTap,
          ),
          _NavButton(
            title: 'Lookbook',
            icon: Icons.photo_library_outlined,
            active: activeItem == 'Lookbook',
            compact: compact,
            onTap: onLookbookTap,
          ),
          _NavButton(
            title: 'Delivery',
            icon: Icons.local_shipping_outlined,
            active:
                activeItem == 'Delivery' ||
                activeItem == 'Payment & Delivery',
            compact: compact,
            onTap: onDeliveryTap,
          ),
          _NavButton(
            title: cartTitle,
            icon: Icons.shopping_cart_outlined,
            active: activeItem == 'Cart',
            compact: compact,
            onTap: onCartTap,
          ),
          _NavButton(
            title: 'Contact',
            icon: Icons.call_outlined,
            active: activeItem == 'Contact',
            compact: compact,
            onTap: onContactTap,
          ),
        ];

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < navItems.length; i++) ...[
                  navItems[i],
                  if (i != navItems.length - 1) SizedBox(width: gap),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NavButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool active;
  final bool compact;
  final VoidCallback? onTap;

  const _NavButton({
    required this.title,
    required this.icon,
    this.active = false,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = compact ? 10.0 : 14.0;
    final verticalPadding = compact ? 10.0 : 11.0;
    final fontSize = compact ? 14.0 : 15.0;
    final iconSize = compact ? 15.0 : 16.0;
    final spacing = compact ? 6.0 : 7.0;

    return Container(
      decoration: BoxDecoration(
        color: active ? AppColors.gold : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: active ? Border.all(color: AppColors.gold) : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: active ? AppColors.primaryBlack : AppColors.white,
              ),
              SizedBox(width: spacing),
              Text(
                title,
                overflow: TextOverflow.visible,
                softWrap: false,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  color: active ? AppColors.primaryBlack : AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavbarActions extends StatelessWidget {
  final bool isTablet;
  final VoidCallback? onOrderNowTap;

  const _NavbarActions({
    required this.isTablet,
    this.onOrderNowTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onOrderNowTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.primaryBlack,
        elevation: 0,
        minimumSize: Size(isTablet ? 120 : 132, 56),
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16 : 18,
          vertical: 18,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: const Text(
        'Shop Now',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _MobileMenuButton extends StatelessWidget {
  final String activeItem;
  final String cartTitle;
  final VoidCallback? onHomeTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSpecialPacksTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onContactTap;
  final VoidCallback? onLookbookTap;
  final VoidCallback? onDeliveryTap;
  final VoidCallback? onOrderNowTap;

  const _MobileMenuButton({
    required this.activeItem,
    required this.cartTitle,
    this.onHomeTap,
    this.onMenuTap,
    this.onSpecialPacksTap,
    this.onCartTap,
    this.onContactTap,
    this.onLookbookTap,
    this.onDeliveryTap,
    this.onOrderNowTap,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 14),
      elevation: 0,
      color: Colors.transparent,
      padding: EdgeInsets.zero,
      icon: const Icon(
        Icons.menu_rounded,
        color: AppColors.white,
        size: 28,
      ),
      onSelected: (value) {
        if (value == 'Home') {
          onHomeTap?.call();
        } else if (value == 'Shop') {
          onMenuTap?.call();
        } else if (value == 'Collections') {
          onSpecialPacksTap?.call();
        } else if (value == 'Lookbook') {
          onLookbookTap?.call();
        } else if (value == 'Delivery') {
          onDeliveryTap?.call();
        } else if (value == 'Cart') {
          onCartTap?.call();
        } else if (value == 'Contact') {
          onContactTap?.call();
        } else if (value == 'Shop Now') {
          onOrderNowTap?.call();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: Container(
            width: 290,
            decoration: BoxDecoration(
              color: AppColors.softBlack,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.charcoal),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x30000000),
                  blurRadius: 24,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _MobileMenuHeader(),
                const Divider(height: 1, color: AppColors.charcoal),
                _MobileMenuAction(
                  title: 'Home',
                  icon: Icons.home_rounded,
                  active: activeItem == 'Home',
                  onTap: () => Navigator.pop(context, 'Home'),
                ),
                _MobileMenuAction(
                  title: 'Shop',
                  icon: Icons.storefront_outlined,
                  active: activeItem == 'Shop' || activeItem == 'Menu',
                  onTap: () => Navigator.pop(context, 'Shop'),
                ),
                _MobileMenuAction(
                  title: 'Collections',
                  icon: Icons.layers_outlined,
                  active:
                      activeItem == 'Collections' ||
                      activeItem == 'Special Packs',
                  onTap: () => Navigator.pop(context, 'Collections'),
                ),
                _MobileMenuAction(
                  title: 'Lookbook',
                  icon: Icons.photo_library_outlined,
                  active: activeItem == 'Lookbook',
                  onTap: () => Navigator.pop(context, 'Lookbook'),
                ),
                _MobileMenuAction(
                  title: 'Delivery',
                  icon: Icons.local_shipping_outlined,
                  active:
                      activeItem == 'Delivery' ||
                      activeItem == 'Payment & Delivery',
                  onTap: () => Navigator.pop(context, 'Delivery'),
                ),
                _MobileMenuAction(
                  title: cartTitle,
                  icon: Icons.shopping_cart_outlined,
                  active: activeItem == 'Cart',
                  onTap: () => Navigator.pop(context, 'Cart'),
                ),
                _MobileMenuAction(
                  title: 'Contact',
                  icon: Icons.call_outlined,
                  active: activeItem == 'Contact',
                  onTap: () => Navigator.pop(context, 'Contact'),
                ),
                _MobileMenuAction(
                  title: 'Shop Now',
                  icon: Icons.shopping_bag_outlined,
                  onTap: () => Navigator.pop(context, 'Shop Now'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileMenuHeader extends StatelessWidget {
  const _MobileMenuHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: AppColors.primaryBlack,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DTHC',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Drip Too Hard Collections',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greyText,
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

class _MobileMenuAction extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _MobileMenuAction({
    required this.title,
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: active ? AppColors.gold : AppColors.white,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: active ? AppColors.gold : AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}