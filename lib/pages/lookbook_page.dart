import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'payment_delivery_page.dart';
import '../core/app_colors.dart';
import '../data/store_controller.dart';
import '../widgets/custom_navbar.dart';
import 'admin/admin_dashboard_page.dart';
import 'cart_page.dart';
import 'collections_page.dart';
import 'home_page.dart';
import 'menu_page.dart';

class LookbookPage extends StatelessWidget {
  const LookbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StoreController>();
    final entries = controller.getLookbookEntries();

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomNavbar(
              activeItem: 'Lookbook',
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Contact page will be connected next.'),
                  ),
                );
              },
              onLookbookTap: () {},
onDeliveryTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const PaymentDeliveryPage(),
    ),
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
            const _LookbookHeroSection(),
            _LookbookEditorialSection(entries: entries),
            const _LookbookStyleNotesSection(),
          ],
        ),
      ),
    );
  }
}

class _LookbookHeroSection extends StatelessWidget {
  const _LookbookHeroSection();

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
                  Color(0xFF1F1F1F),
                  Color(0xFF0D0D0D),
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
                ? const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LookbookBadge(),
                      SizedBox(height: 18),
                      _LookbookHeroText(),
                      SizedBox(height: 22),
                      _LookbookHeroSideCard(),
                    ],
                  )
                : const Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _LookbookBadge(),
                            SizedBox(height: 18),
                            _LookbookHeroText(),
                          ],
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: _LookbookHeroSideCard(),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _LookbookBadge extends StatelessWidget {
  const _LookbookBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Text(
        'DTHC Lookbook',
        style: TextStyle(
          color: AppColors.primaryBlack,
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _LookbookHeroText extends StatelessWidget {
  const _LookbookHeroText();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Streetwear presented like a premium fashion editorial.',
          style: TextStyle(
            color: AppColors.white,
            fontSize: isMobile ? 28 : 34,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'The lookbook makes DTHC feel more complete by showing shoppers styled fashion direction, not only product listings.',
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

class _LookbookHeroSideCard extends StatelessWidget {
  const _LookbookHeroSideCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LookbookMetricRow(
            title: 'Editorial Feel',
            subtitle: 'Makes the brand feel more polished and premium.',
          ),
          SizedBox(height: 14),
          _LookbookMetricRow(
            title: 'Fit Inspiration',
            subtitle: 'Customers can picture how items work together.',
          ),
          SizedBox(height: 14),
          _LookbookMetricRow(
            title: 'Brand Identity',
            subtitle: 'Stronger styling language builds a memorable store.',
          ),
        ],
      ),
    );
  }
}

class _LookbookMetricRow extends StatelessWidget {
  final String title;
  final String subtitle;

  const _LookbookMetricRow({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.photo_camera_back_outlined,
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

class _LookbookEditorialSection extends StatelessWidget {
  final List<Map<String, dynamic>> entries;

  const _LookbookEditorialSection({
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final featured = entries.isNotEmpty ? entries.first : null;
    final others = entries.length > 1 ? entries.sublist(1) : <Map<String, dynamic>>[];

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
                'Editorial Fits',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Use this section to display mood, styling direction, and visual identity across the DTHC brand.',
                style: TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              if (featured != null) ...[
                _FeaturedLookbookCard(entry: featured),
                const SizedBox(height: 20),
              ],
              GridView.builder(
                itemCount: others.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: width > 1100
                      ? 3
                      : width > 700
                          ? 2
                          : 1,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: width > 1100
                      ? 0.70
                      : width > 700
                          ? 0.78
                          : 0.92,
                ),
                itemBuilder: (context, index) {
                  return _LookbookGalleryCard(entry: others[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedLookbookCard extends StatelessWidget {
  final Map<String, dynamic> entry;

  const _FeaturedLookbookCard({
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = '${entry['imageUrl'] ?? ''}';
    final title = '${entry['title'] ?? ''}';
    final subtitle = '${entry['subtitle'] ?? ''}';
    final tag = '${entry['tag'] ?? ''}';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.charcoal),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 850;

          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LookbookImage(
                  imageUrl: imageUrl,
                  height: 260,
                  topRadius: 30,
                  bottomRadius: 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: _FeaturedLookbookText(
                    tag: tag,
                    title: title,
                    subtitle: subtitle,
                  ),
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                flex: 3,
                child: _LookbookImage(
                  imageUrl: imageUrl,
                  height: 380,
                  topRadius: 30,
                  bottomRadius: 30,
                  leftOnly: true,
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _FeaturedLookbookText(
                    tag: tag,
                    title: title,
                    subtitle: subtitle,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FeaturedLookbookText extends StatelessWidget {
  final String tag;
  final String title;
  final String subtitle;

  const _FeaturedLookbookText({
    required this.tag,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 850;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            tag,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.primaryBlack,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          maxLines: isMobile ? 2 : 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.white,
            fontSize: isMobile ? 24 : 28,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          maxLines: isMobile ? 3 : 4,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 15,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: isMobile ? double.infinity : null,
          child: OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Shop filtering from lookbook can be connected next.'),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.gold,
              side: const BorderSide(color: AppColors.gold),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Shop This Mood',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

class _LookbookGalleryCard extends StatelessWidget {
  final Map<String, dynamic> entry;

  const _LookbookGalleryCard({
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    final imageUrl = '${entry['imageUrl'] ?? ''}';
    final title = '${entry['title'] ?? ''}';
    final subtitle = '${entry['subtitle'] ?? ''}';
    final tag = '${entry['tag'] ?? ''}';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LookbookImage(
            imageUrl: imageUrl,
            height: isMobile ? 200 : 230,
            topRadius: 28,
            bottomRadius: 0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 14 : 18,
              isMobile ? 14 : 18,
              isMobile ? 14 : 18,
              isMobile ? 14 : 18,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 160),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.charcoal,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    tag,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  maxLines: isMobile ? 3 : 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFBDBDBD),
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

class _LookbookImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double topRadius;
  final double bottomRadius;
  final bool leftOnly;

  const _LookbookImage({
    required this.imageUrl,
    required this.height,
    required this.topRadius,
    required this.bottomRadius,
    this.leftOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;

    if (leftOnly) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(topRadius),
        bottomLeft: Radius.circular(bottomRadius),
      );
    } else {
      borderRadius = BorderRadius.vertical(
        top: Radius.circular(topRadius),
        bottom: Radius.circular(bottomRadius),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        height: height,
        width: double.infinity,
        color: AppColors.charcoal,
        child: imageUrl.trim().isEmpty
            ? const Center(
                child: Icon(
                  Icons.photo_library_outlined,
                  size: 58,
                  color: AppColors.white,
                ),
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.photo_library_outlined,
                      size: 58,
                      color: AppColors.white,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _LookbookStyleNotesSection extends StatelessWidget {
  const _LookbookStyleNotesSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width < 768 ? 16 : 32,
        vertical: 30,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Style Direction',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'This section helps explain the brand vibe behind the pieces and makes the fashion experience feel more premium.',
                style: TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                children: const [
                  _StyleNoteCard(
                    icon: Icons.nightlight_round,
                    title: 'Dark Luxury',
                    subtitle:
                        'Black-led styling, gold detail accents, and strong visual contrast.',
                  ),
                  _StyleNoteCard(
                    icon: Icons.checkroom_outlined,
                    title: 'Street Layers',
                    subtitle:
                        'Tees, caps, sneakers, and accessories styled for bold everyday fits.',
                  ),
                  _StyleNoteCard(
                    icon: Icons.auto_awesome_outlined,
                    title: 'Premium Energy',
                    subtitle:
                        'Simple items are presented with stronger fashion confidence.',
                  ),
                ],
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _StyleNoteCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _StyleNoteCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width < 768 ? 32.0 : 64.0;
    final availableWidth = width - horizontalPadding;
    final cardWidth = availableWidth < 400 ? availableWidth : 400.0;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              icon,
              color: AppColors.primaryBlack,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
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