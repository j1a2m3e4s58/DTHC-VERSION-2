import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'contact_page.dart';
import '../core/app_colors.dart';
import '../data/store_controller.dart';
import '../models/store_settings.dart';
import '../widgets/custom_navbar.dart';
import 'admin/admin_dashboard_page.dart';
import 'cart_page.dart';
import 'collections_page.dart';
import 'home_page.dart';
import 'lookbook_page.dart';
import 'menu_page.dart';

class PaymentDeliveryPage extends StatelessWidget {
  const PaymentDeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StoreController>();
    final storeSettings = controller.getStoreSettings();
    final paymentMethods = controller.getPaymentMethods();
    final deliverySteps = controller.getDeliverySteps();
    final returnExchangeNotes = controller.getReturnExchangeNotes();

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
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
            _PaymentHeroSection(storeSettings: storeSettings),
            _DeliveryZonesSection(storeSettings: storeSettings),
            _PaymentMethodsSection(paymentMethods: paymentMethods),
            _DeliveryStepsSection(
              deliverySteps: deliverySteps,
              storeSettings: storeSettings,
            ),
            _ReturnExchangeSection(notes: returnExchangeNotes),
            const _CustomerConfidenceSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _PaymentHeroSection extends StatelessWidget {
  final StoreSettings storeSettings;

  const _PaymentHeroSection({
    required this.storeSettings,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

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
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1D1D1D),
                  Color(0xFF0C0C0C),
                ],
              ),
              border: Border.all(color: AppColors.charcoal),
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
                      const _HeroTextBlock(),
                      const SizedBox(height: 22),
                      _HeroInfoCard(storeSettings: storeSettings),
                    ],
                  )
                : Row(
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HeroLabel(),
                            SizedBox(height: 18),
                            _HeroTextBlock(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: _HeroInfoCard(storeSettings: storeSettings),
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
  const _HeroTextBlock();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clear payment and delivery info builds customer trust faster.',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 34,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        SizedBox(height: 14),
        Text(
          'This page explains how customers can pay, how delivery works in Ghana, and what to expect after placing an order.',
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

class _HeroInfoCard extends StatelessWidget {
  final StoreSettings storeSettings;

  const _HeroInfoCard({
    required this.storeSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MiniInfoRow(
            icon: Icons.location_on_outlined,
            title: 'Base Location',
            subtitle: storeSettings.address,
          ),
          const SizedBox(height: 14),
          _MiniInfoRow(
            icon: Icons.local_shipping_outlined,
            title: 'Standard Delivery Fee',
            subtitle: 'From GHS ${storeSettings.deliveryFee.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 14),
          _MiniInfoRow(
            icon: Icons.card_giftcard_outlined,
            title: 'Free Delivery',
            subtitle:
                'Available from GHS ${storeSettings.freeDeliveryThreshold.toStringAsFixed(0)}',
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

  const _MiniInfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
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
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFFBDBDBD),
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

  const _DeliveryZonesSection({
    required this.storeSettings,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final zones = _ghanaDeliveryZones(storeSettings);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width < 768 ? 16 : 32,
        vertical: 10,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ghana Delivery Zones',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Make delivery feel realistic by showing different Ghana zones, estimated timing, and how fees change by distance.',
                style: TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                children: zones
                    .map((zone) => _DeliveryZoneCard(zone: zone))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _ghanaDeliveryZones(StoreSettings storeSettings) {
    final baseFee = storeSettings.deliveryFee;
    final freeThreshold = storeSettings.freeDeliveryThreshold;

    return [
      {
        'title': 'Accra Central',
        'subtitle':
            'Same-city delivery for Accra Mall, Osu, East Legon, Spintex, Adabraka, and nearby areas.',
        'fee': baseFee,
        'time': 'Same day or within 24 hours',
        'icon': Icons.location_city_outlined,
        'badge': 'Fastest Zone',
      },
      {
        'title': 'Greater Accra Outer Zone',
        'subtitle':
            'For Tema, Kasoa, Madina, Adenta, Amasaman, and surrounding areas outside central delivery routes.',
        'fee': baseFee + 10,
        'time': '1 to 2 business days',
        'icon': Icons.map_outlined,
        'badge': 'Popular Route',
      },
      {
        'title': 'Regional Delivery',
        'subtitle':
            'For Kumasi, Takoradi, Cape Coast, Ho, Koforidua, Tamale, and other major towns across Ghana.',
        'fee': baseFee + 20,
        'time': '2 to 4 business days',
        'icon': Icons.local_shipping_outlined,
        'badge': 'Nationwide',
      },
      {
        'title': 'Express Coordination',
        'subtitle':
            'Urgent delivery requests can be discussed directly before dispatch depending on rider and route availability.',
        'fee': null,
        'time': 'Custom timing after confirmation',
        'icon': Icons.flash_on_outlined,
        'badge': 'By Request',
      },
      {
        'title': 'Free Delivery Threshold',
        'subtitle':
            'Orders above this amount can qualify for free delivery in selected Accra routes depending on active promo policy.',
        'fee': freeThreshold,
        'time': 'Applies after order review',
        'icon': Icons.card_giftcard_outlined,
        'badge': 'Promo Ready',
      },
    ];
  }
}

class _DeliveryZoneCard extends StatelessWidget {
  final Map<String, dynamic> zone;

  const _DeliveryZoneCard({
    required this.zone,
  });

  @override
  Widget build(BuildContext context) {
    final title = '${zone['title'] ?? ''}';
    final subtitle = '${zone['subtitle'] ?? ''}';
    final time = '${zone['time'] ?? ''}';
    final badge = '${zone['badge'] ?? ''}';
    final fee = zone['fee'];
    final icon = zone['icon'] as IconData? ?? Icons.local_shipping_outlined;

    return Container(
      width: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.charcoal),
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
                child: Icon(
                  icon,
                  color: AppColors.primaryBlack,
                ),
              ),
              if (badge.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2212),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.gold),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
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
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.charcoal,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fee is num
                      ? 'Estimated Fee: GHS ${fee.toStringAsFixed(0)}'
                      : 'Estimated Fee: Confirm before dispatch',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Timing: $time',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
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

  const _PaymentMethodsSection({
    required this.paymentMethods,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width < 768 ? 16 : 32,
        vertical: 10,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Methods',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Show customers the available payment options clearly so checkout feels straightforward and trustworthy.',
                style: TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                children: paymentMethods
                    .map((method) => _PaymentMethodCard(method: method))
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

  const _PaymentMethodCard({
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    final title = '${method['title'] ?? ''}';
    final subtitle = '${method['subtitle'] ?? ''}';
    final iconKey = '${method['icon'] ?? ''}';

    return Container(
      width: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.charcoal),
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
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFFBDBDBD),
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

  const _DeliveryStepsSection({
    required this.deliverySteps,
    required this.storeSettings,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      color: AppColors.softBlack,
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
              const Text(
                'How Delivery Works',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'DTHC currently supports delivery coordination from ${storeSettings.address} with clear order confirmation before dispatch.',
                style: const TextStyle(
                  color: Color(0xFFBDBDBD),
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
                  ),
                );
              }),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlack,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.charcoal),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Timing Notes',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Orders confirmed early in the day can be prepared faster. Late-night, weekend, holiday, or out-of-zone orders may move to the next available dispatch window.',
                      style: TextStyle(
                        color: Color(0xFFD0D0D0),
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

  const _DeliveryStepCard({
    required this.stepNumber,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
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
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFFD0D0D0),
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

  const _ReturnExchangeSection({
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
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
              const Text(
                'Returns & Exchanges',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'These notes help customers understand what support is available after they receive their order.',
                style: TextStyle(
                  color: Color(0xFFBDBDBD),
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

  const _ReturnNoteCard({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.charcoal),
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
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFFBDBDBD),
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
  const _CustomerConfidenceSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      color: AppColors.softBlack,
      padding: EdgeInsets.symmetric(
        horizontal: width < 768 ? 16 : 32,
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              const Text(
                'Why this page matters',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Customers trust fashion stores more when payment options, delivery flow, and return support are clearly explained.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                alignment: WrapAlignment.center,
                children: const [
                  _ConfidenceCard(
                    icon: Icons.verified_user_outlined,
                    title: 'Builds Trust',
                    subtitle:
                        'Customers feel safer buying when expectations are clear.',
                  ),
                  _ConfidenceCard(
                    icon: Icons.payments_outlined,
                    title: 'Explains Payment',
                    subtitle:
                        'Clear payment guidance reduces checkout hesitation.',
                  ),
                  _ConfidenceCard(
                    icon: Icons.local_shipping_outlined,
                    title: 'Sets Delivery Expectations',
                    subtitle:
                        'Customers understand timing, process, and support options.',
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

  const _ConfidenceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
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
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFD0D0D0),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}