import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'lookbook_page.dart';
import 'payment_delivery_page.dart';
import '../core/app_colors.dart';
import '../data/store_controller.dart';
import '../models/store_settings.dart';
import '../widgets/custom_navbar.dart';
import 'admin/admin_dashboard_page.dart';
import 'cart_page.dart';
import 'collections_page.dart';
import 'home_page.dart';
import 'menu_page.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message submitted successfully. Connect backend later.'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    nameController.clear();
    emailController.clear();
    phoneController.clear();
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StoreController>();
    final storeSettings = controller.getStoreSettings();
    final contactChannels = controller.getContactChannels();

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomNavbar(
              activeItem: 'Contact',
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
              onContactTap: () {},
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
            _ContactHeroSection(storeSettings: storeSettings),
            _QuickActionSection(storeSettings: storeSettings),
            _ContactChannelsSection(
              channels: contactChannels,
              storeSettings: storeSettings,
            ),
            _ContactFormSection(
              formKey: _formKey,
              nameController: nameController,
              emailController: emailController,
              phoneController: phoneController,
              messageController: messageController,
              onSubmit: _submitForm,
            ),
            const _BrandSupportSection(),
          ],
        ),
      ),
    );
  }
}

class _ContactHeroSection extends StatelessWidget {
  final StoreSettings storeSettings;

