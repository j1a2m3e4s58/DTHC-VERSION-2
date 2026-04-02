import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'track_order_page.dart';
import 'lookbook_page.dart';
import 'payment_delivery_page.dart';
import '../core/app_colors.dart';
import '../data/cart_controller.dart';
import '../data/theme_controller.dart';
import '../models/cart_item.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/store_image.dart';
import 'checkout_page.dart';
import 'home_page.dart';
import 'menu_page.dart';
import 'contact_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;
    final cart = context.watch<CartController>();
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        children: [
          CustomNavbar(
            activeItem: 'Cart',
            onHomeTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            onContactTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactPage()),
              );
            },
            onTrackOrderTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TrackOrderPage()),
              );
            },
            onMenuTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MenuPage()),
              );
            },
            onSpecialPacksTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MenuPage()),
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
            onOrderNowTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MenuPage()),
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1320),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 28,
                      vertical: isMobile ? 20 : 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(
                          context,
                          isMobile,
                          cart.totalItemsCount,
                          palette,
                        ),
                        const SizedBox(height: 28),
                        if (cart.isEmpty)
                          _buildEmptyState(context, isMobile, palette)
                        else
                          _buildCartContent(context, cart, isMobile, palette),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isMobile,
    int cartCount,
    AppPalette palette,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Cart',
          style: TextStyle(
            fontSize: isMobile ? 30 : 42,
            fontWeight: FontWeight.w900,
            color: palette.textPrimary,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          cartCount == 0
              ? 'Your selected fashion pieces will appear here.'
              : 'You have $cartCount item${cartCount > 1 ? 's' : ''} ready for checkout.',
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            height: 1.6,
            color: palette.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    bool isMobile,
    AppPalette palette,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: isMobile ? 56 : 78,
            color: AppColors.gold,
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty for now.',
            style: TextStyle(
              fontSize: isMobile ? 18 : 24,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Go back to the shop and add tees, sneakers, caps, chains, belts, or socks.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 13 : 15,
              height: 1.7,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 22),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.primaryBlack,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MenuPage()),
              );
            },
            child: const Text(
              'Back to Shop',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(
    BuildContext context,
    CartController cart,
    bool isMobile,
    AppPalette palette,
  ) {
    if (isMobile) {
      return Column(
        children: [
          _buildCartItemsCard(context, cart, isMobile, palette),
          const SizedBox(height: 20),
          _buildSummaryCard(context, cart, isMobile, palette),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: _buildCartItemsCard(context, cart, isMobile, palette),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 4,
          child: _buildSummaryCard(context, cart, isMobile, palette),
        ),
      ],
    );
  }

  Widget _buildCartItemsCard(
    BuildContext context,
    CartController cart,
    bool isMobile,
    AppPalette palette,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 14 : 20),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          ...List.generate(cart.items.length, (index) {
            final item = cart.items[index];

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == cart.items.length - 1 ? 0 : 16,
              ),
              child: _buildCartItemTile(context, item, isMobile, palette),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCartItemTile(
    BuildContext context,
    CartItem item,
    bool isMobile,
    AppPalette palette,
  ) {
    final cart = context.read<CartController>();

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.border),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMobileCartItemTop(item, palette),
                const SizedBox(height: 14),
                _buildMobileCartItemBottom(cart, item, palette),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: _buildDesktopCartItemLeft(item, palette),
                ),
                const SizedBox(width: 18),
                Expanded(
                  flex: 4,
                  child: _buildDesktopCartItemRight(cart, item, palette),
                ),
              ],
            ),
    );
  }

  Widget _buildMobileCartItemTop(CartItem item, AppPalette palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductImage(item, true),
        const SizedBox(height: 14),
        _buildProductDetails(item, true, palette),
      ],
    );
  }

  Widget _buildDesktopCartItemLeft(CartItem item, AppPalette palette) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductImage(item, false),
        const SizedBox(width: 18),
        Expanded(
          child: _buildProductDetails(item, false, palette),
        ),
      ],
    );
  }

  Widget _buildProductImage(CartItem item, bool isMobile) {
    final imageUrl = item.product.imageUrls.isNotEmpty
        ? item.product.imageUrls.first.trim()
        : '';

    final double imageHeight = isMobile ? 210 : 170;
    final double imageWidth = isMobile ? double.infinity : 170;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: imageHeight,
        width: imageWidth,
        decoration: const BoxDecoration(
          gradient: AppColors.heroGradient,
        ),
        child: imageUrl.isNotEmpty
            ? StoreImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                errorWidget: _buildImageFallback(isMobile),
              )
            : _buildImageFallback(isMobile),
      ),
    );
  }

  Widget _buildImageLoader(bool isMobile) {
    return Center(
      child: SizedBox(
        width: isMobile ? 28 : 30,
        height: isMobile ? 28 : 30,
        child: const CircularProgressIndicator(
          color: AppColors.gold,
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  Widget _buildImageFallback(bool isMobile) {
    return Center(
      child: Icon(
        Icons.shopping_bag_outlined,
        size: isMobile ? 44 : 46,
        color: AppColors.gold,
      ),
    );
  }

  Widget _buildProductDetails(
    CartItem item,
    bool isMobile,
    AppPalette palette,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildBadge(item.product.category, isGold: true),
            _buildBadge(
              item.product.isAvailable ? 'In Stock' : 'Unavailable',
              isGold: false,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          item.product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isMobile ? 18 : 21,
            fontWeight: FontWeight.w800,
            color: palette.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.product.description,
          maxLines: isMobile ? 3 : 4,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isMobile ? 13 : 14,
            height: 1.65,
            color: palette.textSecondary,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildInfoTile(
                'Unit Price',
                'GHS ${item.product.price.toStringAsFixed(2)}',
                palette,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildInfoTile(
                'Quantity',
                '${item.quantity}',
                palette,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(String text, {required bool isGold}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isGold
            ? AppColors.gold.withValues(alpha: 0.12)
            : AppColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isGold
              ? AppColors.gold.withValues(alpha: 0.20)
              : AppColors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: isGold ? AppColors.gold : AppColors.white,
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, AppPalette palette) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCartItemBottom(
    CartController cart,
    CartItem item,
    AppPalette palette,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildQuantityControl(cart, item, true, palette),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTotalBox(item, true, palette),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: _buildRemoveButton(cart, item, true),
        ),
      ],
    );
  }

  Widget _buildDesktopCartItemRight(
    CartController cart,
    CartItem item,
    AppPalette palette,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTotalBox(item, false, palette),
        const SizedBox(height: 14),
        _buildQuantityControl(cart, item, false, palette),
        const SizedBox(height: 14),
        _buildRemoveButton(cart, item, false),
      ],
    );
  }

  Widget _buildTotalBox(CartItem item, bool isMobile, AppPalette palette) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Item Total',
            style: TextStyle(
              fontSize: isMobile ? 11.5 : 12,
              fontWeight: FontWeight.w700,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'GHS ${item.totalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.w900,
              color: AppColors.gold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControl(
    CartController cart,
    CartItem item,
    bool isMobile,
    AppPalette palette,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 10,
        vertical: isMobile ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            palette: palette,
            onTap: () {
              cart.decreaseQuantity(item.product.id);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${item.quantity}',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w800,
                color: palette.textPrimary,
              ),
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add,
            palette: palette,
            onTap: () {
              cart.increaseQuantity(item.product.id);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required AppPalette palette,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: palette.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.border),
        ),
        child: Icon(
          icon,
          size: 18,
          color: palette.textPrimary,
        ),
      ),
    );
  }

  Widget _buildRemoveButton(
    CartController cart,
    CartItem item,
    bool isMobile,
  ) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.gold,
        side: BorderSide(
          color: AppColors.gold.withValues(alpha: 0.25),
        ),
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 13 : 14,
          horizontal: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onPressed: () {
        cart.removeFromCart(item.product.id);
      },
      icon: const Icon(Icons.delete_outline, size: 18),
      label: const Text(
        'Remove Item',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    CartController cart,
    bool isMobile,
    AppPalette palette,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 22),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: isMobile ? 18 : 24,
              fontWeight: FontWeight.w900,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Review your order before moving to checkout.',
            style: TextStyle(
              fontSize: isMobile ? 12.5 : 13.5,
              height: 1.6,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          _buildSummaryRow('Subtotal', cart.subtotal, palette: palette),
          const SizedBox(height: 12),
          _buildSummaryTextRow(
            'Delivery Fee',
            cart.deliveryFeeLabel,
            palette: palette,
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: palette.border),
            ),
            child: Text(
              cart.deliveryNote,
              style: TextStyle(
                fontSize: isMobile ? 12 : 13,
                height: 1.5,
                color: palette.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: palette.border),
          ),
          _buildSummaryRow(
            'Estimated Total',
            cart.estimatedTotal,
            isTotal: true,
            palette: palette,
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.primaryBlack,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CheckoutPage()),
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text(
                'Proceed to Checkout',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: palette.textPrimary,
                side: BorderSide(color: palette.border),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                cart.clearCart();
              },
              icon: const Icon(Icons.delete_sweep_outlined),
              label: const Text(
                'Clear Cart',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double amount, {
    bool isTotal = false,
    required AppPalette palette,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
              color: palette.textPrimary,
            ),
          ),
        ),
        Text(
          'GHS ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 20 : 15,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
            color: isTotal ? AppColors.gold : palette.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryTextRow(
    String label,
    String value, {
    bool isTotal = false,
    required AppPalette palette,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
              color: palette.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w700,
            color: isTotal ? AppColors.gold : palette.textPrimary,
          ),
        ),
      ],
    );
  }
}
