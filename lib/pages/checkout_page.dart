import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../data/cart_controller.dart';
import '../data/order_controller.dart';
import '../models/customer_order.dart';
import '../models/order_item.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    final cartController = context.read<CartController>();
    final orderController = context.read<OrderController>();

    if (cartController.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty.')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final orderItems = cartController.items.map((cartItem) {
        return OrderItem(
          foodId: cartItem.product.id,
          name: cartItem.product.name,
          price: cartItem.product.price,
          quantity: cartItem.quantity,
          imageUrl: cartItem.product.imageUrl,
        );
      }).toList();

      final order = CustomerOrder(
        id: '',
        customerName: nameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        address: addressController.text.trim(),
        note: noteController.text.trim(),
        items: orderItems,
        subtotal: cartController.subtotal,
        deliveryFee: 0,
        total: cartController.estimatedTotal,
        createdAt: DateTime.now(),
        isNew: true,
        isDelivered: false,
      );

      await orderController.placeOrder(order);

      if (!mounted) return;

      cartController.clearCart();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors.softBlack,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            title: const Text(
              'Order placed',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            content: const Text(
              'Your order has been placed successfully. DTHC will contact you to confirm delivery details and final delivery cost.',
              style: TextStyle(
                color: Color(0xFFBDBDBD),
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: AppColors.gold),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = context.watch<CartController>();
    final items = cartController.items;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;
    final isTablet = width >= 800 && width < 1100;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.softBlack,
        foregroundColor: AppColors.white,
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty. Add products before checkout.',
                style: TextStyle(color: AppColors.white),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 28,
                vertical: isMobile ? 18 : 28,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1240),
                  child: isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTopIntro(isMobile: true),
                            const SizedBox(height: 18),
                            _buildCustomerFormCard(isMobile: true),
                            const SizedBox(height: 18),
                            _buildOrderSummaryCard(cartController, true),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: isTablet ? 6 : 7,
                              child: Column(
                                children: [
                                  _buildTopIntro(isMobile: false),
                                  const SizedBox(height: 20),
                                  _buildCustomerFormCard(isMobile: false),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: isTablet ? 4 : 5,
                              child: _buildOrderSummaryCard(
                                cartController,
                                false,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
    );
  }

  Widget _buildTopIntro({required bool isMobile}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 22),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Complete your order',
            style: TextStyle(
              fontSize: isMobile ? 24 : 30,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fill in your details clearly so DTHC can confirm your order, delivery location, and final delivery cost.',
            style: TextStyle(
              fontSize: isMobile ? 13.5 : 15,
              height: 1.6,
              color: const Color(0xFFBDBDBD),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerFormCard({required bool isMobile}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.charcoal),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: AppColors.primaryBlack,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Details',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Enter the correct details for contact and delivery confirmation.',
                        style: TextStyle(
                          color: Color(0xFFBDBDBD),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            isMobile
                ? Column(
                    children: [
                      _buildField(
                        controller: nameController,
                        label: 'Full Name',
                        icon: Icons.badge_outlined,
                        validatorMessage: 'Enter your full name',
                      ),
                      const SizedBox(height: 14),
                      _buildField(
                        controller: phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validatorMessage: 'Enter your phone number',
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          controller: nameController,
                          label: 'Full Name',
                          icon: Icons.badge_outlined,
                          validatorMessage: 'Enter your full name',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildField(
                          controller: phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validatorMessage: 'Enter your phone number',
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 14),
            _buildField(
              controller: addressController,
              label: 'Delivery Address',
              icon: Icons.location_on_outlined,
              maxLines: 2,
              validatorMessage: 'Enter your delivery address',
            ),
            const SizedBox(height: 14),
            _buildField(
              controller: noteController,
              label: 'Order Note (optional)',
              icon: Icons.edit_note_outlined,
              maxLines: 3,
              isOptional: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? validatorMessage,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isOptional = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.white),
      validator: isOptional
          ? null
          : (value) {
              if (value == null || value.trim().isEmpty) {
                return validatorMessage;
              }
              return null;
            },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFBDBDBD)),
        prefixIcon: Icon(icon, color: AppColors.gold),
        filled: true,
        fillColor: AppColors.primaryBlack,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.charcoal),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.charcoal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: AppColors.gold,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard(
    CartController cartController,
    bool isMobile,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 22),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.charcoal),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Review your selected products before placing your order.',
            style: TextStyle(
              color: Color(0xFFBDBDBD),
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          ...cartController.items.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryBlack,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.charcoal),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 58,
                      width: 58,
                      color: AppColors.charcoal,
                      child: item.product.imageUrl.trim().isNotEmpty
                          ? Image.network(
                              item.product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: AppColors.gold,
                                );
                              },
                            )
                          : const Icon(
                              Icons.shopping_bag_outlined,
                              color: AppColors.gold,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${item.product.name} x${item.quantity}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'GHS ${item.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.gold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: AppColors.charcoal),
          ),
          _summaryAmountRow('Subtotal', cartController.subtotal),
          const SizedBox(height: 10),
          _summaryTextRow('Delivery', cartController.deliveryFeeLabel),
          const SizedBox(height: 8),
          Text(
            cartController.deliveryNote,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: Color(0xFFBDBDBD),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          _summaryAmountRow(
            'Estimated Total',
            cartController.estimatedTotal,
            isBold: true,
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _placeOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.primaryBlack,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: AppColors.primaryBlack,
                      ),
                    )
                  : const Text(
                      'Place Order',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryAmountRow(String label, double amount, {bool isBold = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              fontSize: isBold ? 17 : 14,
              color: AppColors.white,
            ),
          ),
        ),
        Text(
          'GHS ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            fontSize: isBold ? 18 : 14,
            color: isBold ? AppColors.gold : AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _summaryTextRow(String label, String value, {bool isBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              fontSize: isBold ? 17 : 14,
              color: AppColors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            fontSize: isBold ? 18 : 14,
            color: isBold ? AppColors.gold : AppColors.white,
          ),
        ),
      ],
    );
  }
}