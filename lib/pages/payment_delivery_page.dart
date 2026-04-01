import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../data/delivery_zone_controller.dart';
import '../data/store_controller.dart';
import '../data/theme_controller.dart';
import '../models/delivery_zone.dart';
import '../models/store_settings.dart';
import '../widgets/custom_navbar.dart';
import 'admin/admin_dashboard_page.dart';
import 'cart_page.dart';
import 'collections_page.dart';
import 'contact_page.dart';
import 'home_page.dart';
import 'lookbook_page.dart';
import 'menu_page.dart';
import 'track_order_page.dart';

class PaymentDeliveryPage extends StatelessWidget {
  const PaymentDeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final storeController = context.watch<StoreController>();
    final deliveryZoneController = context.watch<DeliveryZoneController>();
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    final storeSettings = storeController.getStoreSettings();
    final activeDeliveryZones = deliveryZoneController.activeZones;
    final paymentMethods = storeController.getPaymentMethods();
    final deliverySteps = storeController.getDeliverySteps();
    final returnExchangeNotes = storeController.getReturnExchangeNotes();

    return Scaffold(
      backgroundColor: palette.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomNavbar(
              activeItem: 'Payment & Delivery',
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
              onTrackOrderTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TrackOrderPage()),
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
              onDeliveryTap: () {},
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
            _PaymentHeroSection(
              storeSettings: storeSettings,
              palette: palette,
            ),
            _DeliveryZonesSection(
              storeSettings: storeSettings,
              deliveryZones: activeDeliveryZones,
              palette: palette,
            ),
            _PaymentMethodsSection(
              paymentMethods: paymentMethods,
              palette: palette,
            ),
            _DeliveryStepsSection(
              deliverySteps: deliverySteps,
              storeSettings: storeSettings,
              palette: palette,
            ),
            _ReturnExchangeSection(notes: returnExchangeNotes, palette: palette),
            _CustomerConfidenceSection(palette: palette),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _PaymentHeroSection extends StatelessWidget {
  final StoreSettings storeSettings;
  final AppPalette palette;

  const _PaymentHeroSection({
    required this.storeSettings,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final activePalette =
        palette ?? AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 26 : 42,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 20 : 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: palette.heroGradient,
              border: Border.all(color: palette.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 22,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _HeroLabel(),
                      const SizedBox(height: 18),
                      _HeroTextBlock(palette: palette),
                      const SizedBox(height: 22),
                      _HeroInfoCard(
                        storeSettings: storeSettings,
                        palette: palette,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HeroLabel(),
                            SizedBox(height: 18),
                            _HeroTextBlock(palette: palette),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: _HeroInfoCard(
                          storeSettings: storeSettings,
                          palette: palette,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _HeroLabel extends StatelessWidget {
  const _HeroLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Text(
        'Payment & Delivery',
        style: TextStyle(
          color: AppColors.primaryBlack,
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _HeroTextBlock extends StatelessWidget {
  final AppPalette palette;

  const _HeroTextBlock({
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clear payment and delivery info builds customer trust faster.',
          style: TextStyle(
            color: palette.textOnStrong,
            fontSize: 34,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        SizedBox(height: 14),
        Text(
          'This page explains how customers can pay, how delivery works in Ghana, and what to expect after placing an order.',
          style: TextStyle(
            color: palette.textSecondary,
            fontSize: 15,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _HeroInfoCard extends StatelessWidget {
  final StoreSettings storeSettings;
  final AppPalette palette;

  const _HeroInfoCard({
    required this.storeSettings,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MiniInfoRow(
            icon: Icons.location_on_outlined,
            title: 'Base Location',
            subtitle: storeSettings.address,
            palette: palette,
          ),
          const SizedBox(height: 14),
          const _MiniInfoRow(
            icon: Icons.local_shipping_outlined,
            title: 'Zone-Based Delivery',
            subtitle: 'Pricing now follows the selected delivery zone.',
          ),
          const SizedBox(height: 14),
          _MiniInfoRow(
            icon: Icons.card_giftcard_outlined,
            title: 'Free Delivery',
            subtitle:
                'Available from GHS ${storeSettings.freeDeliveryThreshold.toStringAsFixed(0)}',
            palette: palette,
          ),
        ],
      ),
    );
  }
}

class _MiniInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final AppPalette? palette;

  const _MiniInfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final activePalette =
        palette ?? AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryBlack,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: activePalette.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: activePalette.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DeliveryZonesSection extends StatelessWidget {
  final StoreSettings storeSettings;
  final List<DeliveryZone> deliveryZones;
  final AppPalette palette;

  const _DeliveryZonesSection({
    required this.storeSettings,
    required this.deliveryZones,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final activePalette =
        palette ?? AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 10,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Zones',
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                deliveryZones.isEmpty
                    ? 'Delivery zones are currently unavailable. Please contact DTHC before placing your order.'
                    : 'These delivery zones are managed directly from the DTHC admin panel. Only active zones are shown here and fees update automatically.',
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              if (deliveryZones.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: palette.card,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: palette.border),
                  ),
                  child: Text(
                    'No active delivery zones have been added yet. Please check back soon or contact DTHC on ${storeSettings.phoneNumber}.',
                    style: TextStyle(
                      color: palette.textSecondary,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: deliveryZones
                      .map(
                        (zone) => _DeliveryZoneCard(
                          zone: zone,
                          cardWidth: isMobile ? double.infinity : 400,
                          palette: palette,
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeliveryZoneCard extends StatelessWidget {
  final DeliveryZone zone;
  final double cardWidth;
  final AppPalette palette;

  const _DeliveryZoneCard({
    required this.zone,
    required this.cardWidth,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primaryBlack,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.gold),
                ),
                child: const Text(
                  'Active Zone',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            zone.name,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Select this zone during checkout to apply the correct delivery fee to your final order total.',
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: palette.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Fee',
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'GHS ${zone.fee.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'This fee is synced from admin settings and updates automatically when changed.',
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 13,
                    height: 1.5,
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

class _PaymentMethodsSection extends StatelessWidget {
  final List<Map<String, dynamic>> paymentMethods;
  final AppPalette? palette;

  const _PaymentMethodsSection({
    required this.paymentMethods,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final activePalette =
        palette ?? AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 10,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Methods',
                style: TextStyle(
                  color: activePalette.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Show customers the available payment options clearly so checkout feels straightforward and trustworthy.',
                style: TextStyle(
                  color: activePalette.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                children: paymentMethods
                    .map(
                      (method) => _PaymentMethodCard(
                        method: method,
                        cardWidth: isMobile ? double.infinity : 400,
                        palette: activePalette,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final Map<String, dynamic> method;
  final double cardWidth;
  final AppPalette? palette;

  const _PaymentMethodCard({
    required this.method,
    required this.cardWidth,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final activePalette =
        palette ?? AppColors.palette(context.watch<ThemeController>().isDarkMode);
    final title = '${method['title'] ?? ''}';
    final subtitle = '${method['subtitle'] ?? ''}';
    final iconKey = '${method['icon'] ?? ''}';

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: activePalette.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: activePalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _mapIcon(iconKey),
              color: AppColors.primaryBlack,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: activePalette.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: activePalette.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  IconData _mapIcon(String iconKey) {
    switch (iconKey) {
      case 'momo':
        return Icons.phone_android_outlined;
      case 'card':
        return Icons.credit_card_outlined;
      case 'delivery':
        return Icons.local_shipping_outlined;
      default:
        return Icons.payments_outlined;
    }
  }
}

class _DeliveryStepsSection extends StatelessWidget {
  final List<Map<String, dynamic>> deliverySteps;
  final StoreSettings storeSettings;
  final AppPalette? palette;

  const _DeliveryStepsSection({
    required this.deliverySteps,
    required this.storeSettings,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final activePalette =
        palette ?? AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Container(
      width: double.infinity,
      color: activePalette.surfaceAlt,
      padding: EdgeInsets.symmetric(
        horizontal: width < 768 ? 16 : 32,
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How Delivery Works',
                style: TextStyle(
                  color: activePalette.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'DTHC currently supports delivery coordination from ${storeSettings.address} with clear order confirmation before dispatch.',
                style: TextStyle(
                  color: activePalette.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              ...List.generate(deliverySteps.length, (index) {
                final step = deliverySteps[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == deliverySteps.length - 1 ? 0 : 16,
                  ),
                  child: _DeliveryStepCard(
                    stepNumber: index + 1,
                    title: '${step['title'] ?? ''}',
                    subtitle: '${step['subtitle'] ?? ''}',
                    palette: activePalette,
                  ),
                );
              }),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: activePalette.card,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: activePalette.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Timing Notes',
                      style: TextStyle(
                        color: activePalette.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Orders confirmed early in the day can be prepared faster. Late-night, weekend, holiday, or out-of-zone orders may move to the next available dispatch window.',
                      style: TextStyle(
                        color: activePalette.textSecondary,
                        fontSize: 14,
                        height: 1.6,
                      ),
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

class _DeliveryStepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String subtitle;
  final AppPalette? palette;

  const _DeliveryStepCard({
    required this.stepNumber,
    required this.title,
    required this.subtitle,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final activePalette =
        palette ?? AppColors.palette(context.watch<ThemeController>().isDarkMode);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: activePalette.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: activePalette.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: const TextStyle(
                  color: AppColors.primaryBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: activePalette.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: activePalette.textSecondary,
                    fontSize: 14,
                    height: 1.6,
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

class _ReturnExchangeSection extends StatelessWidget {
  final List<Map<String, dynamic>> notes;
  final AppPalette? palette;

  const _ReturnExchangeSection({
    required this.notes,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final activePalette =
        palette ?? AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Returns & Exchanges',
                style: TextStyle(
                  color: activePalette.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'These notes help customers understand what support is available after they receive their order.',
                style: TextStyle(
                  color: activePalette.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                children: notes.map((note) {
                  return _ReturnNoteCard(
                    title: '${note['title'] ?? ''}',
                    subtitle: '${note['subtitle'] ?? ''}',
                    cardWidth: isMobile ? double.infinity : 400,
                    palette: activePalette,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReturnNoteCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double cardWidth;
  final AppPalette? palette;

  const _ReturnNoteCard({
    required this.title,
    required this.subtitle,
    required this.cardWidth,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final activePalette =
        palette ?? AppColors.palette(context.watch<ThemeController>().isDarkMode);
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: activePalette.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: activePalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.swap_horiz_rounded,
              color: AppColors.primaryBlack,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: activePalette.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: activePalette.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerConfidenceSection extends StatelessWidget {
  final AppPalette? palette;

  const _CustomerConfidenceSection({
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final activePalette =
        palette ?? AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Container(
      width: double.infinity,
      color: activePalette.surfaceAlt,
      padding: EdgeInsets.symmetric(
        horizontal: width < 768 ? 16 : 32,
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              Text(
                'Why this page matters',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: activePalette.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Customers trust fashion stores more when payment options, delivery flow, and return support are clearly explained.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: activePalette.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                alignment: WrapAlignment.center,
                children: [
                  _ConfidenceCard(
                    icon: Icons.verified_user_outlined,
                    title: 'Builds Trust',
                    subtitle:
                        'Customers feel safer buying when expectations are clear.',
                    palette: activePalette,
                  ),
                  _ConfidenceCard(
                    icon: Icons.payments_outlined,
                    title: 'Explains Payment',
                    subtitle:
                        'Clear payment guidance reduces checkout hesitation.',
                    palette: activePalette,
                  ),
                  _ConfidenceCard(
                    icon: Icons.local_shipping_outlined,
                    title: 'Sets Delivery Expectations',
                    subtitle:
                        'Customers understand timing, process, and support options.',
                    palette: activePalette,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfidenceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final AppPalette? palette;

  const _ConfidenceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final activePalette =
        palette ?? AppColors.palette(context.watch<ThemeController>().isDarkMode);
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: activePalette.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: activePalette.border),
      ),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryBlack,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: activePalette.textPrimary,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: activePalette.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
