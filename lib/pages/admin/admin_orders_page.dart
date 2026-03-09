import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../data/order_controller.dart';
import '../../models/customer_order.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<OrderController>().markAllOrdersAsSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderController = context.watch<OrderController>();
    final allOrders = orderController.orders;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    final deliveredCount =
        allOrders.where((order) => order.isDelivered).length;
    final pendingCount =
        allOrders.where((order) => !order.isDelivered).length;

    final filteredOrders = selectedFilter == 'Pending'
        ? allOrders.where((order) => !order.isDelivered).toList()
        : selectedFilter == 'Delivered'
            ? allOrders.where((order) => order.isDelivered).toList()
            : allOrders;

    return Scaffold(
      backgroundColor: AppColors.softCream,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        elevation: 0,
        title: const Text(
          'Admin Orders',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: allOrders.isEmpty
          ? Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  'No customer orders yet.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greyText,
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: isMobile ? 16 : 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _OrdersTopSummary(
                        totalCount: allOrders.length,
                        pendingCount: pendingCount,
                        deliveredCount: deliveredCount,
                      ),
                      const SizedBox(height: 20),
                      _buildFilterTabs(
                        totalCount: allOrders.length,
                        pendingCount: pendingCount,
                        deliveredCount: deliveredCount,
                      ),
                      const SizedBox(height: 20),
                      if (filteredOrders.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            'No $selectedFilter orders found.',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.greyText,
                            ),
                          ),
                        )
                      else
                        ...filteredOrders.map(
                          (order) => _PremiumOrderCard(order: order),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildFilterTabs({
    required int totalCount,
    required int pendingCount,
    required int deliveredCount,
  }) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _FilterChipButton(
          label: 'All',
          count: totalCount,
          selected: selectedFilter == 'All',
          onTap: () {
            setState(() {
              selectedFilter = 'All';
            });
          },
        ),
        _FilterChipButton(
          label: 'Pending',
          count: pendingCount,
          selected: selectedFilter == 'Pending',
          onTap: () {
            setState(() {
              selectedFilter = 'Pending';
            });
          },
        ),
        _FilterChipButton(
          label: 'Delivered',
          count: deliveredCount,
          selected: selectedFilter == 'Delivered',
          onTap: () {
            setState(() {
              selectedFilter = 'Delivered';
            });
          },
        ),
      ],
    );
  }
}

class _OrdersTopSummary extends StatelessWidget {
  final int totalCount;
  final int pendingCount;
  final int deliveredCount;

