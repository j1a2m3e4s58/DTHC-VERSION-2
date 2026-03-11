import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'lookbook_page.dart';
import 'payment_delivery_page.dart';
import '../core/app_colors.dart';
import '../data/cart_controller.dart';
import '../models/cart_item.dart';
import '../widgets/custom_navbar.dart';
import 'checkout_page.dart';
import 'home_page.dart';
import 'menu_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;
    final cart = context.watch<CartController>();

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
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
            onCartTap: () {},
            onContactTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contact page will be connected next.'),
                ),
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
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 32,
                      vertical: isMobile ? 20 : 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, isMobile, cart.totalItemsCount),
                        const SizedBox(height: 28),
                        if (cart.isEmpty)
                          _buildEmptyState(context, isMobile)
                        else
                          _buildCartContent(context, cart, isMobile),
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

  Widget _buildHeader(BuildContext context, bool isMobile, int cartCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Cart',
          style: TextStyle(
            fontSize: isMobile ? 28 : 40,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          cartCount == 0
              ? 'Your selected fashion pieces will appear here.'
              : 'You have $cartCount item${cartCount > 1 ? 's' : ''} in your cart.',
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            height: 1.6,
            color: const Color(0xFFBDBDBD),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.charcoal),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: isMobile ? 54 : 72,
            color: AppColors.gold,
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty for now.',
            style: TextStyle(
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Go back to the shop and add tees, sneakers, caps, chains, belts, or socks.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 13 : 15,
              height: 1.6,
              color: const Color(0xFFBDBDBD),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.primaryBlack,
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
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
            child: const Text('Back to Shop'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(
    BuildContext context,
    CartController cart,
    bool isMobile,
  ) {
    if (isMobile) {
      return Column(
        children: [
          _buildCartItemsCard(context, cart, isMobile),
          const SizedBox(height: 20),
          _buildSummaryCard(context, cart, isMobile),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: _buildCartItemsCard(context, cart, isMobile),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 4,
          child: _buildSummaryCard(context, cart, isMobile),
        ),
      ],
    );
  }

  Widget _buildCartItemsCard(
    BuildContext context,
    CartController cart,
    bool isMobile,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.charcoal),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: cart.items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildCartItemTile(context, item, isMobile),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCartItemTile(
    BuildContext context,
    CartItem item,
    bool isMobile,
  ) {
    final cart = context.read<CartController>();

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlack,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.charcoal,
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildItemTopSection(item, isMobile),
                const SizedBox(height: 14),
                _buildItemBottomSection(context, cart, item, isMobile),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 5,
                  child: _buildItemTopSection(item, isMobile),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 4,
                  child: _buildItemBottomSection(context, cart, item, isMobile),
                ),
              ],
            ),
    );
  }

  Widget _buildItemTopSection(CartItem item, bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: isMobile ? 72 : 84,
            width: isMobile ? 72 : 84,
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(18),
            ),
            child: item.product.imageUrl.trim().isNotEmpty
                ? Image.network(
                    item.product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.shopping_bag_outlined,
                        size: isMobile ? 30 : 34,
                        color: AppColors.gold,
                      );
                    },
                  )
                : Icon(
                    Icons.shopping_bag_outlined,
                    size: isMobile ? 30 : 34,
                    color: AppColors.gold,
                  ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isMobile ? 15 : 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.product.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isMobile ? 12 : 13,
                  height: 1.5,
                  color: const Color(0xFFBDBDBD),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'GHS ${item.product.price.toStringAsFixed(2)} each',
                style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemBottomSection(
    BuildContext context,
    CartController cart,
    CartItem item,
    bool isMobile,
  ) {
    return isMobile
        ? Row(
            children: [
              _buildQuantityControl(cart, item, isMobile),
              const Spacer(),
              _buildItemPriceAndDelete(cart, item, isMobile),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuantityControl(cart, item, isMobile),
              _buildItemPriceAndDelete(cart, item, isMobile),
            ],
          );
  }

  Widget _buildQuantityControl(
    CartController cart,
    CartItem item,
    bool isMobile,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              cart.decreaseQuantity(item.product.id);
            },
            icon: const Icon(Icons.remove, color: AppColors.white),
            visualDensity: VisualDensity.compact,
          ),
          Text(
            '${item.quantity}',
            style: TextStyle(
              fontSize: isMobile ? 14 : 15,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              cart.increaseQuantity(item.product.id);
            },
            icon: const Icon(Icons.add, color: AppColors.white),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildItemPriceAndDelete(
    CartController cart,
    CartItem item,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'GHS ${item.totalPrice.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isMobile ? 15 : 17,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 6),
        TextButton.icon(
          onPressed: () {
            cart.removeFromCart(item.product.id);
          },
          icon: const Icon(Icons.delete_outline, size: 18),
          label: const Text('Remove'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.gold,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    CartController cart,
    bool isMobile,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 22),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.charcoal),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 16,
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
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 18),
          _buildSummaryRow('Subtotal', cart.subtotal),
          const SizedBox(height: 10),
          _buildSummaryTextRow('Delivery Fee', cart.deliveryFeeLabel),
          const SizedBox(height: 8),
          Text(
            cart.deliveryNote,
            style: TextStyle(
              fontSize: isMobile ? 12 : 13,
              height: 1.5,
              color: const Color(0xFFBDBDBD),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: AppColors.charcoal),
          ),
          _buildSummaryRow(
            'Estimated Total',
            cart.estimatedTotal,
            isTotal: true,
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.primaryBlack,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CheckoutPage()),
                );
              },
              child: const Text('Proceed to Checkout'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.white,
                side: const BorderSide(color: AppColors.charcoal),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                cart.clearCart();
              },
              child: const Text('Clear Cart'),
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
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
              color: AppColors.white,
            ),
          ),
        ),
        Text(
          'GHS ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w700,
            color: isTotal ? AppColors.gold : AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryTextRow(
    String label,
    String value, {
    bool isTotal = false,
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
              color: AppColors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w700,
            color: isTotal ? AppColors.gold : AppColors.white,
          ),
        ),
      ],
    );
  }
}