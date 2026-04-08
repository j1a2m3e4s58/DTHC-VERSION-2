import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../data/cart_controller.dart';
import '../data/store_controller.dart';
import '../data/theme_controller.dart';

const String _adminResetMasterPassword = 'DTHC@T4N4AMEG8F5';

class CustomNavbar extends StatelessWidget {
  final String activeItem;
  final VoidCallback? onHomeTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSpecialPacksTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onContactTap;
  final VoidCallback? onLookbookTap;
  final VoidCallback? onDeliveryTap;
  final VoidCallback? onTrackOrderTap;
  final VoidCallback? onOrderNowTap;
  final VoidCallback? onAdminTap;

  const CustomNavbar({
    super.key,
    this.activeItem = 'Home',
    this.onHomeTap,
    this.onMenuTap,
    this.onSpecialPacksTap,
    this.onCartTap,
    this.onContactTap,
    this.onLookbookTap,
    this.onDeliveryTap,
    this.onTrackOrderTap,
    this.onOrderNowTap,
    this.onAdminTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cartCount = context.watch<CartController>().totalItemsCount;
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);
    final storeSettings = context.watch<StoreController>().getStoreSettings();

    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1180;
    final cartTitle = cartCount > 0 ? 'Cart ($cartCount)' : 'Cart';
    final guardedAdminTap = onAdminTap == null
        ? null
        : () => _showAdminAccessDialog(context, onAdminTap!);

    return Container(
      width: double.infinity,
      color: palette.background,
      padding: EdgeInsets.fromLTRB(
        isMobile ? 12 : 22,
        18,
        isMobile ? 12 : 22,
        10,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 18,
              vertical: isMobile ? 10 : 14,
            ),
            decoration: BoxDecoration(
              color: palette.surfaceStrong,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: palette.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x30000000),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: isMobile
                ? Row(
                    children: [
                      Expanded(
                        child: _LogoSection(
                          isMobile: true,
                          storeName: storeSettings.storeName,
                          tagline: storeSettings.tagline,
                          onTap: onHomeTap,
                          onLongPress: guardedAdminTap,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const _ThemeToggleButton(isMobile: true),
                      const SizedBox(width: 8),
                      _MobileMenuButton(
                        cartTitle: cartTitle,
                        activeItem: activeItem,
                        onHomeTap: onHomeTap,
                        onMenuTap: onMenuTap,
                        onSpecialPacksTap: onSpecialPacksTap,
                        onCartTap: onCartTap,
                        onContactTap: onContactTap,
                        onLookbookTap: onLookbookTap,
                        onDeliveryTap: onDeliveryTap,
                        onTrackOrderTap: onTrackOrderTap,
                        onOrderNowTap: onOrderNowTap,
                      ),
                    ],
                  )
                : _DesktopNavbarLayout(
                    isTablet: isTablet,
                    activeItem: activeItem,
                    cartTitle: cartTitle,
                    onHomeTap: onHomeTap,
                    onMenuTap: onMenuTap,
                    onSpecialPacksTap: onSpecialPacksTap,
                    onCartTap: onCartTap,
                    onContactTap: onContactTap,
                    onLookbookTap: onLookbookTap,
                    onDeliveryTap: onDeliveryTap,
                    onTrackOrderTap: onTrackOrderTap,
                    onOrderNowTap: onOrderNowTap,
                    onAdminTap: guardedAdminTap,
                  ),
          ),
        ),
      ),
    );
  }
}

class _DesktopNavbarLayout extends StatelessWidget {
  final bool isTablet;
  final String activeItem;
  final String cartTitle;
  final VoidCallback? onHomeTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSpecialPacksTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onContactTap;
  final VoidCallback? onLookbookTap;
  final VoidCallback? onDeliveryTap;
  final VoidCallback? onTrackOrderTap;
  final VoidCallback? onOrderNowTap;
  final VoidCallback? onAdminTap;

