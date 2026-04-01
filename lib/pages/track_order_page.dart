import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../data/order_controller.dart';
import '../data/theme_controller.dart';
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

  String _normalizeTrackingCode(String value) {
    return value.trim().toLowerCase().replaceAll(' ', '');
  }

  String _normalizePhone(String value) {
    return value.trim().toLowerCase().replaceAll(' ', '');
  }

  void _searchOrder() {
    final trackingCode = _normalizeTrackingCode(_trackingCodeController.text);
    final phone = _normalizePhone(_phoneController.text);

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
          : _normalizeTrackingCode(order.trackingCode) == trackingCode;

      final matchesPhone = phone.isEmpty
          ? true
          : _normalizePhone(order.phoneNumber).contains(phone);

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
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Scaffold(
      backgroundColor: palette.background,
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
                      _TrackHeroSection(isMobile: isMobile, palette: palette),
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
                                  palette: palette,
                                ),
                                const SizedBox(height: 18),
                                _TrackResultPanel(
                                  order: _matchedOrder,
                                  feedbackMessage: _feedbackMessage,
                                  palette: palette,
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
                                    palette: palette,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  flex: 6,
                                  child: _TrackResultPanel(
                                    order: _matchedOrder,
                                    feedbackMessage: _feedbackMessage,
                                    palette: palette,
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
  final AppPalette palette;

  const _TrackHeroSection({
    required this.isMobile,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 26),
      decoration: BoxDecoration(
        gradient: palette.heroGradient,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Track Your Order',
            style: TextStyle(
              color: palette.textOnStrong,
              fontSize: isMobile ? 28 : 38,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Use your tracking code or phone number to check your current DTHC order progress, payment updates, and delivery status.',
            style: TextStyle(
              color: palette.textSecondary,
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
  final AppPalette palette;

  const _TrackSearchCard({
    required this.trackingCodeController,
    required this.phoneController,
    required this.onSearch,
    required this.onClear,
    required this.palette,
  });

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: palette.textSecondary),
      prefixIcon: Icon(icon, color: AppColors.gold),
      filled: true,
      fillColor: palette.surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: palette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: palette.border),
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
        color: palette.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: palette.border),
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
          Text(
            'For best results, enter your tracking code. You can also add your phone number.',
            style: TextStyle(
              color: palette.textSecondary,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: trackingCodeController,
            style: TextStyle(color: palette.textPrimary),
            decoration: _decoration(
              'Tracking Code',
              Icons.local_shipping_outlined,
            ),
            onSubmitted: (_) => onSearch(),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: palette.textPrimary),
            decoration: _decoration(
              'Phone Number (optional)',
              Icons.phone_outlined,
            ),
            onSubmitted: (_) => onSearch(),
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
                  foregroundColor: palette.textPrimary,
                  side: BorderSide(color: palette.border),
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
  final AppPalette palette;

  const _TrackResultPanel({
    required this.order,
    required this.feedbackMessage,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    if (order == null && feedbackMessage == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Status',
              style: TextStyle(
                color: palette.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your order result will appear here after you search.',
              style: TextStyle(
                color: palette.textSecondary,
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
          color: palette.card,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: palette.border),
        ),
        child: Text(
          feedbackMessage ?? 'No matching order found.',
          style: TextStyle(
            color: palette.textPrimary,
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
        color: palette.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDelivered ? AppColors.gold : palette.border,
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
          _StatusHeader(order: order!, palette: palette),
          const SizedBox(height: 18),
          _StatusSummaryGrid(order: order!),
          const SizedBox(height: 18),
          _SectionTitle(title: 'Order Details', palette: palette),
          const SizedBox(height: 12),
          _TrackInfoCard(
            title: 'Tracking Code',
            value: order!.trackingCode.isEmpty ? 'Not assigned' : order!.trackingCode,
            goldValue: true,
            palette: palette,
          ),
          const SizedBox(height: 12),
          _TrackInfoCard(
            title: 'Order Date',
            value: DateFormat('EEE, d MMM yyyy • h:mm a').format(order!.createdAt),
            palette: palette,
          ),
          const SizedBox(height: 12),
          _TrackInfoCard(
            title: 'Payment Method',
            value: order!.paymentMethod,
            palette: palette,
          ),
          const SizedBox(height: 12),
          _TrackInfoCard(
            title: 'Customer',
            value: order!.customerName,
            palette: palette,
          ),
          const SizedBox(height: 12),
          _TrackInfoCard(
            title: 'Phone',
            value: order!.phoneNumber,
            palette: palette,
          ),
          const SizedBox(height: 12),
          _TrackInfoCard(
            title: 'Delivery Address',
            value: order!.address,
            palette: palette,
          ),
          if (order!.note.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            _TrackInfoCard(
              title: 'Order Note',
              value: order!.note,
              palette: palette,
            ),
          ],
          const SizedBox(height: 18),
          _SectionTitle(title: 'Payment & Delivery', palette: palette),
          const SizedBox(height: 12),
          _TrackInfoCard(
            title: 'Payment Status',
            value: order!.paymentStatus,
            goldValue: _isPositivePaymentStatus(order!.paymentStatus),
            palette: palette,
          ),
          const SizedBox(height: 12),
          _TrackInfoCard(
            title: 'Payment Proof Status',
            value: order!.paymentProofStatus,
            goldValue: _isProofProvided(order!.paymentProofStatus),
            palette: palette,
          ),
          const SizedBox(height: 12),
          _TrackInfoCard(
            title: 'Payment Update Sent',
            value: order!.paymentUpdateSent ? 'Yes' : 'No',
            goldValue: order!.paymentUpdateSent,
            palette: palette,
          ),
          const SizedBox(height: 12),
          _TrackInfoCard(
            title: 'Delivery Status',
            value: order!.isDelivered ? 'Delivered' : 'Not Delivered Yet',
            goldValue: order!.isDelivered,
            palette: palette,
          ),
          const SizedBox(height: 18),
          _SectionTitle(title: 'Order Summary', palette: palette),
          const SizedBox(height: 12),
          _OrderAmountRow(
            label: 'Subtotal',
            value: 'GHS ${order!.subtotal.toStringAsFixed(2)}',
            palette: palette,
          ),
          const SizedBox(height: 10),
          _OrderAmountRow(
            label: 'Delivery Fee',
            value: 'GHS ${order!.deliveryFee.toStringAsFixed(2)}',
            palette: palette,
          ),
          const SizedBox(height: 10),
          _OrderAmountRow(
            label: 'Total',
            value: 'GHS ${order!.total.toStringAsFixed(2)}',
            isHighlighted: true,
            palette: palette,
          ),
          const SizedBox(height: 18),
          _SectionTitle(title: 'Ordered Items', palette: palette),
          const SizedBox(height: 12),
          ...order!.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _TrackedItemCard(item: item, palette: palette),
            ),
          ),
        ],
      ),
    );
  }

  static bool _isPositivePaymentStatus(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'paid' ||
        normalized == 'confirmed' ||
        normalized == 'completed' ||
        normalized == 'successful';
  }

  static bool _isProofProvided(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'sent' ||
        normalized == 'submitted' ||
        normalized == 'received' ||
        normalized == 'verified';
  }
}

class _StatusHeader extends StatelessWidget {
  final CustomerOrder order;
  final AppPalette palette;

  const _StatusHeader({
    required this.order,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final isDelivered = order.isDelivered;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDelivered ? AppColors.gold : palette.border,
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
                  isDelivered ? 'Order Delivered' : 'Order Received',
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isDelivered
                      ? 'Your order has been marked as delivered by DTHC.'
                      : 'Your order has been received and is currently being processed.',
                  style: TextStyle(
                    color: palette.textSecondary,
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

class _StatusSummaryGrid extends StatelessWidget {
  final CustomerOrder order;

  const _StatusSummaryGrid({
    required this.order,
  });

  Color _badgeColor(bool active) {
    return active ? AppColors.gold : AppColors.charcoal;
  }

  Color _textColor(bool active) {
    return active ? AppColors.primaryBlack : AppColors.white;
  }

  @override
  Widget build(BuildContext context) {
    final paymentPaid = _TrackResultPanel._isPositivePaymentStatus(
      order.paymentStatus,
    );
    final proofSent = _TrackResultPanel._isProofProvided(
      order.paymentProofStatus,
    );

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _MiniStatusBadge(
          label: order.isDelivered ? 'Delivered' : 'Pending Delivery',
          color: _badgeColor(order.isDelivered),
          textColor: _textColor(order.isDelivered),
          icon: order.isDelivered
              ? Icons.local_shipping
              : Icons.inventory_2_outlined,
        ),
        _MiniStatusBadge(
          label: paymentPaid ? 'Payment Confirmed' : order.paymentStatus,
          color: _badgeColor(paymentPaid),
          textColor: _textColor(paymentPaid),
          icon: paymentPaid ? Icons.payments : Icons.account_balance_wallet_outlined,
        ),
        _MiniStatusBadge(
          label: proofSent ? 'Proof Submitted' : order.paymentProofStatus,
          color: _badgeColor(proofSent),
          textColor: _textColor(proofSent),
          icon: proofSent ? Icons.receipt_long : Icons.image_outlined,
        ),
        _MiniStatusBadge(
          label: order.paymentUpdateSent
              ? 'Update Sent'
              : 'No Payment Update Yet',
          color: _badgeColor(order.paymentUpdateSent),
          textColor: _textColor(order.paymentUpdateSent),
          icon: order.paymentUpdateSent ? Icons.message : Icons.chat_bubble_outline,
        ),
      ],
    );
  }
}

class _MiniStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final IconData icon;

  const _MiniStatusBadge({
    required this.label,
    required this.color,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final AppPalette palette;

  const _SectionTitle({
    required this.title,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: palette.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _TrackInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final bool goldValue;
  final AppPalette palette;

  const _TrackInfoCard({
    required this.title,
    required this.value,
    this.goldValue = false,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: palette.textSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: goldValue ? AppColors.gold : palette.textPrimary,
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

class _OrderAmountRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;
  final AppPalette palette;

  const _OrderAmountRow({
    required this.label,
    required this.value,
    this.isHighlighted = false,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isHighlighted ? AppColors.gold : palette.border,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: palette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isHighlighted ? AppColors.gold : palette.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackedItemCard extends StatelessWidget {
  final dynamic item;
  final AppPalette palette;

  const _TrackedItemCard({
    required this.item,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.imageUrl.toString().trim();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 58,
              height: 58,
              color: palette.surfaceAlt,
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
              style: TextStyle(
                color: palette.textPrimary,
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
