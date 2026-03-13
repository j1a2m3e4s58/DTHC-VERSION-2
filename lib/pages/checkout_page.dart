import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/app_colors.dart';
import '../data/cart_controller.dart';
import '../data/delivery_zone_controller.dart';
import '../data/order_controller.dart';
import '../models/customer_order.dart';
import '../models/delivery_zone.dart';
import '../models/order_item.dart';
import 'payment_delivery_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'order_success_page.dart';

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
  String _selectedPaymentMethod = 'Mobile Money';

  static const String _momoNumber = '0534206256';
  static const String _accountName = 'Deborah Osardu';

  static const List<_PaymentMethodOption> _paymentOptions = [
    _PaymentMethodOption(
      title: 'Mobile Money',
      subtitle:
          'Place order now and pay to the DTHC MoMo number using your order reference.',
      icon: Icons.phone_android_rounded,
    ),
    _PaymentMethodOption(
      title: 'Bank Transfer',
      subtitle:
          'Place order now and complete payment with the provided account details after confirmation.',
      icon: Icons.account_balance_rounded,
    ),
    _PaymentMethodOption(
      title: 'Pay on Delivery',
      subtitle: 'Available only where DTHC confirms it first.',
      icon: Icons.local_shipping_outlined,
    ),
  ];

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    noteController.dispose();
    super.dispose();
  }
  @override
  void initState() {
  super.initState();
  _loadSavedCustomerDetails();
}
  String _generateTrackingCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final suffix = timestamp.length >= 6
        ? timestamp.substring(timestamp.length - 6)
        : timestamp;
    return 'DTHC-$suffix';
  }

  double _resolveDeliveryFee(CartController cartController) {
    return cartController.selectedDeliveryFee;
  }

  void _syncSelectedZoneWithAvailableZones(
    CartController cartController,
    List<DeliveryZone> deliveryZones,
  ) {
    final selectedZone = cartController.selectedDeliveryZone;

    if (selectedZone == null) return;

    final stillExists = deliveryZones.any((zone) => zone.id == selectedZone.id);

    if (!stillExists) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        cartController.clearSelectedDeliveryZone();
      });
    }
  }
  Future<void> _loadSavedCustomerDetails() async {
  final prefs = await SharedPreferences.getInstance();

  nameController.text = prefs.getString('checkout_name') ?? '';
  phoneController.text = prefs.getString('checkout_phone') ?? '';
  addressController.text = prefs.getString('checkout_address') ?? '';
}

