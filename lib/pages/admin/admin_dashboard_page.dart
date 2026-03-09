import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/order_controller.dart';
import 'admin_food_page.dart';
import 'admin_orders_page.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;
    final int newOrdersCount = context.watch<OrderController>().newOrdersCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminOrdersPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications),
                  tooltip: 'New Orders',
                ),
                if (newOrdersCount > 0)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$newOrdersCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
                        child: isMobile
                ? SingleChildScrollView(
                    child: Column(
                      children: const [
                        _DashboardActionCard(
                          title: 'Food Management',
                          subtitle:
                              'Add foods, edit food details, change image URLs, stock, price, availability, and featured items.',
                          icon: Icons.restaurant_menu,
                          page: AdminFoodPage(),
                        ),
                        SizedBox(height: 16),
                        _DashboardActionCard(
                          title: 'Customer Orders',
                          subtitle:
                              'See all placed orders, customer details, totals, and new incoming orders.',
                          icon: Icons.receipt_long,
                          page: AdminOrdersPage(),
                        ),
                      ],
                    ),
                  )
                : GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: 1.45,
                    children: const [
                      _DashboardActionCard(
                        title: 'Food Management',
                        subtitle:
                            'Add foods, edit food details, change image URLs, stock, price, availability, and featured items.',
                        icon: Icons.restaurant_menu,
                        page: AdminFoodPage(),
                      ),
                      _DashboardActionCard(
                        title: 'Customer Orders',
                        subtitle:
                            'See all placed orders, customer details, totals, and new incoming orders.',
                        icon: Icons.receipt_long,
                        page: AdminOrdersPage(),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _DashboardActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;

  const _DashboardActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDDE5DD)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF6ED),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF166534),
              size: 30,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF667085),
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
                backgroundColor: const Color(0xFF166534),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Open',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}