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
  final VoidCallback? onTrackOrderTap;
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
    this.onTrackOrderTap,
    this.onOrderNowTap,
    this.onAdminTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cartCount = context.watch<CartController>().totalItemsCount;

    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1100;

    final cartTitle = cartCount > 0 ? 'Cart ($cartCount)' : 'Cart';

    return Container(
      width: double.infinity,
      color: AppColors.softCream,
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
              color: AppColors.white.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFFD9E2DA),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: isMobile ? 1 : 3,
                  child: _LogoSection(
                    isMobile: isMobile,
                    onTap: onHomeTap,
                    onLongPress: onAdminTap,
                  ),
                ),
                if (!isMobile) ...[
                  Expanded(
                    flex: isTablet ? 5 : 6,
                    child: _DesktopNavLinks(
                      activeItem: activeItem,
                      cartTitle: cartTitle,
                      onHomeTap: onHomeTap,
                      onMenuTap: onMenuTap,
                      onSpecialPacksTap: onSpecialPacksTap,
                      onCartTap: onCartTap,
                      onContactTap: onContactTap,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _NavbarActions(
                        isTablet: isTablet,
                        onTrackOrderTap: onTrackOrderTap,
                        onOrderNowTap: onOrderNowTap,
                      ),
                    ),
                  ),
                ] else ...[
                  _MobileMenuButton(
                    cartTitle: cartTitle,
                    activeItem: activeItem,
                    onHomeTap: onHomeTap,
                    onMenuTap: onMenuTap,
                    onSpecialPacksTap: onSpecialPacksTap,
                    onCartTap: onCartTap,
                    onContactTap: onContactTap,
                    onTrackOrderTap: onTrackOrderTap,
                    onOrderNowTap: onOrderNowTap,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
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
        children: [
          Container(
            height: isMobile ? 48 : 52,
            width: isMobile ? 48 : 52,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.restaurant,
              color: AppColors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          if (!isMobile)
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SUPERFOODS',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkGreen,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Kitchen & Bakery',
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
  final VoidCallback? onHomeTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSpecialPacksTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onContactTap;

  const _DesktopNavLinks({
    required this.activeItem,
    required this.cartTitle,
    this.onHomeTap,
    this.onMenuTap,
    this.onSpecialPacksTap,
    this.onCartTap,
    this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NavButton(
          title: 'Home',
          icon: Icons.home_rounded,
          active: activeItem == 'Home',
          onTap: onHomeTap,
        ),
        const SizedBox(width: 8),
        _NavButton(
          title: 'Menu',
          icon: Icons.restaurant_menu,
          active: activeItem == 'Menu',
          onTap: onMenuTap,
        ),
        const SizedBox(width: 8),
        _NavButton(
          title: 'Special Packs',
          icon: Icons.local_offer_outlined,
          active: activeItem == 'Special Packs',
          onTap: onSpecialPacksTap,
        ),
        const SizedBox(width: 8),
        _NavButton(
          title: cartTitle,
          icon: Icons.shopping_cart_outlined,
          active: activeItem == 'Cart',
          onTap: onCartTap,
        ),
        const SizedBox(width: 8),
        _NavButton(
          title: 'Contact',
          icon: Icons.call_outlined,
          active: activeItem == 'Contact',
          onTap: onContactTap,
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool active;
  final VoidCallback? onTap;

  const _NavButton({
    required this.title,
    required this.icon,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE9F5EC) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: active ? Border.all(color: const Color(0xFFD8E8DC)) : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: active ? AppColors.primaryGreen : const Color(0xFF2F3747),
              ),
              const SizedBox(width: 7),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: active
                      ? AppColors.primaryGreen
                      : const Color(0xFF2F3747),
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
  final VoidCallback? onTrackOrderTap;
  final VoidCallback? onOrderNowTap;

  const _NavbarActions({
    required this.isTablet,
    this.onTrackOrderTap,
    this.onOrderNowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        OutlinedButton(
          onPressed: onTrackOrderTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.darkGreen,
            side: const BorderSide(color: Color(0xFFD5DFD7)),
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 18,
              vertical: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Text(
            'Track Order',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        ElevatedButton(
          onPressed: onOrderNowTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.white,
            elevation: 0,
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 18,
              vertical: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Text(
            'Order Now',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
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
  final VoidCallback? onTrackOrderTap;
  final VoidCallback? onOrderNowTap;

  const _MobileMenuButton({
    required this.activeItem,
    required this.cartTitle,
    this.onHomeTap,
    this.onMenuTap,
    this.onSpecialPacksTap,
    this.onCartTap,
    this.onContactTap,
    this.onTrackOrderTap,
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
        color: AppColors.darkGreen,
        size: 28,
      ),
      onSelected: (value) {
        if (value == 'Home') {
          onHomeTap?.call();
        } else if (value == 'Menu') {
          onMenuTap?.call();
        } else if (value == 'Special Packs') {
          onSpecialPacksTap?.call();
        } else if (value == 'Cart') {
          onCartTap?.call();
        } else if (value == 'Contact') {
          onContactTap?.call();
        } else if (value == 'Track Order') {
          onTrackOrderTap?.call();
        } else if (value == 'Order Now') {
          onOrderNowTap?.call();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: Container(
            width: 285,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFE3E6E8)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x18000000),
                  blurRadius: 24,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _MobileMenuHeader(),
                const Divider(height: 1, color: Color(0xFFE7EAEC)),
                _MobileMenuAction(
                  title: 'Home',
                  icon: Icons.home_rounded,
                  active: activeItem == 'Home',
                  onTap: () => Navigator.pop(context, 'Home'),
                ),
                _MobileMenuAction(
                  title: 'Menu',
                  icon: Icons.restaurant_menu,
                  active: activeItem == 'Menu',
                  onTap: () => Navigator.pop(context, 'Menu'),
                ),
                _MobileMenuAction(
                  title: 'Special Packs',
                  icon: Icons.local_offer_outlined,
                  active: activeItem == 'Special Packs',
                  onTap: () => Navigator.pop(context, 'Special Packs'),
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
                  title: 'Track Order',
                  icon: Icons.route_outlined,
                  onTap: () => Navigator.pop(context, 'Track Order'),
                ),
                _MobileMenuAction(
                  title: 'Order Now',
                  icon: Icons.shopping_bag_outlined,
                  onTap: () => Navigator.pop(context, 'Order Now'),
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
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.restaurant,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SUPERFOODS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkGreen,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Kitchen & Bakery',
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
              color: active ? AppColors.primaryGreen : const Color(0xFF243041),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: active
                      ? AppColors.primaryGreen
                      : const Color(0xFF243041),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}