Future<void> _saveCustomerDetails() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString('checkout_name', nameController.text.trim());
  await prefs.setString('checkout_phone', phoneController.text.trim());
  await prefs.setString('checkout_address', addressController.text.trim());
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

    if (!cartController.hasSelectedDeliveryZone) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a delivery zone before placing order.'),
        ),
      );
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

      final trackingCode = _generateTrackingCode();
      final deliveryFee = _resolveDeliveryFee(cartController);

      final order = CustomerOrder(
        id: '',
        customerName: nameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        address: addressController.text.trim(),
        note: noteController.text.trim(),
        items: orderItems,
        subtotal: cartController.subtotal,
        deliveryFee: deliveryFee,
        total: cartController.estimatedTotal,
        createdAt: DateTime.now(),
        paymentMethod: _selectedPaymentMethod,
        trackingCode: trackingCode,
        deliveryZoneName: cartController.selectedDeliveryZoneName,
        isNew: true,
        isDelivered: false,
      );
      await _saveCustomerDetails();
      final createdOrderId = await orderController.placeOrder(order);

      if (!mounted) return;

      cartController.clearCart();

      if (!mounted) return;

Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => OrderSuccessPage(
      orderId: createdOrderId,
      paymentMethod: _selectedPaymentMethod,
      trackingCode: trackingCode,
      totalAmount: order.total,
      momoNumber: _momoNumber,
      accountName: _accountName,
    ),
  ),
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
    final deliveryZoneController = context.watch<DeliveryZoneController>();
    final deliveryZones = deliveryZoneController.activeZones;
    final items = cartController.items;

    _syncSelectedZoneWithAvailableZones(cartController, deliveryZones);

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
                            _buildCheckoutInfoBanner(
                              isMobile: true,
                              deliveryZones: deliveryZones,
                              cartController: cartController,
                            ),
                            const SizedBox(height: 18),
                            _buildCustomerFormCard(isMobile: true),
                            const SizedBox(height: 18),
                            _buildDeliveryZoneCard(
                              cartController: cartController,
                              deliveryZones: deliveryZones,
                              isMobile: true,
                            ),
                            const SizedBox(height: 18),
                            _buildPaymentMethodCard(isMobile: true),
                            const SizedBox(height: 18),
                            _buildPaymentInstructionCard(cartController, true),
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
                                  _buildCheckoutInfoBanner(
                                    isMobile: false,
                                    deliveryZones: deliveryZones,
                                    cartController: cartController,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildCustomerFormCard(isMobile: false),
                                  const SizedBox(height: 20),
                                  _buildDeliveryZoneCard(
                                    cartController: cartController,
                                    deliveryZones: deliveryZones,
                                    isMobile: false,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildPaymentMethodCard(isMobile: false),
                                  const SizedBox(height: 20),
                                  _buildPaymentInstructionCard(
                                    cartController,
                                    false,
                                  ),
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
            'Fill in your details clearly so DTHC can confirm your order, delivery location, payment path, and final dispatch plan.',
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

  Widget _buildCheckoutInfoBanner({
    required bool isMobile,
    required List<DeliveryZone> deliveryZones,
    required CartController cartController,
  }) {
    final hasZones = deliveryZones.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 18),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: AppColors.primaryBlack,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Payment & Delivery Info',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            hasZones
                ? 'DTHC delivery zones and fees are synced live from admin settings. Choose your zone below and your total will update automatically.'
                : 'There are currently no active delivery zones. You can review delivery information first or contact DTHC before placing this order.',
            style: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 13.5,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _CheckoutActionChip(
                icon: Icons.local_shipping_outlined,
                label: 'View Payment & Delivery',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PaymentDeliveryPage(),
                    ),
                  );
                },
              ),
              if (cartController.hasSelectedDeliveryZone)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlack,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.gold),
                  ),
                  child: Text(
                    '${cartController.selectedDeliveryZoneName} • GHS ${cartController.selectedDeliveryFee.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w800,
                      fontSize: 12.5,
                    ),
                  ),
                ),
            ],
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

  Widget _buildDeliveryZoneCard({
    required CartController cartController,
    required List<DeliveryZone> deliveryZones,
    required bool isMobile,
  }) {
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
                  Icons.local_shipping_outlined,
                  color: AppColors.primaryBlack,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Zone',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Choose one delivery zone. The delivery fee and final total will update immediately.',
                      style: TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (deliveryZones.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryBlack,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.charcoal),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'No active delivery zones are available right now. Please contact DTHC before placing your order.',
                    style: TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _CheckoutActionChip(
                    icon: Icons.open_in_new_rounded,
                    label: 'Open Payment & Delivery Page',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaymentDeliveryPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          else
            ...deliveryZones.map(
              (zone) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _DeliveryZoneTile(
                  zone: zone,
                  isSelected:
                      cartController.selectedDeliveryZone?.id == zone.id,
                  onTap: () {
                    cartController.selectDeliveryZone(zone);
                  },
                ),
              ),
            ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryBlack,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: cartController.hasSelectedDeliveryZone
                    ? AppColors.gold
                    : AppColors.charcoal,
              ),
            ),
            child: Text(
              cartController.hasSelectedDeliveryZone
                  ? 'Selected zone: ${cartController.selectedDeliveryZoneName} • GHS ${cartController.selectedDeliveryFee.toStringAsFixed(2)}'
                  : 'No delivery zone selected yet.',
              style: TextStyle(
                color: cartController.hasSelectedDeliveryZone
                    ? AppColors.gold
                    : const Color(0xFFBDBDBD),
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard({required bool isMobile}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose how the customer will complete payment for this order.',
            style: TextStyle(
              color: Color(0xFFBDBDBD),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          ..._paymentOptions.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PaymentMethodTile(
                title: option.title,
                subtitle: option.subtitle,
                icon: option.icon,
                isSelected: _selectedPaymentMethod == option.title,
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = option.title;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInstructionCard(
    CartController cartController,
    bool isMobile,
  ) {
    final total = cartController.estimatedTotal;

    String title;
    String subtitle;
    IconData icon;
    List<Widget> content;

    if (_selectedPaymentMethod == 'Mobile Money') {
      title = 'Mobile Money Instructions';
      subtitle =
          'After placing the order, send the exact amount to the DTHC MoMo number below and use your tracking code as the payment reference.';
      icon = Icons.phone_android_rounded;
      content = [
        _buildInstructionRow('MoMo Number', _momoNumber),
        const SizedBox(height: 10),
        _buildInstructionRow('Name', _accountName),
        const SizedBox(height: 10),
        _buildInstructionRow(
          'Amount',
          'GHS ${total.toStringAsFixed(2)}',
          highlight: true,
        ),
        const SizedBox(height: 10),
        const _InstructionNote(
          text:
              'Reference: your tracking code will be shown after placing the order.',
        ),
      ];
    } else if (_selectedPaymentMethod == 'Bank Transfer') {
      title = 'Bank Transfer Instructions';
      subtitle =
          'Place the order first, then DTHC can confirm transfer details and expected payment reference before dispatch.';
      icon = Icons.account_balance_rounded;
      content = const [
        _InstructionNote(
          text:
              'This option is for manual confirmation. DTHC will contact you with the final transfer steps after the order is placed.',
        ),
      ];
    } else {
      title = 'Pay on Delivery Notes';
      subtitle =
          'This option is only available where DTHC confirms delivery route, order value, and dispatch conditions first.';
      icon = Icons.local_shipping_outlined;
      content = const [
        _InstructionNote(
          text:
              'Pay on delivery is not guaranteed for every location. DTHC will review the address and confirm availability before dispatch.',
        ),
      ];
    }

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
          Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryBlack,
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
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...content,
        ],
      ),
    );
  }

  Widget _buildInstructionRow(
    String label,
    String value, {
    bool highlight = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight ? AppColors.gold : AppColors.charcoal,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.greyText,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: highlight ? AppColors.gold : AppColors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ],
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
          _buildSelectedZoneSummary(cartController),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: AppColors.charcoal),
          ),
          _summaryTextRow('Payment', _selectedPaymentMethod),
          const SizedBox(height: 10),
          _summaryTextRow(
            'Delivery Zone',
            cartController.hasSelectedDeliveryZone
                ? cartController.selectedDeliveryZoneName
                : 'Not selected',
          ),
          const SizedBox(height: 10),
          _summaryAmountRow('Subtotal', cartController.subtotal),
          const SizedBox(height: 10),
          _summaryAmountRow('Delivery Fee', _resolveDeliveryFee(cartController)),
          const SizedBox(height: 10),
          _summaryAmountRow(
            'Estimated Total',
            cartController.estimatedTotal,
            isBold: true,
          ),
          const SizedBox(height: 10),
          Text(
            cartController.deliveryNote,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: Color(0xFFBDBDBD),
              fontWeight: FontWeight.w500,
            ),
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
                  : Text(
                      _selectedPaymentMethod == 'Pay on Delivery'
                          ? 'Place Order for Confirmation'
                          : 'Place Order & View Payment Instructions',
                      style: const TextStyle(
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

  Widget _buildSelectedZoneSummary(CartController cartController) {
    if (!cartController.hasSelectedDeliveryZone) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primaryBlack,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.charcoal),
        ),
        child: const Text(
          'Select a delivery zone to apply the correct delivery fee before placing your order.',
          style: TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 13,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selected Delivery Zone',
            style: TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            cartController.selectedDeliveryZoneName,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Delivery fee: GHS ${cartController.selectedDeliveryFee.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
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
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
              fontSize: isBold ? 18 : 14,
              color: isBold ? AppColors.gold : AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _InstructionNote extends StatelessWidget {
  final String text;

  const _InstructionNote({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFBDBDBD),
          fontSize: 13,
          height: 1.55,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _DeliveryZoneTile extends StatelessWidget {
  final DeliveryZone zone;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeliveryZoneTile({
    required this.zone,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlack : AppColors.softBlack,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.charcoal,
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.gold
                    : AppColors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.location_on_outlined,
                color: isSelected ? AppColors.primaryBlack : AppColors.white,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zone.name,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Delivery fee: GHS ${zone.fee.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.gold : AppColors.greyText,
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderPlacedDialog extends StatelessWidget {
  final String paymentMethod;
  final String trackingCode;
  final double totalAmount;
  final String momoNumber;
  final String accountName;

  const _OrderPlacedDialog({
    required this.paymentMethod,
    required this.trackingCode,
    required this.totalAmount,
    required this.momoNumber,
    required this.accountName,
  });

  void _copy(BuildContext context, String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    const whatsappNumber = '233534206256';

    final message = '''
Hello DTHC, I have placed an order.

Payment Method: $paymentMethod
Tracking Code: $trackingCode
Amount: GHS ${totalAmount.toStringAsFixed(2)}

I have made payment / I am about to complete payment.
''';

    final encodedMessage = Uri.encodeComponent(message);
    final uri = Uri.parse('https://wa.me/$whatsappNumber?text=$encodedMessage');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open WhatsApp.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;

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
      content: SizedBox(
        width: isMobile ? double.maxFinite : 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your order has been placed successfully. DTHC will review the order and use the details below for payment confirmation and delivery follow-up.',
                style: TextStyle(
                  color: Color(0xFFBDBDBD),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlack,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.charcoal),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Method: $paymentMethod',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tracking Code: $trackingCode',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Amount: GHS ${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _CopyChip(
                    label: 'Copy Tracking Code',
                    onTap: () => _copy(context, trackingCode, 'Tracking code'),
                  ),
                  _CopyChip(
                    label: 'Copy Amount',
                    onTap: () => _copy(
                      context,
                      totalAmount.toStringAsFixed(2),
                      'Amount',
                    ),
                  ),
                ],
              ),
              if (paymentMethod == 'Mobile Money') ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlack,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.gold),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mobile Money Payment Details',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'MoMo Number: $momoNumber',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Name: $accountName',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Use this reference: $trackingCode',
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _CopyChip(
                            label: 'Copy MoMo Number',
                            onTap: () =>
                                _copy(context, momoNumber, 'MoMo number'),
                          ),
                          _CopyChip(
                            label: 'Copy Name',
                            onTap: () =>
                                _copy(context, accountName, 'Account name'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else if (paymentMethod == 'Bank Transfer') ...[
                const SizedBox(height: 14),
                const _InstructionNote(
                  text:
                      'DTHC will contact you with the transfer details and confirmation steps for this order.',
                ),
              ] else ...[
                const SizedBox(height: 14),
                const _InstructionNote(
                  text:
                      'DTHC will confirm whether pay on delivery is available for your location before dispatch.',
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _openWhatsApp(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.primaryBlack,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.chat_outlined),
                  label: const Text(
                    'Send Payment Update on WhatsApp',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'OK',
            style: TextStyle(color: AppColors.gold),
          ),
        ),
      ],
    );
  }
}

class _CopyChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _CopyChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryBlack,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.charcoal),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.copy_rounded,
              size: 16,
              color: AppColors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CheckoutActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryBlack,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.charcoal),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodOption {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PaymentMethodOption({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _PaymentMethodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlack : AppColors.softBlack,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.charcoal,
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.gold
                    : AppColors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primaryBlack : AppColors.white,
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
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.gold : AppColors.greyText,
            ),
          ],
        ),
      ),
    );
  }
}