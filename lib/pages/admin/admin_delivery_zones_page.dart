import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../data/delivery_zone_controller.dart';
import '../../models/delivery_zone.dart';

class AdminDeliveryZonesPage extends StatelessWidget {
  const AdminDeliveryZonesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DeliveryZoneController>();
    final zones = controller.zones;
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlack,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.white,
        title: const Text(
          'Delivery Zones',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showZoneDialog(context);
        },
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.primaryBlack,
        label: const Text(
          'Add Zone',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        icon: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isMobile ? 16 : 24,
          12,
          isMobile ? 16 : 24,
          100,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderCard(
                  totalZones: zones.length,
                  activeZones: controller.activeZones.length,
                  isMobile: isMobile,
                ),
                const SizedBox(height: 20),
                if (zones.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.softBlack,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.charcoal),
                    ),
                    child: const Text(
                      'No delivery zones added yet.',
                      style: TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  ...zones.map(
                    (zone) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _ZoneCard(zone: zone),
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

class _HeaderCard extends StatelessWidget {
  final int totalZones;
  final int activeZones;
  final bool isMobile;

  const _HeaderCard({
    required this.totalZones,
    required this.activeZones,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF0E0E0E),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.charcoal),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeaderText(),
                const SizedBox(height: 18),
                _HeaderStat(
                  totalZones: totalZones,
                  activeZones: activeZones,
                ),
              ],
            )
          : Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: _HeaderText(),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: _HeaderStat(
                    totalZones: totalZones,
                    activeZones: activeZones,
                  ),
                ),
              ],
            ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage delivery areas and pricing from one premium control panel.',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Add, edit, activate, deactivate, and remove delivery zones anytime. Customers will only see active zones during checkout.',
          style: TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 15,
            height: 1.65,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final int totalZones;
  final int activeZones;

  const _HeaderStat({
    required this.totalZones,
    required this.activeZones,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$activeZones / $totalZones',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Active / total zones',
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 13,
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

class _ZoneCard extends StatelessWidget {
  final DeliveryZone zone;

  const _ZoneCard({
    required this.zone,
  });

  Future<void> _confirmDelete(BuildContext context) async {
    final controller = context.read<DeliveryZoneController>();

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.softBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete zone?',
            style: TextStyle(color: AppColors.white),
          ),
          content: Text(
            'Delete "${zone.name}" from delivery zones?',
            style: const TextStyle(color: Color(0xFFBDBDBD)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.white),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Delete',
                style: TextStyle(color: AppColors.gold),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await controller.deleteZone(zone.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.softBlack,
            content: Text('Deleted "${zone.name}".'),
          ),
        );
      }
    }
  }

  Future<void> _toggleActive(BuildContext context, bool value) async {
    final controller = context.read<DeliveryZoneController>();

    await controller.setZoneActiveStatus(
      id: zone.id,
      isActive: value,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.softBlack,
          content: Text(
            value
                ? '"${zone.name}" is now active.'
                : '"${zone.name}" is now inactive.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.charcoal),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ZoneInfo(zone: zone),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Text(
                      'Active',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Switch(
                      value: zone.isActive,
                      activeThumbColor: AppColors.gold,
                      onChanged: (value) => _toggleActive(context, value),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _ZoneActions(
                  onEdit: () => _showZoneDialog(context, existingZone: zone),
                  onDelete: () => _confirmDelete(context),
                  isMobile: true,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: _ZoneInfo(zone: zone)),
                const SizedBox(width: 16),
                SizedBox(
                  width: 150,
                  child: Row(
                    children: [
                      const Text(
                        'Active',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Switch(
                        value: zone.isActive,
                        activeThumbColor: AppColors.gold,
                        onChanged: (value) => _toggleActive(context, value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 260,
                  child: _ZoneActions(
                    onEdit: () => _showZoneDialog(context, existingZone: zone),
                    onDelete: () => _confirmDelete(context),
                    isMobile: false,
                  ),
                ),
              ],
            ),
    );
  }
}

class _ZoneInfo extends StatelessWidget {
  final DeliveryZone zone;

  const _ZoneInfo({
    required this.zone,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 58,
          width: 58,
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.22),
            ),
          ),
          child: const Icon(
            Icons.location_on_outlined,
            color: AppColors.gold,
            size: 30,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                zone.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Delivery Fee: GHS ${zone.fee.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                zone.isActive ? 'Status: Active' : 'Status: Inactive',
                style: TextStyle(
                  color: zone.isActive
                      ? const Color(0xFF86EFAC)
                      : const Color(0xFFFCA5A5),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ZoneActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isMobile;

  const _ZoneActions({
    required this.onEdit,
    required this.onDelete,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onEdit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.primaryBlack,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.edit_outlined),
              label: const Text(
                'Edit Zone',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onDelete,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.white,
                side: const BorderSide(color: AppColors.charcoal),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.delete_outline),
              label: const Text(
                'Delete Zone',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onEdit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.primaryBlack,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.edit_outlined),
            label: const Text(
              'Edit',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onDelete,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.white,
              side: const BorderSide(color: AppColors.charcoal),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.delete_outline),
            label: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> _showZoneDialog(
  BuildContext context, {
  DeliveryZone? existingZone,
}) async {
  final controller = context.read<DeliveryZoneController>();
  final isEditing = existingZone != null;

  final nameController = TextEditingController(
    text: existingZone?.name ?? '',
  );
  final feeController = TextEditingController(
    text: existingZone != null ? existingZone.fee.toStringAsFixed(0) : '',
  );
  bool isActive = existingZone?.isActive ?? true;
  bool isSaving = false;
  String? errorText;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> saveZone() async {
            final name = nameController.text.trim();
            final feeText = feeController.text.trim();
            final fee = double.tryParse(feeText);

            if (name.isEmpty) {
              setState(() {
                errorText = 'Enter a delivery zone name.';
              });
              return;
            }

            if (fee == null || fee < 0) {
              setState(() {
                errorText = 'Enter a valid delivery fee.';
              });
              return;
            }

            setState(() {
              errorText = null;
              isSaving = true;
            });

            try {
              if (isEditing) {
                await controller.updateZone(
                  id: existingZone.id,
                  name: name,
                  fee: fee,
                  isActive: isActive,
                );
              } else {
                await controller.addZone(
                  name: name,
                  fee: fee,
                  isActive: isActive,
                );
              }

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.softBlack,
                    content: Text(
                      isEditing
                          ? 'Delivery zone updated.'
                          : 'Delivery zone added.',
                    ),
                  ),
                );
              }
            } catch (_) {
              setState(() {
                errorText =
                    'Something went wrong while saving the delivery zone.';
                isSaving = false;
              });
            }
          }

          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.softBlack,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.charcoal),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEditing ? 'Edit Delivery Zone' : 'Add Delivery Zone',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Set the zone name, delivery fee, and whether customers can currently select it during checkout.',
                    style: TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 14,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _DialogInputField(
                    controller: nameController,
                    label: 'Zone Name',
                    hintText: 'e.g. East Legon',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  _DialogInputField(
                    controller: feeController,
                    label: 'Delivery Fee (GHS)',
                    hintText: 'e.g. 20',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlack,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.charcoal),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Zone is active',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Switch(
                          value: isActive,
                          activeThumbColor: AppColors.gold,
                          onChanged: (value) {
                            setState(() {
                              isActive = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (errorText != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      errorText!,
                      style: const TextStyle(
                        color: Color(0xFFD66B6B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isSaving
                              ? null
                              : () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.white,
                            side: const BorderSide(color: AppColors.charcoal),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
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
                          onPressed: isSaving ? null : saveZone,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.primaryBlack,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: isSaving
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: AppColors.primaryBlack,
                                  ),
                                )
                              : Text(
                                  isEditing ? 'Save Changes' : 'Add Zone',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _DialogInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const _DialogInputField({
    required this.controller,
    required this.label,
    required this.hintText,
    this.keyboardType,
    this.textInputAction,
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
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF7C7C7C)),
            filled: true,
            fillColor: AppColors.primaryBlack,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.charcoal),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.gold),
            ),
          ),
        ),
      ],
    );
  }
}