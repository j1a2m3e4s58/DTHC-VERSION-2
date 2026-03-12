import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../data/order_controller.dart';
import 'admin_collections_page.dart';
import 'admin_food_page.dart';
import 'admin_hero_page.dart';
import 'admin_lookbook_page.dart';
import 'admin_orders_page.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 700;
    final bool isTablet = width >= 700 && width < 1100;
    final int newOrdersCount = context.watch<OrderController>().newOrdersCount;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryBlack,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'DTHC Admin',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Store control center',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.softBlack,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.charcoal),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminOrdersPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.white,
                    ),
                    tooltip: 'New Orders',
                  ),
                ),
                if (newOrdersCount > 0)
                  Positioned(
                    right: -2,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.primaryBlack),
                      ),
                      child: Text(
                        '$newOrdersCount',
                        style: const TextStyle(
                          color: AppColors.primaryBlack,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isMobile ? 16 : 24,
          8,
          isMobile ? 16 : 24,
          28,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DashboardHero(
                  isMobile: isMobile,
                  newOrdersCount: newOrdersCount,
                ),
                const SizedBox(height: 24),
                if (isMobile)
                  Column(
                    children: const [
                      _DashboardActionCard(
                        title: 'Product Management',
                        subtitle:
                            'Edit DTHC products, names, categories, prices, stock, image URLs, featured items, and product availability.',
                        icon: Icons.checkroom_rounded,
                        accentIcon: Icons.inventory_2_outlined,
                        buttonLabel: 'Open Products',
                        page: AdminFoodPage(),
                      ),
                      SizedBox(height: 16),
                      _DashboardActionCard(
                        title: 'Hero Banner Management',
                        subtitle:
                            'Manage homepage banner slides, CTA text, banner images, sort order, and linked target products.',
                        icon: Icons.view_carousel_rounded,
                        accentIcon: Icons.image_outlined,
                        buttonLabel: 'Open Hero Manager',
                        page: AdminHeroPage(),
                        highlightValue: 'Homepage',
                      ),
                      SizedBox(height: 16),
                      _DashboardActionCard(
                        title: 'Collections Management',
                        subtitle:
                            'Create, edit, feature, and remove collection sections that organize DTHC drops and public storefront discovery.',
                        icon: Icons.grid_view_rounded,
                        accentIcon: Icons.auto_awesome_motion_outlined,
                        buttonLabel: 'Open Collections',
                        page: AdminCollectionsPage(),
                        highlightValue: 'Storefront',
                      ),
                      SizedBox(height: 16),
                      _DashboardActionCard(
                        title: 'Lookbook Management',
                        subtitle:
                            'Manage lookbook mood boards, editorial images, fashion inspiration, and shop-the-look links.',
                        icon: Icons.photo_library_rounded,
                        accentIcon: Icons.style_outlined,
                        buttonLabel: 'Open Lookbook',
                        page: AdminLookbookPage(),
                        highlightValue: 'Editorial',
                      ),
                    ],
                  )
                else
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isTablet ? 2 : 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: isTablet ? 1.18 : 1.42,
                    children: const [
                      _DashboardActionCard(
                        title: 'Product Management',
                        subtitle:
                            'Edit DTHC products, names, categories, prices, stock, image URLs, featured items, and product availability.',
                        icon: Icons.checkroom_rounded,
                        accentIcon: Icons.inventory_2_outlined,
                        buttonLabel: 'Open Products',
                        page: AdminFoodPage(),
                      ),
                      _DashboardActionCard(
                        title: 'Hero Banner Management',
                        subtitle:
                            'Manage homepage banner slides, CTA text, banner images, sort order, and linked target products.',
                        icon: Icons.view_carousel_rounded,
                        accentIcon: Icons.image_outlined,
                        buttonLabel: 'Open Hero Manager',
                        page: AdminHeroPage(),
                        highlightValue: 'Homepage',
                      ),
                      _DashboardActionCard(
                        title: 'Collections Management',
                        subtitle:
                            'Create, edit, feature, and remove collection sections that organize DTHC drops and public storefront discovery.',
                        icon: Icons.grid_view_rounded,
                        accentIcon: Icons.auto_awesome_motion_outlined,
                        buttonLabel: 'Open Collections',
                        page: AdminCollectionsPage(),
                        highlightValue: 'Storefront',
                      ),
                      _DashboardActionCard(
                        title: 'Lookbook Management',
                        subtitle:
                            'Manage lookbook mood boards, editorial images, fashion inspiration, and shop-the-look links.',
                        icon: Icons.photo_library_rounded,
                        accentIcon: Icons.style_outlined,
                        buttonLabel: 'Open Lookbook',
                        page: AdminLookbookPage(),
                        highlightValue: 'Editorial',
                      ),
                      _DashboardActionCard(
                        title: 'Customer Orders',
                        subtitle:
                            'Review incoming orders, customer details, item summaries, delivery flow, and newly placed requests.',
                        icon: Icons.receipt_long_rounded,
                        accentIcon: Icons.local_shipping_outlined,
                        buttonLabel: 'Open Orders',
                        page: AdminOrdersPage(),
                        highlightValue: 'Live',
                      ),
                    ],
                  ),
                if (isMobile) ...[
                  const SizedBox(height: 16),
                  _DashboardActionCard(
                    title: 'Customer Orders',
                    subtitle:
                        'Review incoming orders, customer details, item summaries, delivery flow, and newly placed requests.',
                    icon: Icons.receipt_long_rounded,
                    accentIcon: Icons.local_shipping_outlined,
                    buttonLabel: 'Open Orders',
                    page: const AdminOrdersPage(),
                    highlightValue:
                        newOrdersCount > 0 ? '$newOrdersCount New' : 'Live',
                  ),
                ],
                if (!isMobile) ...[
                  const SizedBox(height: 0),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardHero extends StatelessWidget {
  final bool isMobile;
  final int newOrdersCount;

  const _DashboardHero({
    required this.isMobile,
    required this.newOrdersCount,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      _HeroStatData(
        label: 'Brand',
        value: 'DTHC',
        icon: Icons.workspace_premium_rounded,
      ),
      _HeroStatData(
        label: 'Orders',
        value: newOrdersCount > 0 ? '$newOrdersCount new' : 'Up to date',
        icon: Icons.receipt_long_rounded,
      ),
      const _HeroStatData(
        label: 'Mode',
        value: 'Admin',
        icon: Icons.admin_panel_settings_outlined,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF0E0E0E),
          ],
        ),
        border: Border.all(color: AppColors.charcoal),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeroTopText(),
                const SizedBox(height: 18),
                _HeroBadgeRow(newOrdersCount: newOrdersCount),
                const SizedBox(height: 18),
                ...stats.map(
                  (stat) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _HeroStatCard(data: stat),
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 3,
                  child: _HeroTopText(),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _HeroBadgeRow(newOrdersCount: newOrdersCount),
                      const SizedBox(height: 14),
                      ...stats.map(
                        (stat) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _HeroStatCard(data: stat),
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

class _HeroTopText extends StatelessWidget {
  const _HeroTopText();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage the DTHC store with a cleaner, premium control dashboard.',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 30,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Update products, track orders, manage collections, and control editorial storefront content with a fashion-brand admin experience that matches the customer-facing site.',
          style: TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 15,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _HeroBadgeRow extends StatelessWidget {
  final int newOrdersCount;

  const _HeroBadgeRow({
    required this.newOrdersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'DTHC Admin Panel',
            style: TextStyle(
              color: AppColors.primaryBlack,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.softBlack,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.charcoal),
          ),
          child: Text(
            newOrdersCount > 0
                ? '$newOrdersCount pending alerts'
                : 'No new alerts',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroStatData {
  final String label;
  final String value;
  final IconData icon;

  const _HeroStatData({
    required this.label,
    required this.value,
    required this.icon,
  });
}

class _HeroStatCard extends StatelessWidget {
  final _HeroStatData data;

  const _HeroStatCard({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              data.icon,
              color: AppColors.gold,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
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

class _DashboardActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final IconData accentIcon;
  final String buttonLabel;
  final Widget page;
  final String? highlightValue;

  const _DashboardActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentIcon,
    required this.buttonLabel,
    required this.page,
    this.highlightValue,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 22),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.charcoal),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.25),
                  ),
                ),
                child: Icon(
                  icon,
                  color: AppColors.gold,
                  size: 30,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlack,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.charcoal),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      accentIcon,
                      size: 15,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      highlightValue ?? 'Manage',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              height: 1.65,
              color: Color(0xFFBDBDBD),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => page),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.primaryBlack,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}