  const _DesktopNavbarLayout({
    required this.isTablet,
    required this.activeItem,
    required this.cartTitle,
    this.onHomeTap,
    this.onMenuTap,
    this.onSpecialPacksTap,
    this.onCartTap,
    this.onContactTap,
    this.onLookbookTap,
    this.onDeliveryTap,
    this.onTrackOrderTap,
    this.onOrderNowTap,
    this.onAdminTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LogoSection(
          isMobile: false,
          storeName: context.watch<StoreController>().getStoreSettings().storeName,
          tagline: context.watch<StoreController>().getStoreSettings().tagline,
          onTap: onHomeTap,
          onLongPress: onAdminTap,
        ),
        SizedBox(width: isTablet ? 14 : 22),
        Expanded(
          child: _DesktopNavLinks(
            activeItem: activeItem,
            cartTitle: cartTitle,
            compact: isTablet,
            onHomeTap: onHomeTap,
            onMenuTap: onMenuTap,
            onSpecialPacksTap: onSpecialPacksTap,
            onCartTap: onCartTap,
            onContactTap: onContactTap,
            onLookbookTap: onLookbookTap,
            onDeliveryTap: onDeliveryTap,
            onTrackOrderTap: onTrackOrderTap,
          ),
        ),
        SizedBox(width: isTablet ? 12 : 18),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeToggleButton(isMobile: false, compact: isTablet),
            SizedBox(width: isTablet ? 10 : 12),
            _NavbarActions(
              isTablet: isTablet,
              onOrderNowTap: onOrderNowTap,
            ),
          ],
        ),
      ],
    );
  }
}

Future<void> _showAdminAccessDialog(
  BuildContext context,
  VoidCallback onAuthorized,
) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _AdminAccessDialog(onAuthorized: onAuthorized),
  );
}

class _AdminAccessDialog extends StatefulWidget {
  final VoidCallback onAuthorized;

  const _AdminAccessDialog({
    required this.onAuthorized,
  });

  @override
  State<_AdminAccessDialog> createState() => _AdminAccessDialogState();
}

