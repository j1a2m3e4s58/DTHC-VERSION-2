import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../data/store_controller.dart';
import '../../data/theme_controller.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _storeNameController;
  late final TextEditingController _taglineController;
  late final TextEditingController _announcementController;
  late final TextEditingController _heroTitleController;
  late final TextEditingController _heroSubtitleController;
  late final TextEditingController _homeSearchTitleController;
  late final TextEditingController _homeSearchSubtitleController;
  late final TextEditingController _marketplaceLabelController;
  late final TextEditingController _marketplaceTitleController;
  late final TextEditingController _marketplaceSubtitleController;
  late final TextEditingController _marketplacePrimaryCtaController;
  late final TextEditingController _marketplaceSecondaryCtaController;
  late final TextEditingController _promoSneakersTitleController;
  late final TextEditingController _promoSneakersSubtitleController;
  late final TextEditingController _promoSneakersCtaController;
  late final TextEditingController _promoTeesTitleController;
  late final TextEditingController _promoTeesSubtitleController;
  late final TextEditingController _promoTeesCtaController;
  late final TextEditingController _promoBestSellersTitleController;
  late final TextEditingController _promoBestSellersSubtitleController;
  late final TextEditingController _promoBestSellersCtaController;
  late final TextEditingController _dealsStripLabelController;
  late final TextEditingController _dealsStripTitleController;
  late final TextEditingController _dealsStripSubtitleController;
  late final TextEditingController _dealsPrimaryCtaController;
  late final TextEditingController _dealsSecondaryCtaController;
  late final TextEditingController _dealsCountdownEndsAtController;
  late final TextEditingController _shopHeaderBadgeController;
  late final TextEditingController _shopSearchTitleController;
  late final TextEditingController _shopSearchSubtitleController;

  String _themeMode = 'light';

  @override
  void initState() {
    super.initState();
    final settings = StoreController().getStoreSettings();
    _storeNameController = TextEditingController(text: settings.storeName);
    _taglineController = TextEditingController(text: settings.tagline);
    _announcementController =
        TextEditingController(text: settings.announcementText);
    _heroTitleController = TextEditingController(text: settings.heroTitle);
    _heroSubtitleController =
        TextEditingController(text: settings.heroSubtitle);
    _homeSearchTitleController =
        TextEditingController(text: settings.homeSearchTitle);
    _homeSearchSubtitleController =
        TextEditingController(text: settings.homeSearchSubtitle);
    _marketplaceLabelController =
        TextEditingController(text: settings.marketplaceBannerLabel);
    _marketplaceTitleController =
        TextEditingController(text: settings.marketplaceBannerTitle);
    _marketplaceSubtitleController =
        TextEditingController(text: settings.marketplaceBannerSubtitle);
    _marketplacePrimaryCtaController =
        TextEditingController(text: settings.marketplacePrimaryCta);
    _marketplaceSecondaryCtaController =
        TextEditingController(text: settings.marketplaceSecondaryCta);
    _promoSneakersTitleController =
        TextEditingController(text: settings.promoSneakersTitle);
    _promoSneakersSubtitleController =
        TextEditingController(text: settings.promoSneakersSubtitle);
    _promoSneakersCtaController =
        TextEditingController(text: settings.promoSneakersCta);
    _promoTeesTitleController =
        TextEditingController(text: settings.promoTeesTitle);
    _promoTeesSubtitleController =
        TextEditingController(text: settings.promoTeesSubtitle);
    _promoTeesCtaController =
        TextEditingController(text: settings.promoTeesCta);
    _promoBestSellersTitleController =
        TextEditingController(text: settings.promoBestSellersTitle);
    _promoBestSellersSubtitleController =
        TextEditingController(text: settings.promoBestSellersSubtitle);
    _promoBestSellersCtaController =
        TextEditingController(text: settings.promoBestSellersCta);
    _dealsStripLabelController =
        TextEditingController(text: settings.dealsStripLabel);
    _dealsStripTitleController =
        TextEditingController(text: settings.dealsStripTitle);
    _dealsStripSubtitleController =
        TextEditingController(text: settings.dealsStripSubtitle);
    _dealsPrimaryCtaController =
        TextEditingController(text: settings.dealsPrimaryCta);
    _dealsSecondaryCtaController =
        TextEditingController(text: settings.dealsSecondaryCta);
    _dealsCountdownEndsAtController =
        TextEditingController(text: settings.dealsCountdownEndsAt);
    _shopHeaderBadgeController =
        TextEditingController(text: settings.shopHeaderBadge);
    _shopSearchTitleController =
        TextEditingController(text: settings.shopSearchTitle);
    _shopSearchSubtitleController =
        TextEditingController(text: settings.shopSearchSubtitle);
    _themeMode = settings.themeMode;
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _taglineController.dispose();
    _announcementController.dispose();
    _heroTitleController.dispose();
    _heroSubtitleController.dispose();
    _homeSearchTitleController.dispose();
    _homeSearchSubtitleController.dispose();
    _marketplaceLabelController.dispose();
    _marketplaceTitleController.dispose();
    _marketplaceSubtitleController.dispose();
    _marketplacePrimaryCtaController.dispose();
    _marketplaceSecondaryCtaController.dispose();
    _promoSneakersTitleController.dispose();
    _promoSneakersSubtitleController.dispose();
    _promoSneakersCtaController.dispose();
    _promoTeesTitleController.dispose();
    _promoTeesSubtitleController.dispose();
    _promoTeesCtaController.dispose();
    _promoBestSellersTitleController.dispose();
    _promoBestSellersSubtitleController.dispose();
    _promoBestSellersCtaController.dispose();
    _dealsStripLabelController.dispose();
    _dealsStripTitleController.dispose();
    _dealsStripSubtitleController.dispose();
    _dealsPrimaryCtaController.dispose();
    _dealsSecondaryCtaController.dispose();
    _dealsCountdownEndsAtController.dispose();
    _shopHeaderBadgeController.dispose();
    _shopSearchTitleController.dispose();
    _shopSearchSubtitleController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (!_formKey.currentState!.validate()) return;

    final controller = context.read<StoreController>();
    final current = controller.getStoreSettings();
    final updated = current.copyWith(
      storeName: _storeNameController.text.trim(),
      tagline: _taglineController.text.trim(),
      announcementText: _announcementController.text.trim(),
      heroTitle: _heroTitleController.text.trim(),
      heroSubtitle: _heroSubtitleController.text.trim(),
      homeSearchTitle: _homeSearchTitleController.text.trim(),
      homeSearchSubtitle: _homeSearchSubtitleController.text.trim(),
      marketplaceBannerLabel: _marketplaceLabelController.text.trim(),
      marketplaceBannerTitle: _marketplaceTitleController.text.trim(),
      marketplaceBannerSubtitle: _marketplaceSubtitleController.text.trim(),
      marketplacePrimaryCta: _marketplacePrimaryCtaController.text.trim(),
      marketplaceSecondaryCta:
          _marketplaceSecondaryCtaController.text.trim(),
      promoSneakersTitle: _promoSneakersTitleController.text.trim(),
      promoSneakersSubtitle: _promoSneakersSubtitleController.text.trim(),
      promoSneakersCta: _promoSneakersCtaController.text.trim(),
      promoTeesTitle: _promoTeesTitleController.text.trim(),
      promoTeesSubtitle: _promoTeesSubtitleController.text.trim(),
      promoTeesCta: _promoTeesCtaController.text.trim(),
      promoBestSellersTitle: _promoBestSellersTitleController.text.trim(),
      promoBestSellersSubtitle:
          _promoBestSellersSubtitleController.text.trim(),
      promoBestSellersCta: _promoBestSellersCtaController.text.trim(),
      dealsStripLabel: _dealsStripLabelController.text.trim(),
      dealsStripTitle: _dealsStripTitleController.text.trim(),
      dealsStripSubtitle: _dealsStripSubtitleController.text.trim(),
      dealsPrimaryCta: _dealsPrimaryCtaController.text.trim(),
      dealsSecondaryCta: _dealsSecondaryCtaController.text.trim(),
      dealsCountdownEndsAt: _dealsCountdownEndsAtController.text.trim(),
      shopHeaderBadge: _shopHeaderBadgeController.text.trim(),
      shopSearchTitle: _shopSearchTitleController.text.trim(),
      shopSearchSubtitle: _shopSearchSubtitleController.text.trim(),
      themeMode: _themeMode,
    );

    controller.updateStoreSettings(updated);
    context.read<ThemeController>().setThemeMode(_themeMode);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Store settings updated successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.background,
        foregroundColor: palette.textPrimary,
        title: const Text('Store Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SettingsSectionTitle(
                    title: 'Brand Basics',
                    subtitle:
                        'These settings control the main brand identity shoppers see first.',
                  ),
                  const SizedBox(height: 16),
                  _buildField(_storeNameController, 'Store Name'),
                  const SizedBox(height: 12),
                  _buildField(_taglineController, 'Tagline'),
                  const SizedBox(height: 12),
                  _buildField(
                    _announcementController,
                    'Announcement Text',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 28),
                  const _SettingsSectionTitle(
                    title: 'Theme Mode',
                    subtitle:
                        'Choose the storefront mood. Dark mode uses a sharper blue-black finish.',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: palette.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: palette.border),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _themeMode,
                      dropdownColor: palette.surface,
                      decoration: const InputDecoration(border: InputBorder.none),
                      style: TextStyle(color: palette.textPrimary),
                      items: const [
                        DropdownMenuItem(value: 'light', child: Text('Light')),
                        DropdownMenuItem(value: 'dark', child: Text('Dark')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _themeMode = value ?? 'light';
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _SettingsSectionTitle(
                    title: 'Hero Copy',
                    subtitle:
                        'Update the main homepage hero text when campaigns or collections change.',
                  ),
                  const SizedBox(height: 16),
                  _buildField(_heroTitleController, 'Hero Title'),
                  const SizedBox(height: 12),
                  _buildField(
                    _heroSubtitleController,
                    'Hero Subtitle',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 28),
                  const _SettingsSectionTitle(
                    title: 'Homepage Search Area',
                    subtitle:
                        'Edit the search panel text shown near the top of the homepage.',
                  ),
                  const SizedBox(height: 16),
                  _buildField(_homeSearchTitleController, 'Search Section Title'),
                  const SizedBox(height: 12),
                  _buildField(
                    _homeSearchSubtitleController,
                    'Search Section Subtitle',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 28),
                  const _SettingsSectionTitle(
                    title: 'Marketplace Promo Banner',
                    subtitle:
                        'These control the big homepage deals banner and its action buttons.',
                  ),
                  const SizedBox(height: 16),
                  _buildField(_marketplaceLabelController, 'Banner Label'),
                  const SizedBox(height: 12),
                  _buildField(_marketplaceTitleController, 'Banner Title'),
                  const SizedBox(height: 12),
                  _buildField(
                    _marketplaceSubtitleController,
                    'Banner Subtitle',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  _buildField(
                    _marketplacePrimaryCtaController,
                    'Primary CTA Text',
                  ),
                  const SizedBox(height: 12),
                  _buildField(
                    _marketplaceSecondaryCtaController,
                    'Secondary CTA Text',
                  ),
                  const SizedBox(height: 28),
                  const _SettingsSectionTitle(
                    title: 'Promo Shortcut Cards',
                    subtitle:
                        'These control the three quick-entry cards under the main marketplace banner.',
                  ),
                  const SizedBox(height: 16),
                  _buildField(_promoSneakersTitleController, 'Sneakers Card Title'),
                  const SizedBox(height: 12),
                  _buildField(
                    _promoSneakersSubtitleController,
                    'Sneakers Card Subtitle',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  _buildField(_promoSneakersCtaController, 'Sneakers Card CTA'),
                  const SizedBox(height: 12),
                  _buildField(_promoTeesTitleController, 'Tees Card Title'),
                  const SizedBox(height: 12),
                  _buildField(
                    _promoTeesSubtitleController,
                    'Tees Card Subtitle',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  _buildField(_promoTeesCtaController, 'Tees Card CTA'),
                  const SizedBox(height: 12),
                  _buildField(
                    _promoBestSellersTitleController,
                    'Best Sellers Card Title',
                  ),
                  const SizedBox(height: 12),
                  _buildField(
                    _promoBestSellersSubtitleController,
                    'Best Sellers Card Subtitle',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  _buildField(
                    _promoBestSellersCtaController,
                    'Best Sellers Card CTA',
                  ),
                  const SizedBox(height: 28),
                  const _SettingsSectionTitle(
                    title: 'Deals Strip',
                    subtitle:
                        'Control the campaign strip that pushes visitors into deals and fresh drops.',
                  ),
                  const SizedBox(height: 16),
                  _buildField(_dealsStripLabelController, 'Deals Strip Label'),
                  const SizedBox(height: 12),
                  _buildField(_dealsStripTitleController, 'Deals Strip Title'),
                  const SizedBox(height: 12),
                  _buildField(
                    _dealsStripSubtitleController,
                    'Deals Strip Subtitle',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  _buildField(_dealsPrimaryCtaController, 'Deals Primary CTA'),
                  const SizedBox(height: 12),
                  _buildField(
                    _dealsSecondaryCtaController,
                    'Deals Secondary CTA',
                  ),
                  const SizedBox(height: 12),
                  _buildField(
                    _dealsCountdownEndsAtController,
                    'Countdown Ends At (YYYY-MM-DDTHH:MM:SS)',
                  ),
                  const SizedBox(height: 28),
                  const _SettingsSectionTitle(
                    title: 'Shop Page Controls',
                    subtitle:
                        'Update the shop page badge and search panel copy without editing code.',
                  ),
                  const SizedBox(height: 16),
                  _buildField(_shopHeaderBadgeController, 'Shop Header Badge'),
                  const SizedBox(height: 12),
                  _buildField(_shopSearchTitleController, 'Shop Search Title'),
                  const SizedBox(height: 12),
                  _buildField(
                    _shopSearchSubtitleController,
                    'Shop Search Subtitle',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: AppColors.primaryBlack,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Save Store Settings',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: palette.textPrimary),
      validator: (value) {
        if ((value ?? '').trim().isEmpty) {
          return 'Required';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: palette.textSecondary),
        filled: true,
        fillColor: palette.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.gold),
        ),
      ),
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SettingsSectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: palette.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            color: palette.textSecondary,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