  const _OrdersTopSummary({
    required this.totalCount,
    required this.pendingCount,
    required this.deliveredCount,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _TopMetricCard(
                  title: 'Total Orders',
                  value: '$totalCount',
                  icon: Icons.receipt_long,
                  iconColor: AppColors.primaryGreen,
                  iconBackground: AppColors.lightGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TopMetricCard(
                  title: 'Pending',
                  value: '$pendingCount',
                  icon: Icons.access_time,
                  iconColor: AppColors.deepOrange,
                  iconBackground:
                      AppColors.accentGold.withValues(alpha: 0.20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _TopMetricCard(
                  title: 'Delivered',
                  value: '$deliveredCount',
                  icon: Icons.check_circle,
                  iconColor: AppColors.primaryGreen,
                  iconBackground: AppColors.lightGreen,
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _TopMetricCard(
            title: 'Total Orders',
            value: '$totalCount',
            icon: Icons.receipt_long,
            iconColor: AppColors.primaryGreen,
            iconBackground: AppColors.lightGreen,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _TopMetricCard(
            title: 'Pending',
            value: '$pendingCount',
            icon: Icons.access_time,
            iconColor: AppColors.deepOrange,
            iconBackground: AppColors.accentGold.withValues(alpha: 0.20),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _TopMetricCard(
            title: 'Delivered',
            value: '$deliveredCount',
            icon: Icons.check_circle,
            iconColor: AppColors.primaryGreen,
            iconBackground: AppColors.lightGreen,
          ),
        ),
      ],
    );
  }
}

class _TopMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  const _TopMetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.greyText,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.greyText,
                          fontWeight: FontWeight.w600,
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

class _FilterChipButton extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected
        ? (label == 'Delivered'
            ? AppColors.primaryGreen
            : label == 'Pending'
                ? AppColors.deepOrange
                : AppColors.darkGreen)
        : AppColors.white;

    final textColor = selected
        ? AppColors.white
        : (label == 'Delivered'
            ? AppColors.primaryGreen
            : label == 'Pending'
                ? AppColors.deepOrange
                : AppColors.darkGreen);

    final borderColor = label == 'Delivered'
        ? AppColors.primaryGreen.withValues(alpha: 0.30)
        : label == 'Pending'
            ? AppColors.deepOrange.withValues(alpha: 0.30)
            : AppColors.darkGreen.withValues(alpha: 0.20);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.white.withValues(alpha: 0.18)
                    : borderColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumOrderCard extends StatelessWidget {
  final CustomerOrder order;

  const _PremiumOrderCard({
    required this.order,
  });

  String _formatOrderTime(DateTime time) {
    final day = time.day.toString().padLeft(2, '0');
    final month = time.month.toString().padLeft(2, '0');
    final year = time.year.toString();
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$day/$month/$year  $hour:$minute';
  }

  Future<void> _confirmDeleteOrder(
    BuildContext context,
    OrderController orderController,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Delete order?'),
          content: const Text(
            'This will permanently remove this delivered order from Firebase.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await orderController.deleteOrder(order.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Delivered order deleted successfully.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderController = context.read<OrderController>();
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    final Color statusBorder = order.isDelivered
        ? AppColors.primaryGreen.withValues(alpha: 0.40)
        : AppColors.deepOrange.withValues(alpha: 0.28);

    final Color statusBackground = order.isDelivered
        ? const Color(0xFFF1FBF4)
        : const Color(0xFFFFF6EF);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: EdgeInsets.all(isMobile ? 18 : 22),
      decoration: BoxDecoration(
        color: statusBackground,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: statusBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _OrderHeader(
                      order: order,
                      formattedTime: _formatOrderTime(order.createdAt),
                    ),
                    const SizedBox(height: 14),
                    _OrderActions(
                      isDelivered: order.isDelivered,
                      onToggleDelivered: () async {
                        await orderController.toggleDelivered(order.id);
                      },
                      onDeleteOrder: order.isDelivered
                          ? () async {
                              await _confirmDeleteOrder(
                                context,
                                orderController,
                              );
                            }
                          : null,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _OrderHeader(
                        order: order,
                        formattedTime: _formatOrderTime(order.createdAt),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 190,
                      child: _OrderActions(
                        isDelivered: order.isDelivered,
                        onToggleDelivered: () async {
                          await orderController.toggleDelivered(order.id);
                        },
                        onDeleteOrder: order.isDelivered
                            ? () async {
                                await _confirmDeleteOrder(
                                  context,
                                  orderController,
                                );
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 18),
          _InfoSection(
            title: 'Customer Details',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoLine(
                  icon: Icons.person_outline,
                  text: order.customerName,
                ),
                const SizedBox(height: 10),
                _InfoLine(
                  icon: Icons.phone_outlined,
                  text: order.phoneNumber,
                ),
                const SizedBox(height: 10),
                _InfoLine(
                  icon: Icons.location_on_outlined,
                  text: order.address,
                ),
                if (order.note.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _InfoLine(
                    icon: Icons.sticky_note_2_outlined,
                    text: order.note,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          _InfoSection(
            title: 'Ordered Items',
            child: Column(
              children: order.items.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          height: 56,
                          width: 56,
                          color: AppColors.lightGreen,
                          child: item.imageUrl.trim().isNotEmpty
                              ? Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.fastfood_rounded,
                                      color: AppColors.primaryGreen,
                                    );
                                  },
                                )
                              : const Icon(
                                  Icons.fastfood_rounded,
                                  color: AppColors.primaryGreen,
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${item.name} x${item.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'GHS ${item.totalPrice.toStringAsFixed(2)}',
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: order.isDelivered
                    ? AppColors.primaryGreen.withValues(alpha: 0.20)
                    : AppColors.deepOrange.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              children: [
                _AmountRow('Subtotal', order.subtotal),
                const SizedBox(height: 10),
                _AmountRow('Delivery', order.deliveryFee),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                _AmountRow(
                  'Total',
                  order.total,
                  isTotal: true,
                  highlightGreen: order.isDelivered,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderHeader extends StatelessWidget {
  final CustomerOrder order;
  final String formattedTime;

  const _OrderHeader({
    required this.order,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    final statusText = order.isDelivered ? 'DELIVERED' : 'PENDING';
    final statusBg = order.isDelivered
        ? AppColors.lightGreen
        : AppColors.accentGold.withValues(alpha: 0.20);
    final statusTextColor =
        order.isDelivered ? AppColors.primaryGreen : AppColors.deepOrange;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: statusBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            order.isDelivered ? Icons.check_circle : Icons.receipt_long,
            color: statusTextColor,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.customerName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Order time: $formattedTime',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.greyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusText,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: statusTextColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (order.isNew) ...[
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'NEW',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.red.shade900,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderActions extends StatelessWidget {
  final bool isDelivered;
  final Future<void> Function() onToggleDelivered;
  final Future<void> Function()? onDeleteOrder;

  const _OrderActions({
    required this.isDelivered,
    required this.onToggleDelivered,
    this.onDeleteOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            await onToggleDelivered();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isDelivered ? AppColors.deepOrange : AppColors.primaryGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: Icon(
            isDelivered ? Icons.undo : Icons.check_circle_outline,
          ),
          label: Text(
            isDelivered ? 'Mark Pending' : 'Mark Delivered',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        if (onDeleteOrder != null) ...[
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () async {
              await onDeleteOrder!();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              side: BorderSide(color: Colors.red.shade200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.delete_outline),
            label: const Text(
              'Delete Order',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.darkGreen,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primaryGreen),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.black,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;
  final bool highlightGreen;

  const _AmountRow(
    this.label,
    this.value, {
    this.isTotal = false,
    this.highlightGreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final amountColor = isTotal
        ? (highlightGreen ? AppColors.primaryGreen : AppColors.deepOrange)
        : AppColors.black;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 17 : 14,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'GHS ${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
            color: amountColor,
          ),
        ),
      ],
    );
  }
}