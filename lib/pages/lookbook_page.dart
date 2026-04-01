import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../data/store_controller.dart';
import '../data/theme_controller.dart';
import '../widgets/custom_navbar.dart';
import 'admin/admin_dashboard_page.dart';
import 'cart_page.dart';
import 'collections_page.dart';
import 'contact_page.dart';
import 'home_page.dart';
import 'menu_page.dart';
import 'payment_delivery_page.dart';
import 'track_order_page.dart';

class LookbookPage extends StatelessWidget {
  const LookbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StoreController>();
    final entries = controller.getLookbookEntries();
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Scaffold(
      backgroundColor: palette.background,
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
              onLookbookTap: () {},
              onDeliveryTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentDeliveryPage(),
                  ),
                );
              },
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
            _LookbookHeroSection(entries: entries, palette: palette),
            _LookbookEditorialSection(entries: entries, palette: palette),
            _LookbookStyleDirectionSection(palette: palette),
          ],
        ),
      ),
    );
  }
}

class _LookbookHeroSection extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final AppPalette palette;

  const _LookbookHeroSection({
    required this.entries,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final activePalette =
        palette ?? AppColors.palette(context.watch<ThemeController>().isDarkMode);
    final bool isMobile = width < 760;
    final featured = entries.isNotEmpty ? entries.first : null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 20 : 32,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1380),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: palette.border),
              gradient: palette.heroGradient,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool stack = constraints.maxWidth < 980;

                if (stack) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (featured != null)
                        _HeroEditorialImage(
                          imageUrl: '${featured['imageUrl'] ?? ''}',
                          height: isMobile ? 260 : 340,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                          palette: palette,
                        ),
                      Padding(
                        padding: EdgeInsets.all(isMobile ? 20 : 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _HeroBadge(),
                            const SizedBox(height: 18),
                            _HeroTitleBlock(palette: palette),
                            const SizedBox(height: 24),
                            _HeroMetaPanel(entries: entries, palette: palette),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _HeroBadge(),
                            const SizedBox(height: 18),
                            _HeroTitleBlock(palette: palette),
                            const SizedBox(height: 30),
                            _HeroMetaPanel(entries: entries, palette: palette),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: featured == null
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(
                                top: 18,
                                right: 18,
                                bottom: 18,
                              ),
                              child: _HeroEditorialImage(
                                imageUrl: '${featured['imageUrl'] ?? ''}',
                                height: 520,
                                borderRadius: BorderRadius.circular(28),
                                palette: palette,
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'DTHC LOOKBOOK',
        style: TextStyle(
          color: AppColors.primaryBlack,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _HeroTitleBlock extends StatelessWidget {
  final AppPalette palette;

  const _HeroTitleBlock({
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 760;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Editorial streetwear moods for a stronger DTHC brand experience.',
          style: TextStyle(
            color: palette.textOnStrong,
            fontSize: isMobile ? 30 : 46,
            fontWeight: FontWeight.w900,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 720),
          child: Text(
            'The Lookbook turns product browsing into styled fashion storytelling. Instead of only showing items, DTHC now presents mood, attitude, layering, and visual direction like a premium streetwear label.',
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 15,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroMetaPanel extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final AppPalette palette;

  const _HeroMetaPanel({
    required this.entries,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final moodCount = entries.length;

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _HeroMetricCard(
          title: '$moodCount Styled Moods',
          subtitle: 'Editorial looks that make the store feel more premium.',
          icon: Icons.auto_awesome_outlined,
          palette: palette,
        ),
        _HeroMetricCard(
          title: 'Filtered Shop Flow',
          subtitle: 'Each mood can lead shoppers into a focused buying path.',
          icon: Icons.shopping_bag_outlined,
          palette: palette,
        ),
        _HeroMetricCard(
          title: 'Brand Identity',
          subtitle: 'Black, gold, contrast, and styling language stay consistent.',
          icon: Icons.bolt_outlined,
          palette: palette,
        ),
      ],
    );
  }
}

class _HeroMetricCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final AppPalette palette;

  const _HeroMetricCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryBlack,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 13.5,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroEditorialImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final BorderRadius borderRadius;
  final AppPalette palette;

  const _HeroEditorialImage({
    required this.imageUrl,
    required this.height,
    required this.borderRadius,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        height: height,
        width: double.infinity,
        color: palette.surfaceAlt,
        child: imageUrl.trim().isEmpty
            ? const Center(
                child: Icon(
                  Icons.photo_library_outlined,
                  size: 58,
                  color: AppColors.white,
                ),
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
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
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          Color(0x6B000000),
                          Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _LookbookEditorialSection extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final AppPalette? palette;

  const _LookbookEditorialSection({
    required this.entries,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final activePalette =
        palette ?? AppColors.palette(context.watch<ThemeController>().isDarkMode);
    final featured = entries.isNotEmpty ? entries.first : null;
    final secondaryEntries =
        entries.length > 1 ? entries.sublist(1) : <Map<String, dynamic>>[];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width < 760 ? 16 : 32,
        vertical: 8,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1380),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Editorial Moods',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 780),
                child: Text(
                  'Each look is styled to feel like a premium streetwear direction, not just a product tile. The layout expands naturally so you can keep adding more moods later without creating overflow problems.',
                  style: TextStyle(
                    color: activePalette.textSecondary,
                    fontSize: 15,
                    height: 1.65,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (featured != null) ...[
                _FeaturedEditorialCard(entry: featured),
                const SizedBox(height: 22),
              ],
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  double cardWidth;

                  if (maxWidth >= 1260) {
                    cardWidth = (maxWidth - 36) / 3;
                  } else if (maxWidth >= 820) {
                    cardWidth = (maxWidth - 18) / 2;
                  } else {
                    cardWidth = maxWidth;
                  }

                  return Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: secondaryEntries.map((entry) {
                      return SizedBox(
                        width: cardWidth,
                        child: _EditorialGalleryCard(entry: entry),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedEditorialCard extends StatelessWidget {
  final Map<String, dynamic> entry;

  const _FeaturedEditorialCard({
    required this.entry,
  });

  void _openTarget(BuildContext context) {
    final targetType = '${entry['targetType'] ?? ''}'.trim().toLowerCase();
    final targetValue = '${entry['targetValue'] ?? ''}'.trim();

    if (targetValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This mood is not linked yet.'),
        ),
      );
      return;
    }

    if (targetType == 'collection') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MenuPage(collectionFilter: targetValue),
        ),
      );
      return;
    }

    if (targetType == 'category') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MenuPage(categoryFilter: targetValue),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MenuPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);
    final imageUrl = '${entry['imageUrl'] ?? ''}';
    final title = '${entry['title'] ?? ''}';
    final subtitle = '${entry['subtitle'] ?? ''}';
    final tag = '${entry['tag'] ?? ''}';
    final ctaText = '${entry['ctaText'] ?? 'Shop This Mood'}';

    return Container(
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: palette.border),
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
          final bool stack = constraints.maxWidth < 960;

          if (stack) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LookbookImage(
                  imageUrl: imageUrl,
                  height: 280,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: _FeaturedEditorialText(
                    tag: tag,
                    title: title,
                    subtitle: subtitle,
                    ctaText: ctaText,
                    palette: palette,
                    onTap: () => _openTarget(context),
                  ),
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                flex: 6,
                child: _LookbookImage(
                  imageUrl: imageUrl,
                  height: 430,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: _FeaturedEditorialText(
                    tag: tag,
                    title: title,
                    subtitle: subtitle,
                    ctaText: ctaText,
                    palette: palette,
                    onTap: () => _openTarget(context),
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

class _FeaturedEditorialText extends StatelessWidget {
  final String tag;
  final String title;
  final String subtitle;
  final String ctaText;
  final AppPalette? palette;
  final VoidCallback onTap;

  const _FeaturedEditorialText({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.ctaText,
    this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 760;
    final activePalette =
        palette ?? AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tag.trim().isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                color: AppColors.primaryBlack,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            color: activePalette.textPrimary,
            fontSize: isMobile ? 25 : 32,
            fontWeight: FontWeight.w900,
            height: 1.12,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          subtitle,
          style: TextStyle(
            color: activePalette.textSecondary,
            fontSize: 15,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 22),
        _EditorialDetailStrip(palette: activePalette),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.primaryBlack,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                ctaText,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CollectionsPage()),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: activePalette.textPrimary,
                side: BorderSide(color: activePalette.border),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Explore Collections',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EditorialDetailStrip extends StatelessWidget {
  final AppPalette? palette;

  const _EditorialDetailStrip({this.palette});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _EditorialMiniPill(label: 'Premium mood', palette: palette),
        _EditorialMiniPill(label: 'Streetwear styling', palette: palette),
        _EditorialMiniPill(label: 'Filtered shop flow', palette: palette),
      ],
    );
  }
}

class _EditorialMiniPill extends StatelessWidget {
  final String label;
  final AppPalette? palette;

  const _EditorialMiniPill({
    required this.label,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final activePalette =
        palette ?? AppColors.palette(context.watch<ThemeController>().isDarkMode);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: activePalette.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: activePalette.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: activePalette.textPrimary,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EditorialGalleryCard extends StatelessWidget {
  final Map<String, dynamic> entry;

  const _EditorialGalleryCard({
    required this.entry,
  });

  void _openTarget(BuildContext context) {
    final targetType = '${entry['targetType'] ?? ''}'.trim().toLowerCase();
    final targetValue = '${entry['targetValue'] ?? ''}'.trim();

    if (targetValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This mood is not linked yet.'),
        ),
      );
      return;
    }

    if (targetType == 'collection') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MenuPage(collectionFilter: targetValue),
        ),
      );
      return;
    }

    if (targetType == 'category') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MenuPage(categoryFilter: targetValue),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MenuPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);
    final imageUrl = '${entry['imageUrl'] ?? ''}';
    final title = '${entry['title'] ?? ''}';
    final subtitle = '${entry['subtitle'] ?? ''}';
    final tag = '${entry['tag'] ?? ''}';
    final ctaText = '${entry['ctaText'] ?? 'Shop This Mood'}';

    return Container(
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LookbookImage(
            imageUrl: imageUrl,
            height: 260,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tag.trim().isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: palette.surface,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: palette.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 14,
                    height: 1.65,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _openTarget(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.gold,
                      side: const BorderSide(color: AppColors.gold),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      ctaText,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
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
  final BorderRadius borderRadius;

  const _LookbookImage({
    required this.imageUrl,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: double.infinity,
        height: height,
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

class _LookbookStyleDirectionSection extends StatelessWidget {
  final AppPalette? palette;

  const _LookbookStyleDirectionSection({
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final activePalette =
        palette ?? AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width < 760 ? 16 : 32,
        vertical: 30,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1380),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Style Direction',
                style: TextStyle(
                  color: activePalette.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 760),
                child: Text(
                  'This section reinforces the visual language behind the brand: dark luxury, premium street layering, and cleaner fashion presentation across mobile, tablet, and desktop.',
                  style: TextStyle(
                    color: activePalette.textSecondary,
                    fontSize: 15,
                    height: 1.65,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  _StyleDirectionCard(
                    icon: Icons.nightlight_round,
                    title: 'Dark Luxury',
                    subtitle:
                        'Black-led composition, gold accents, strong contrast, and premium mood across the page.',
                    palette: activePalette,
                  ),
                  _StyleDirectionCard(
                    icon: Icons.checkroom_outlined,
                    title: 'Streetwear Layering',
                    subtitle:
                        'Tees, caps, sneakers, chains, belts, and supporting accessories styled as complete fits.',
                    palette: activePalette,
                  ),
                  _StyleDirectionCard(
                    icon: Icons.auto_awesome_outlined,
                    title: 'Editorial Selling',
                    subtitle:
                        'Looks do not just decorate the page — they lead shoppers into filtered buying paths.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StyleDirectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final AppPalette? palette;

  const _StyleDirectionCard({
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            width: 56,
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
