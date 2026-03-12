import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin_delivery_zones_page.dart';
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
    final orderController = context.watch<OrderController>();

    final int newOrdersCount = orderController.newOrdersCount;
    final int totalOrders = orderController.totalOrders;
    final int pendingOrdersCount = orderController.pendingOrdersCount;
    final int deliveredOrdersCount = orderController.deliveredOrdersCount;
    final int paidOrdersCount = orderController.paidOrdersCount;
    final int unpaidOrdersCount = orderController.unpaidOrdersCount;
    final int ordersToday = orderController.ordersToday;
    final int ordersThisWeek = orderController.ordersThisWeek;
    final int ordersThisMonth = orderController.ordersThisMonth;
    final double totalRevenue = orderController.totalRevenue;

    final analytics = [
      _DashboardMetricData(
        title: 'Total Revenue',
        value: 'GHS ${totalRevenue.toStringAsFixed(2)}',
        icon: Icons.payments_rounded,
        highlight: true,
      ),
      _DashboardMetricData(
        title: 'Total Orders',
        value: '$totalOrders',
        icon: Icons.receipt_long_rounded,
      ),
      _DashboardMetricData(
        title: 'Orders Today',
        value: '$ordersToday',
        icon: Icons.today_rounded,
      ),
      _DashboardMetricData(
        title: 'This Week',
        value: '$ordersThisWeek',
        icon: Icons.date_range_rounded,
      ),
      _DashboardMetricData(
        title: 'This Month',
        value: '$ordersThisMonth',
        icon: Icons.calendar_month_rounded,
      ),
      _DashboardMetricData(
        title: 'Pending Orders',
        value: '$pendingOrdersCount',
        icon: Icons.pending_actions_rounded,
      ),
      _DashboardMetricData(
        title: 'Delivered Orders',
        value: '$deliveredOrdersCount',
        icon: Icons.local_shipping_rounded,
      ),
      _DashboardMetricData(
        title: 'Paid Orders',
        value: '$paidOrdersCount',
        icon: Icons.check_circle_rounded,
      ),
      _DashboardMetricData(
        title: 'Unpaid Orders',
        value: '$unpaidOrdersCount',
        icon: Icons.error_outline_rounded,
      ),
    ];

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
          children: [
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
                  totalRevenue: totalRevenue,
                  totalOrders: totalOrders,
                ),
                const SizedBox(height: 24),
                _AnalyticsSection(
                  isMobile: isMobile,
                  isTablet: isTablet,
                  analytics: analytics,
                ),
                const SizedBox(height: 24),
                if (isMobile)
                  Column(
                    children: [
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
                      const SizedBox(height: 16),
_DashboardActionCard(
  title: 'Delivery Zones',
  subtitle:
      'Add, edit, and remove customer delivery areas and pricing without hard-coded checkout zones.',
  icon: Icons.local_shipping_rounded,
  accentIcon: Icons.location_on_outlined,
  buttonLabel: 'Open Delivery Zones',
  page: AdminDeliveryZonesPage(),
  highlightValue: 'Logistics',
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
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: isTablet ? 1.18 : 1.42,
                    children: [
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
  title: 'Delivery Zones',
  subtitle:
      'Add, edit, and remove customer delivery areas and pricing without hard-coded checkout zones.',
  icon: Icons.local_shipping_rounded,
  accentIcon: Icons.location_on_outlined,
  buttonLabel: 'Open Delivery Zones',
  page: AdminDeliveryZonesPage(),
  highlightValue: 'Logistics',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnalyticsSection extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final List<_DashboardMetricData> analytics;

  const _AnalyticsSection({
    required this.isMobile,
    required this.isTablet,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    final int crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 4);
    final double childAspectRatio = isMobile ? 1.08 : (isTablet ? 1.18 : 1.28);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 22),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(28),
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
          const _SectionTitle(
            title: 'Store Analytics',
            subtitle: 'Live order, payment, and revenue performance overview.',
          ),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: analytics.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              return _DashboardMetricCard(data: analytics[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardMetricData {
  final String title;
  final String value;
  final IconData icon;
  final bool highlight;

  const _DashboardMetricData({
    required this.title,
    required this.value,
    required this.icon,
    this.highlight = false,
  });
}

class _DashboardMetricCard extends StatelessWidget {
  final _DashboardMetricData data;

  const _DashboardMetricCard({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlack,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: data.highlight ? AppColors.gold : AppColors.charcoal,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: isMobile ? 40 : 44,
            width: isMobile ? 40 : 44,
            decoration: BoxDecoration(
              color: data.highlight
                  ? AppColors.gold.withValues(alpha: 0.14)
                  : AppColors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: data.highlight
                    ? AppColors.gold.withValues(alpha: 0.28)
                    : AppColors.charcoal,
              ),
            ),
            child: Icon(
              data.icon,
              color: data.highlight ? AppColors.gold : AppColors.white,
              size: isMobile ? 20 : 22,
            ),
          ),
          const Spacer(),
          Text(
            data.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: data.highlight ? AppColors.gold : AppColors.white,
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardHero extends StatelessWidget {
  final bool isMobile;
  final int newOrdersCount;
  final double totalRevenue;
  final int totalOrders;

  const _DashboardHero({
    required this.isMobile,
    required this.newOrdersCount,
    required this.totalRevenue,
    required this.totalOrders,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      _HeroStatData(
        label: 'Revenue',
        value: 'GHS ${totalRevenue.toStringAsFixed(2)}',
        icon: Icons.payments_rounded,
      ),
      _HeroStatData(
        label: 'Orders',
        value: '$totalOrders total',
        icon: Icons.receipt_long_rounded,
      ),
      _HeroStatData(
        label: 'Alerts',
        value: newOrdersCount > 0 ? '$newOrdersCount new' : 'Up to date',
        icon: Icons.notifications_active_outlined,
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
          'Track revenue, monitor order activity, manage products, control collections, and oversee the full storefront from one premium admin experience.',
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

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.55,
          ),
        ),
      ],
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