  const _ContactHeroSection({
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
                  Color(0xFF1C1C1C),
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
                      const _ContactBadge(),
                      const SizedBox(height: 18),
                      _HeroText(storeSettings: storeSettings),
                      const SizedBox(height: 22),
                      _HeroSupportCard(storeSettings: storeSettings),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _ContactBadge(),
                            const SizedBox(height: 18),
                            _HeroText(storeSettings: storeSettings),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: _HeroSupportCard(storeSettings: storeSettings),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _ContactBadge extends StatelessWidget {
  const _ContactBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Text(
        'Contact DTHC',
        style: TextStyle(
          color: AppColors.primaryBlack,
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final StoreSettings storeSettings;

  const _HeroText({
    required this.storeSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Let customers reach your brand quickly and confidently.',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 34,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Use this page for order support, collaborations, delivery questions, and general fashion brand inquiries for ${storeSettings.storeName}.',
          style: const TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 15,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _HeroSupportCard extends StatelessWidget {
  final StoreSettings storeSettings;

  const _HeroSupportCard({
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
          _SupportInfoRow(
            icon: Icons.phone_outlined,
            title: 'Phone',
            subtitle: storeSettings.phoneNumber,
          ),
          const SizedBox(height: 14),
          _SupportInfoRow(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: storeSettings.email,
          ),
          const SizedBox(height: 14),
          _SupportInfoRow(
            icon: Icons.location_on_outlined,
            title: 'Location',
            subtitle: storeSettings.address,
          ),
        ],
      ),
    );
  }
}

class _SupportInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SupportInfoRow({
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

class _QuickActionSection extends StatelessWidget {
  final StoreSettings storeSettings;

  const _QuickActionSection({
    required this.storeSettings,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final whatsappNumber = _ContactActionHelper.extractWhatsAppNumber(
      storeSettings.phoneNumber,
    );
    final instagramHandle = _ContactActionHelper.extractInstagramHandle(
     _ContactActionHelper.findInstagramFromChannels(
       context.read<StoreController>().getContactChannels(),
  ),
);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width < 768 ? 16 : 32,
        vertical: 10,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.softBlack,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.charcoal),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: width < 900
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _QuickActionIntro(),
                      const SizedBox(height: 18),
                      _QuickActionButtons(
                        whatsappNumber: whatsappNumber,
                        instagramHandle: instagramHandle,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const Expanded(
                        child: _QuickActionIntro(),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _QuickActionButtons(
                          whatsappNumber: whatsappNumber,
                          instagramHandle: instagramHandle,
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

class _QuickActionIntro extends StatelessWidget {
  const _QuickActionIntro();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Give shoppers fast direct-action buttons for WhatsApp support and Instagram brand engagement so the page feels more realistic and conversion-friendly.',
          style: TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _QuickActionButtons extends StatelessWidget {
  final String whatsappNumber;
  final String instagramHandle;

  const _QuickActionButtons({
    required this.whatsappNumber,
    required this.instagramHandle,
  });

  @override
  Widget build(BuildContext context) {
    final hasWhatsApp = whatsappNumber.isNotEmpty;
    final hasInstagram = instagramHandle.isNotEmpty;

    return Column(
      children: [
        _ActionButtonCard(
          icon: Icons.chat_bubble_outline,
          title: 'Chat on WhatsApp',
          subtitle: hasWhatsApp
              ? whatsappNumber
              : 'Add a valid phone number in store settings',
          buttonText: 'Open WhatsApp',
          isPrimary: true,
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  hasWhatsApp
                      ? 'Connect url_launcher next to open WhatsApp: https://wa.me/$whatsappNumber'
                      : 'No valid WhatsApp number found in store settings.',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        const SizedBox(height: 14),
        _ActionButtonCard(
          icon: Icons.camera_alt_outlined,
          title: 'Visit Instagram',
          subtitle: hasInstagram
              ? '@$instagramHandle'
              : 'Add Instagram handle in store settings',
          buttonText: 'Open Instagram',
          isPrimary: false,
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  hasInstagram
                      ? 'Connect url_launcher next to open Instagram: https://instagram.com/$instagramHandle'
                      : 'No Instagram handle found in store settings.',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ActionButtonCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButtonCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isPrimary ? AppColors.gold : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: isPrimary ? AppColors.gold : AppColors.softBlack,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: isPrimary ? AppColors.primaryBlack : AppColors.gold,
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
                        fontSize: 17,
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
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: isPrimary
                ? ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.primaryBlack,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  )
                : OutlinedButton(
                    onPressed: onTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.gold,
                      side: const BorderSide(color: AppColors.gold),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ContactChannelsSection extends StatelessWidget {
  final List<Map<String, dynamic>> channels;
  final StoreSettings storeSettings;

  const _ContactChannelsSection({
    required this.channels,
    required this.storeSettings,
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
                'Contact Channels',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Give customers multiple ways to reach the DTHC brand for support, order updates, and collaborations.',
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
                children: channels
                    .map(
                      (channel) => _ContactChannelCard(
                        channel: channel,
                        storeSettings: storeSettings,
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

class _ContactChannelCard extends StatelessWidget {
  final Map<String, dynamic> channel;
  final StoreSettings storeSettings;

  const _ContactChannelCard({
    required this.channel,
    required this.storeSettings,
  });

  @override
  Widget build(BuildContext context) {
    final title = '${channel['title'] ?? ''}';
    final value = '${channel['value'] ?? ''}';
    final subtitle = '${channel['subtitle'] ?? ''}';
    final iconKey = '${channel['icon'] ?? ''}';

    return Container(
      width: 290,
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
            value,
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 15,
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: _buildActionButton(context, title, iconKey),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String title, String iconKey) {
    final whatsappNumber = _ContactActionHelper.extractWhatsAppNumber(
      storeSettings.phoneNumber,
    );
    final instagramHandle = _ContactActionHelper.extractInstagramHandle(
      _ContactActionHelper.findInstagramFromChannels(
        context.read<StoreController>().getContactChannels(),
)
    );

    final lowerTitle = title.toLowerCase();
    final lowerIcon = iconKey.toLowerCase();

    if (lowerTitle.contains('whatsapp') || lowerIcon.contains('whatsapp')) {
      return ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                whatsappNumber.isNotEmpty
                    ? 'Connect url_launcher next to open WhatsApp: https://wa.me/$whatsappNumber'
                    : 'No valid WhatsApp number found in store settings.',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.primaryBlack,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Open WhatsApp',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      );
    }

    if (lowerTitle.contains('instagram') || lowerIcon.contains('instagram')) {
      return OutlinedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                instagramHandle.isNotEmpty
                    ? 'Connect url_launcher next to open Instagram: https://instagram.com/$instagramHandle'
                    : 'No Instagram handle found in store settings.',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gold,
          side: const BorderSide(color: AppColors.gold),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Open Instagram',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      );
    }

    return OutlinedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title channel is ready for live action hookup next.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.white,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: const Text(
        'Use Channel',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }

  IconData _mapIcon(String iconKey) {
    switch (iconKey) {
      case 'phone':
        return Icons.phone_outlined;
      case 'email':
        return Icons.email_outlined;
      case 'instagram':
        return Icons.camera_alt_outlined;
      case 'tiktok':
        return Icons.music_note_outlined;
      case 'whatsapp':
        return Icons.chat_bubble_outline;
      default:
        return Icons.contact_mail_outlined;
    }
  }
}

class _ContactFormSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController messageController;
  final VoidCallback onSubmit;

  const _ContactFormSection({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.messageController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

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
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ContactFormIntro(),
                    const SizedBox(height: 22),
                    _ContactFormCard(
                      formKey: formKey,
                      nameController: nameController,
                      emailController: emailController,
                      phoneController: phoneController,
                      messageController: messageController,
                      onSubmit: onSubmit,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: _ContactFormIntro(),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 2,
                      child: _ContactFormCard(
                        formKey: formKey,
                        nameController: nameController,
                        emailController: emailController,
                        phoneController: phoneController,
                        messageController: messageController,
                        onSubmit: onSubmit,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ContactFormIntro extends StatelessWidget {
  const _ContactFormIntro();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Send a message',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'This form makes the site feel like a complete e-commerce brand website. Later, you can connect it to Firebase, email, or WhatsApp handling.',
          style: TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _ContactFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController messageController;
  final VoidCallback onSubmit;

  const _ContactFormCard({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.messageController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _ContactTextField(
              controller: nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _ContactTextField(
              controller: emailController,
              label: 'Email Address',
              hint: 'Enter your email address',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _ContactTextField(
              controller: phoneController,
              label: 'Phone Number',
              hint: 'Enter your phone number',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _ContactTextField(
              controller: messageController,
              label: 'Message',
              hint: 'Tell DTHC what you need help with',
              maxLines: 6,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your message';
                }
                if (value.trim().length < 10) {
                  return 'Message is too short';
                }
                return null;
              },
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.primaryBlack,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Send Message',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
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

class _ContactTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _ContactTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.greyText),
            filled: true,
            fillColor: AppColors.softBlack,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.gold),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }
}

class _BrandSupportSection extends StatelessWidget {
  const _BrandSupportSection();

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
                'A proper contact page makes the website feel trustworthy, complete, and ready for real customers and brand collaborations.',
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
                  _SupportCard(
                    icon: Icons.support_agent_outlined,
                    title: 'Customer Support',
                    subtitle:
                        'Customers can ask about orders, sizing, and delivery.',
                  ),
                  _SupportCard(
                    icon: Icons.campaign_outlined,
                    title: 'Brand Inquiries',
                    subtitle:
                        'Useful for collaborations, wholesale, and promo requests.',
                  ),
                  _SupportCard(
                    icon: Icons.verified_outlined,
                    title: 'More Trust',
                    subtitle:
                        'A visible contact channel helps the store feel more legitimate.',
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

class _SupportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SupportCard({
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
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.charcoal),
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

class _ContactActionHelper {
  static String extractWhatsAppNumber(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) return '';

    if (digits.startsWith('233')) {
      return digits;
    }

    if (digits.startsWith('0') && digits.length >= 10) {
      return '233${digits.substring(1)}';
    }

    return digits;
  }
  
  static String findInstagramFromChannels(List<Map<String, dynamic>> channels) {
  for (final channel in channels) {
    final title = '${channel['title'] ?? ''}'.toLowerCase();
    final icon = '${channel['icon'] ?? ''}'.toLowerCase();

    if (title.contains('instagram') || icon.contains('instagram')) {
      return '${channel['value'] ?? ''}';
    }
  }
  return '';
}
  static String extractInstagramHandle(String raw) {
    var value = raw.trim();

    if (value.isEmpty) return '';

    value = value.replaceAll('@', '');
    value = value.replaceAll('https://instagram.com/', '');
    value = value.replaceAll('https://www.instagram.com/', '');
    value = value.replaceAll('http://instagram.com/', '');
    value = value.replaceAll('http://www.instagram.com/', '');
    value = value.replaceAll('/', '');

    return value.trim();
  }
}