import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../data/order_controller.dart';
import '../models/customer_order.dart';
import '../widgets/custom_navbar.dart';
import 'admin/admin_dashboard_page.dart';
import 'cart_page.dart';
import 'collections_page.dart';
import 'contact_page.dart';
import 'home_page.dart';
import 'lookbook_page.dart';
import 'menu_page.dart';
import 'payment_delivery_page.dart';

class TrackOrderPage extends StatefulWidget {
  const TrackOrderPage({super.key});

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  final TextEditingController _trackingCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  CustomerOrder? _matchedOrder;
  String? _feedbackMessage;

  @override
  void dispose() {
    _trackingCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _searchOrder() {
    final trackingCode = _trackingCodeController.text.trim().toLowerCase();
    final phone = _phoneController.text.trim().toLowerCase();

    if (trackingCode.isEmpty && phone.isEmpty) {
      setState(() {
        _matchedOrder = null;
        _feedbackMessage = 'Enter a tracking code or phone number to search.';
      });
      return;
    }

    final orders = context.read<OrderController>().orders;

    CustomerOrder? foundOrder;

    for (final order in orders) {
      final matchesTracking = trackingCode.isEmpty
          ? true
          : order.trackingCode.trim().toLowerCase() == trackingCode;

      final matchesPhone = phone.isEmpty
          ? true
          : order.phoneNumber.trim().toLowerCase().contains(phone);

      if (matchesTracking && matchesPhone) {
        foundOrder = order;
        break;
      }
    }

    setState(() {
      _matchedOrder = foundOrder;
      _feedbackMessage = foundOrder == null
          ? 'No matching order found. Check the tracking code or phone number and try again.'
          : null;
    });
  }

  void _clearSearch() {
    setState(() {
      _trackingCodeController.clear();
      _phoneController.clear();
      _matchedOrder = null;
      _feedbackMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomNavbar(
              activeItem: 'Track Order',
              onHomeTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              },
              onMenuTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MenuPage()),
                );
              },
              onSpecialPacksTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CollectionsPage()),
                );
              },
              onCartTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
              onContactTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactPage()),
                );
              },
              onLookbookTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LookbookPage()),
                );
              },
              onDeliveryTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentDeliveryPage(),
                  ),
                );
              },
              onTrackOrderTap: () {},
              onOrderNowTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MenuPage()),
                );
              },
              onAdminTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminDashboardPage(),
                  ),
                );
              },
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 28,
                vertical: isMobile ? 20 : 30,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TrackHeroSection(isMobile: isMobile),
                      const SizedBox(height: 22),
                      isMobile
                          ? Column(
                              children: [
                                _TrackSearchCard(
                                  trackingCodeController:
                                      _trackingCodeController,
                                  phoneController: _phoneController,
                                  onSearch: _searchOrder,
                                  onClear: _clearSearch,
                                ),
                                const SizedBox(height: 18),
                                _TrackResultPanel(
                                  order: _matchedOrder,
                                  feedbackMessage: _feedbackMessage,
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: _TrackSearchCard(
                                    trackingCodeController:
                                        _trackingCodeController,
                                    phoneController: _phoneController,
                                    onSearch: _searchOrder,
                                    onClear: _clearSearch,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  flex: 6,
                                  child: _TrackResultPanel(
                                    order: _matchedOrder,
                                    feedbackMessage: _feedbackMessage,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackHeroSection extends StatelessWidget {
  final bool isMobile;

  const _TrackHeroSection({
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 26),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Track Your Order',
            style: TextStyle(
              color: AppColors.white,
              fontSize: isMobile ? 28 : 38,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Use your tracking code or phone number to check whether your DTHC order is pending or delivered.',
            style: TextStyle(
              color: const Color(0xFFDBDBDB),
              fontSize: isMobile ? 14 : 15,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackSearchCard extends StatelessWidget {
  final TextEditingController trackingCodeController;
  final TextEditingController phoneController;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  const _TrackSearchCard({
    required this.trackingCodeController,
    required this.phoneController,
    required this.onSearch,
    required this.onClear,
  });

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFFBDBDBD)),
      prefixIcon: Icon(icon, color: AppColors.gold),
      filled: true,
      fillColor: AppColors.primaryBlack,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.charcoal),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.charcoal),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
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
          const Text(
            'Search Details',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'For best results, enter your tracking code. You can also add your phone number.',
            style: TextStyle(
              color: Color(0xFFBDBDBD),
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: trackingCodeController,
            style: const TextStyle(color: AppColors.white),
            decoration: _decoration(
              'Tracking Code',
              Icons.local_shipping_outlined,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: AppColors.white),
            decoration: _decoration(
              'Phone Number (optional)',
              Icons.phone_outlined,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.primaryBlack,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.search_rounded),
                  label: const Text(
                    'Track Order',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: onClear,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.white,
                  side: const BorderSide(color: AppColors.charcoal),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Clear',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrackResultPanel extends StatelessWidget {
  final CustomerOrder? order;
  final String? feedbackMessage;

  const _TrackResultPanel({
    required this.order,
    required this.feedbackMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (order == null && feedbackMessage == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.softBlack,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.charcoal),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Status',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your order result will appear here after you search.',
              style: TextStyle(
                color: Color(0xFFBDBDBD),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (order == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.softBlack,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.charcoal),
        ),
        child: Text(
          feedbackMessage ?? 'No matching order found.',
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 15,
            height: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    final isDelivered = order!.isDelivered;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDelivered ? AppColors.gold : AppColors.charcoal,
        ),
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
          _StatusHeader(order: order!),
          const SizedBox(height: 18),
          _TrackInfoCard(
            title: 'Tracking Code',
            value: order!.trackingCode.isEmpty ? 'Not assigned' : order!.trackingCode,
            goldValue: true,
          ),
          const SizedBox(height: 12),
          _TrackInfoCard(
            title: 'Payment Method',
            value: order!.paymentMethod,
          ),
          const SizedBox(height: 12),
          _TrackInfoCard(
            title: 'Customer',
            value: order!.customerName,
          ),
          const SizedBox(height: 12),
          _TrackInfoCard(
            title: 'Phone',
            value: order!.phoneNumber,
          ),
          const SizedBox(height: 12),
          _TrackInfoCard(
            title: 'Delivery Address',
            value: order!.address,
          ),
          const SizedBox(height: 12),
          _TrackInfoCard(
            title: 'Order Total',
            value: 'GHS ${order!.total.toStringAsFixed(2)}',
            goldValue: true,
          ),
          if (order!.note.isNotEmpty) ...[
            const SizedBox(height: 12),
            _TrackInfoCard(
              title: 'Order Note',
              value: order!.note,
            ),
          ],
          const SizedBox(height: 18),
          const Text(
            'Ordered Items',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...order!.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _TrackedItemCard(item: item),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusHeader extends StatelessWidget {
  final CustomerOrder order;

  const _StatusHeader({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final isDelivered = order.isDelivered;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryBlack,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDelivered ? AppColors.gold : AppColors.charcoal,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: isDelivered ? AppColors.gold : AppColors.charcoal,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isDelivered ? Icons.check_circle : Icons.access_time,
              color: isDelivered ? AppColors.primaryBlack : AppColors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDelivered ? 'Order Delivered' : 'Order Pending',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isDelivered
                      ? 'Your order has been marked as delivered by DTHC.'
                      : 'Your order has been received and is being processed.',
                  style: const TextStyle(
                    color: Color(0xFFBDBDBD),
                    height: 1.5,
                    fontWeight: FontWeight.w500,
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

class _TrackInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final bool goldValue;

  const _TrackInfoCard({
    required this.title,
    required this.value,
    this.goldValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryBlack,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.greyText,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: goldValue ? AppColors.gold : AppColors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackedItemCard extends StatelessWidget {
  final dynamic item;

  const _TrackedItemCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.imageUrl.toString().trim();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryBlack,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 58,
              height: 58,
              color: AppColors.charcoal,
              child: imageUrl.isEmpty
                  ? const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.gold,
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.shopping_bag_outlined,
                          color: AppColors.gold,
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${item.name} x${item.quantity}',
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'GHS ${item.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}