class _AdminAccessDialogState extends State<_AdminAccessDialog> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _masterPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _showResetFlow = false;
  bool _obscureMasterPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorText;
  String? _resetErrorText;

  bool _isStrongPassword(String value) {
    if (value.length < 8) return false;
    final hasUppercase = _hasUppercase(value);
    final hasLowercase = _hasLowercase(value);
    final hasDigit = _hasDigit(value);
    final hasSpecial = _hasSpecial(value);
    return hasUppercase && hasLowercase && hasDigit && hasSpecial;
  }

  bool _hasUppercase(String value) => RegExp(r'[A-Z]').hasMatch(value);
  bool _hasLowercase(String value) => RegExp(r'[a-z]').hasMatch(value);
  bool _hasDigit(String value) => RegExp(r'\d').hasMatch(value);
  bool _hasSpecial(String value) => RegExp(r'[^A-Za-z0-9]').hasMatch(value);

  @override
  void dispose() {
    _passwordController.dispose();
    _masterPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitAccess() {
    final storeController = context.read<StoreController>();
    final settings = storeController.getStoreSettings();
    final expectedPassword = settings.adminAccessPassword.trim();
    final enteredPassword = _passwordController.text.trim();

    if (enteredPassword.isEmpty) {
      setState(() {
        _errorText = 'Enter the admin password to continue.';
      });
      return;
    }

    if (enteredPassword != expectedPassword) {
      setState(() {
        _errorText = 'That admin password is not correct.';
      });
      return;
    }

    Navigator.pop(context);
    widget.onAuthorized();
  }

  void _submitReset() {
    final masterPassword = _masterPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (masterPassword != _adminResetMasterPassword) {
      setState(() {
        _resetErrorText = 'That special reset password is not correct.';
      });
      return;
    }

    if (!_isStrongPassword(newPassword)) {
      setState(() {
        _resetErrorText =
            'Use at least 8 characters with uppercase, lowercase, number, and special character.';
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _resetErrorText = 'The new password and confirmation do not match.';
      });
      return;
    }

    final storeController = context.read<StoreController>();
    final settings = storeController.getStoreSettings();
    storeController.updateStoreSettings(
      settings.copyWith(adminAccessPassword: newPassword),
    );

    setState(() {
      _showResetFlow = false;
      _resetErrorText = null;
      _errorText = 'Admin password reset successfully. Use the new password now.';
      _passwordController.clear();
      _masterPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: palette.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x30000000),
                blurRadius: 28,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: _showResetFlow
              ? _buildResetView(palette)
              : _buildAccessView(palette),
        ),
      ),
    );
  }

  Widget _buildAccessView(AppPalette palette) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.admin_panel_settings_rounded,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Access',
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enter your premium admin password to open the DTHC control area.',
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
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Admin password',
            errorText: _errorText,
            filled: true,
            fillColor: palette.surfaceAlt,
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
              borderSide: const BorderSide(color: AppColors.gold, width: 1.4),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: palette.textSecondary,
              ),
            ),
          ),
          style: TextStyle(color: palette.textPrimary),
          onSubmitted: (_) => _submitAccess(),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              setState(() {
                _showResetFlow = true;
                _errorText = null;
              });
            },
            child: const Text('Forgot password?'),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: palette.textPrimary,
                  side: BorderSide(color: palette.border),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _submitAccess,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.primaryBlack,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Open Admin',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResetView(AppPalette palette) {
    InputDecoration decoration(String label, {Widget? suffixIcon}) {
      return InputDecoration(
        labelText: label,
        errorText: null,
        filled: true,
        fillColor: palette.surfaceAlt,
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
          borderSide: const BorderSide(color: AppColors.gold, width: 1.4),
        ),
        suffixIcon: suffixIcon,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reset Admin Password',
          style: TextStyle(
            color: palette.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter the special master password first, then choose your new admin password.',
          style: TextStyle(
            color: palette.textSecondary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        _PasswordRequirementList(
          password: _newPasswordController.text,
          palette: palette,
        ),
        const SizedBox(height: 18),
        TextField(
          controller: _masterPasswordController,
          obscureText: _obscureMasterPassword,
          decoration: decoration(
            'Special reset password',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureMasterPassword = !_obscureMasterPassword;
                });
              },
              icon: Icon(
                _obscureMasterPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: palette.textSecondary,
              ),
            ),
          ),
          style: TextStyle(color: palette.textPrimary),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _newPasswordController,
          obscureText: _obscureNewPassword,
          onChanged: (_) {
            setState(() {
              _resetErrorText = null;
            });
          },
          decoration: decoration(
            'New admin password',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
              icon: Icon(
                _obscureNewPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: palette.textSecondary,
              ),
            ),
          ),
          style: TextStyle(color: palette.textPrimary),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: decoration(
            'Confirm new password',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: palette.textSecondary,
              ),
            ),
          ),
          style: TextStyle(color: palette.textPrimary),
        ),
        if (_resetErrorText != null) ...[
          const SizedBox(height: 10),
          Text(
            _resetErrorText!,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _showResetFlow = false;
                    _resetErrorText = null;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: palette.textPrimary,
                  side: BorderSide(color: palette.border),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _submitReset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.primaryBlack,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Reset Password',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  final bool isMobile;
  final bool compact;

  const _ThemeToggleButton({
    required this.isMobile,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final palette = AppColors.palette(themeController.isDarkMode);
    final isDarkMode = themeController.isDarkMode;

    if (isMobile) {
      return Tooltip(
        message: isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              themeController.toggle();
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: palette.surfaceStrong,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: palette.border),
              ),
              child: Icon(
                isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: isDarkMode ? AppColors.gold : palette.textOnStrong,
                size: 22,
              ),
            ),
          ),
        ),
      );
    }

    return Tooltip(
      message: isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            themeController.toggle();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 12 : 14,
              vertical: compact ? 12 : 14,
            ),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: palette.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  size: compact ? 18 : 19,
                  color: isDarkMode ? AppColors.gold : palette.textPrimary,
                ),
                SizedBox(width: compact ? 8 : 9),
                Text(
                  isDarkMode ? 'Light' : 'Dark',
                  style: TextStyle(
                    fontSize: compact ? 13 : 14,
                    fontWeight: FontWeight.w800,
                    color: palette.textPrimary,
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

class _LogoSection extends StatelessWidget {
  final bool isMobile;
  final String storeName;
  final String tagline;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _LogoSection({
    required this.isMobile,
    required this.storeName,
    required this.tagline,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    if (isMobile) {
      return InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(18),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                color: AppColors.primaryBlack,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'DTHC',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: palette.textOnStrong,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    storeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(18),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: isMobile ? 48 : 52,
            width: isMobile ? 48 : 52,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: AppColors.primaryBlack,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'DTHC',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: palette.textOnStrong,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                storeName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DesktopNavLinks extends StatelessWidget {
  final String activeItem;
  final String cartTitle;
  final bool compact;
  final VoidCallback? onHomeTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSpecialPacksTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onContactTap;
  final VoidCallback? onLookbookTap;
  final VoidCallback? onDeliveryTap;
  final VoidCallback? onTrackOrderTap;

  const _DesktopNavLinks({
    required this.activeItem,
    required this.cartTitle,
    required this.compact,
    this.onHomeTap,
    this.onMenuTap,
    this.onSpecialPacksTap,
    this.onCartTap,
    this.onContactTap,
    this.onLookbookTap,
    this.onDeliveryTap,
    this.onTrackOrderTap,
  });

  @override
  Widget build(BuildContext context) {
    final gap = compact ? 6.0 : 8.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final navItems = [
          _NavButton(
            title: 'Home',
            icon: Icons.home_rounded,
            active: activeItem == 'Home',
            compact: compact,
            onTap: onHomeTap,
          ),
          _NavButton(
            title: 'Shop',
            icon: Icons.storefront_outlined,
            active: activeItem == 'Shop' || activeItem == 'Menu',
            compact: compact,
            onTap: onMenuTap,
          ),
          _NavButton(
            title: 'Collections',
            icon: Icons.layers_outlined,
            active: activeItem == 'Collections' || activeItem == 'Special Packs',
            compact: compact,
            onTap: onSpecialPacksTap,
          ),
          _NavButton(
            title: 'Lookbook',
            icon: Icons.photo_library_outlined,
            active: activeItem == 'Lookbook',
            compact: compact,
            onTap: onLookbookTap,
          ),
          _NavButton(
            title: 'Delivery',
            icon: Icons.local_shipping_outlined,
            active:
                activeItem == 'Delivery' ||
                activeItem == 'Payment & Delivery',
            compact: compact,
            onTap: onDeliveryTap,
          ),
          _NavButton(
            title: 'Track Order',
            icon: Icons.local_shipping_rounded,
            active: activeItem == 'Track Order',
            compact: compact,
            onTap: onTrackOrderTap,
          ),
          _NavButton(
            title: cartTitle,
            icon: Icons.shopping_cart_outlined,
            active: activeItem == 'Cart',
            compact: compact,
            onTap: onCartTap,
          ),
          _NavButton(
            title: 'Contact',
            icon: Icons.call_outlined,
            active: activeItem == 'Contact',
            compact: compact,
            onTap: onContactTap,
          ),
        ];

        return Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < navItems.length; i++) ...[
                  navItems[i],
                  if (i != navItems.length - 1) SizedBox(width: gap),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NavButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool active;
  final bool compact;
  final VoidCallback? onTap;

  const _NavButton({
    required this.title,
    required this.icon,
    this.active = false,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);
    final horizontalPadding = compact ? 10.0 : 14.0;
    final verticalPadding = compact ? 10.0 : 11.0;
    final fontSize = compact ? 14.0 : 15.0;
    final iconSize = compact ? 15.0 : 16.0;
    final spacing = compact ? 6.0 : 7.0;

    return Container(
      decoration: BoxDecoration(
        color: active ? AppColors.gold : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: active ? Border.all(color: AppColors.gold) : Border.all(color: Colors.transparent),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: active ? AppColors.primaryBlack : palette.textOnStrong,
              ),
              SizedBox(width: spacing),
              Text(
                title,
                overflow: TextOverflow.visible,
                softWrap: false,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  color: active ? AppColors.primaryBlack : palette.textOnStrong,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavbarActions extends StatelessWidget {
  final bool isTablet;
  final VoidCallback? onOrderNowTap;

  const _NavbarActions({
    required this.isTablet,
    this.onOrderNowTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onOrderNowTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.primaryBlack,
        elevation: 0,
        minimumSize: Size(isTablet ? 120 : 132, 56),
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16 : 18,
          vertical: 18,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: const Text(
        'Shop Now',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _MobileMenuButton extends StatelessWidget {
  final String activeItem;
  final String cartTitle;
  final VoidCallback? onHomeTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSpecialPacksTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onContactTap;
  final VoidCallback? onLookbookTap;
  final VoidCallback? onDeliveryTap;
  final VoidCallback? onTrackOrderTap;
  final VoidCallback? onOrderNowTap;

  const _MobileMenuButton({
    required this.activeItem,
    required this.cartTitle,
    this.onHomeTap,
    this.onMenuTap,
    this.onSpecialPacksTap,
    this.onCartTap,
    this.onContactTap,
    this.onLookbookTap,
    this.onDeliveryTap,
    this.onTrackOrderTap,
    this.onOrderNowTap,
  });

  void _handleSelection(String? value) {
    if (value == 'Home') {
      onHomeTap?.call();
    } else if (value == 'Shop') {
      onMenuTap?.call();
    } else if (value == 'Collections') {
      onSpecialPacksTap?.call();
    } else if (value == 'Lookbook') {
      onLookbookTap?.call();
    } else if (value == 'Delivery') {
      onDeliveryTap?.call();
    } else if (value == 'Track Order') {
      onTrackOrderTap?.call();
    } else if (value == 'Cart') {
      onCartTap?.call();
    } else if (value == 'Contact') {
      onContactTap?.call();
    } else if (value == 'Shop Now') {
      onOrderNowTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: palette.surfaceStrong,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: palette.border),
      ),
      child: IconButton(
        onPressed: () async {
          final selected = await showGeneralDialog<String>(
            context: context,
            barrierLabel: 'Menu',
            barrierDismissible: true,
            barrierColor: Colors.black.withValues(alpha: 0.18),
            pageBuilder: (dialogContext, _, __) {
              final dialogPalette = AppColors.palette(
                dialogContext.watch<ThemeController>().isDarkMode,
              );

              return SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 68, right: 12, left: 136),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 220,
                        decoration: BoxDecoration(
                          color: dialogPalette.surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: dialogPalette.border),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x26000000),
                              blurRadius: 18,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _MobileMenuAction(
                              title: 'Home',
                              icon: Icons.home_rounded,
                              active: activeItem == 'Home',
                              onTap: () => Navigator.pop(dialogContext, 'Home'),
                            ),
                            _MobileMenuAction(
                              title: 'Shop',
                              icon: Icons.storefront_outlined,
                              active: activeItem == 'Shop' || activeItem == 'Menu',
                              onTap: () => Navigator.pop(dialogContext, 'Shop'),
                            ),
                            _MobileMenuAction(
                              title: 'Collections',
                              icon: Icons.layers_outlined,
                              active:
                                  activeItem == 'Collections' ||
                                  activeItem == 'Special Packs',
                              onTap: () => Navigator.pop(dialogContext, 'Collections'),
                            ),
                            _MobileMenuAction(
                              title: 'Lookbook',
                              icon: Icons.photo_library_outlined,
                              active: activeItem == 'Lookbook',
                              onTap: () => Navigator.pop(dialogContext, 'Lookbook'),
                            ),
                            _MobileMenuAction(
                              title: 'Delivery',
                              icon: Icons.local_shipping_outlined,
                              active:
                                  activeItem == 'Delivery' ||
                                  activeItem == 'Payment & Delivery',
                              onTap: () => Navigator.pop(dialogContext, 'Delivery'),
                            ),
                            _MobileMenuAction(
                              title: 'Track Order',
                              icon: Icons.local_shipping_rounded,
                              active: activeItem == 'Track Order',
                              onTap: () => Navigator.pop(dialogContext, 'Track Order'),
                            ),
                            _MobileMenuAction(
                              title: cartTitle,
                              icon: Icons.shopping_cart_outlined,
                              active: activeItem == 'Cart',
                              onTap: () => Navigator.pop(dialogContext, 'Cart'),
                            ),
                            _MobileMenuAction(
                              title: 'Contact',
                              icon: Icons.call_outlined,
                              active: activeItem == 'Contact',
                              onTap: () => Navigator.pop(dialogContext, 'Contact'),
                            ),
                            Divider(height: 1, color: dialogPalette.border),
                            _MobileMenuAction(
                              title: 'Shop Now',
                              icon: Icons.shopping_bag_outlined,
                              onTap: () => Navigator.pop(dialogContext, 'Shop Now'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );

          _handleSelection(selected);
        },
        icon: Icon(
          Icons.menu_rounded,
          color: palette.textOnStrong,
          size: 24,
        ),
      ),
    );
  }
}

class _MobileMenuHeader extends StatelessWidget {
  final String storeName;
  final bool compact;

  const _MobileMenuHeader({
    required this.storeName,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);
    return Padding(
      padding: EdgeInsets.fromLTRB(18, compact ? 14 : 18, 18, compact ? 12 : 16),
      child: Row(
        children: [
          Container(
            height: compact ? 46 : 54,
            width: compact ? 46 : 54,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(compact ? 14 : 18),
            ),
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: AppColors.primaryBlack,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DTHC',
                  style: TextStyle(
                    fontSize: compact ? 18 : 20,
                    fontWeight: FontWeight.w900,
                    color: palette.textOnStrong,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  storeName,
                  style: TextStyle(
                    fontSize: compact ? 11.5 : 13,
                    fontWeight: FontWeight.w600,
                    color: palette.textSecondary,
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

class _MobileMenuAction extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _MobileMenuAction({
    required this.title,
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: active ? AppColors.gold : palette.textOnStrong,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: active ? AppColors.gold : palette.textOnStrong,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordRequirementList extends StatelessWidget {
  final String password;
  final AppPalette palette;

  const _PasswordRequirementList({
    required this.password,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final requirements = [
      _PasswordRequirementData(
        label: 'At least 8 characters',
        satisfied: password.length >= 8,
      ),
      _PasswordRequirementData(
        label: 'One uppercase letter',
        satisfied: RegExp(r'[A-Z]').hasMatch(password),
      ),
      _PasswordRequirementData(
        label: 'One lowercase letter',
        satisfied: RegExp(r'[a-z]').hasMatch(password),
      ),
      _PasswordRequirementData(
        label: 'One number',
        satisfied: RegExp(r'\d').hasMatch(password),
      ),
      _PasswordRequirementData(
        label: 'One special character',
        satisfied: RegExp(r'[^A-Za-z0-9]').hasMatch(password),
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: requirements
            .map(
              (requirement) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(
                      requirement.satisfied
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      size: 16,
                      color: requirement.satisfied
                          ? Colors.greenAccent.shade400
                          : Colors.redAccent.shade200,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      requirement.label,
                      style: TextStyle(
                        color: requirement.satisfied
                            ? Colors.greenAccent.shade400
                            : Colors.redAccent.shade200,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _PasswordRequirementData {
  final String label;
  final bool satisfied;

  const _PasswordRequirementData({
    required this.label,
    required this.satisfied,
  });
}
