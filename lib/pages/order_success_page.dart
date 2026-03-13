import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/app_colors.dart';
import 'home_page.dart';
import 'track_order_page.dart';
import 'upload_payment_proof_page.dart';

class OrderSuccessPage extends StatelessWidget {
  final String orderId;
  final String trackingCode;
  final String paymentMethod;
  final double totalAmount;
  final String momoNumber;
  final String accountName;

  const OrderSuccessPage({
    super.key,
    required this.orderId,
    required this.trackingCode,
    required this.paymentMethod,
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

Tracking Code: $trackingCode
Payment Method: $paymentMethod
Amount: GHS ${totalAmount.toStringAsFixed(2)}

I have completed payment / I am about to complete payment.
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
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.softBlack,
        foregroundColor: AppColors.white,
        title: const Text(
          'Order Confirmed',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: isMobile ? 18 : 28,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: isMobile ? 90 : 100,
                    width: isMobile ? 90 : 100,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: AppColors.primaryBlack,
                      size: isMobile ? 54 : 60,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Order Confirmed',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: isMobile ? 28 : 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your order has been successfully placed.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isMobile ? 18 : 22),
                    decoration: BoxDecoration(
                      color: AppColors.softBlack,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.charcoal),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 18,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tracking Code',
                          style: TextStyle(
                            color: Color(0xFFBDBDBD),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          trackingCode,
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _CopyChip(
                              label: 'Copy Tracking Code',
                              onTap: () => _copy(
                                context,
                                trackingCode,
                                'Tracking code',
                              ),
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
                        const SizedBox(height: 20),
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
                              Text(
                                'Payment Method: $paymentMethod',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Amount: GHS ${totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (paymentMethod == 'Mobile Money') ...[
                          const SizedBox(height: 20),
                          const Divider(color: AppColors.charcoal),
                          const SizedBox(height: 14),
                          const Text(
                            'Mobile Money Payment Details',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _InfoCardRow(
                            label: 'MoMo Number',
                            value: momoNumber,
                            highlight: true,
                          ),
                          const SizedBox(height: 10),
                          _InfoCardRow(
                            label: 'Name',
                            value: accountName,
                          ),
                          const SizedBox(height: 10),
                          _InfoCardRow(
                            label: 'Reference',
                            value: trackingCode,
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _CopyChip(
                                label: 'Copy MoMo Number',
                                onTap: () => _copy(
                                  context,
                                  momoNumber,
                                  'MoMo number',
                                ),
                              ),
                              _CopyChip(
                                label: 'Copy Name',
                                onTap: () => _copy(
                                  context,
                                  accountName,
                                  'Account name',
                                ),
                              ),
                              _CopyChip(
                                label: 'Copy Reference',
                                onTap: () => _copy(
                                  context,
                                  trackingCode,
                                  'Reference',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Use your tracking code as the payment reference when sending payment.',
                            style: TextStyle(
                              color: Color(0xFFBDBDBD),
                              fontSize: 13,
                              height: 1.55,
                            ),
                          ),
                        ] else if (paymentMethod == 'Bank Transfer') ...[
                          const SizedBox(height: 20),
                          const Divider(color: AppColors.charcoal),
                          const SizedBox(height: 14),
                          const Text(
                            'Bank Transfer',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'DTHC will contact you with the transfer details and confirmation steps for this order.',
                            style: TextStyle(
                              color: Color(0xFFBDBDBD),
                              fontSize: 13,
                              height: 1.55,
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 20),
                          const Divider(color: AppColors.charcoal),
                          const SizedBox(height: 14),
                          const Text(
                            'Pay on Delivery',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'DTHC will confirm whether pay on delivery is available for your location before dispatch.',
                            style: TextStyle(
                              color: Color(0xFFBDBDBD),
                              fontSize: 13,
                              height: 1.55,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UploadPaymentProofPage(
                              orderId: orderId,
                              trackingCode: trackingCode,
                              paymentMethod: paymentMethod,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.primaryBlack,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.upload_file_outlined),
                      label: const Text(
                        'Upload Payment Proof',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openWhatsApp(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: AppColors.primaryBlack,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TrackOrderPage(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.gold,
                        side: const BorderSide(color: AppColors.gold),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Track Order',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomePage(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(color: AppColors.white),
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
}

class _InfoCardRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _InfoCardRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight ? AppColors.gold : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFBDBDBD),
                fontSize: 13,
                fontWeight: FontWeight.w700,
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
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
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