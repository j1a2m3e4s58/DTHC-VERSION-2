import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/store_controller.dart';
import '../../models/hero_banner_item.dart';
import '../../widgets/admin_image_upload_field.dart';

class AdminHeroPage extends StatefulWidget {
  const AdminHeroPage({super.key});

  @override
  State<AdminHeroPage> createState() => _AdminHeroPageState();
}

class _AdminHeroPageState extends State<AdminHeroPage> {
  final StoreController controller = StoreController();

  late List<HeroBannerItem> heroItems;

  @override
  void initState() {
    super.initState();
    _loadHeroItems();
  }

  void _loadHeroItems() {
    heroItems = controller.getAllHeroBanners();
    setState(() {});
  }

  void _openHeroForm({HeroBannerItem? item}) {
    final titleController = TextEditingController(text: item?.title ?? '');
    final subtitleController =
        TextEditingController(text: item?.subtitle ?? '');
    final imageUrlController =
        TextEditingController(text: item?.imageUrl ?? '');
    final ctaTextController =
        TextEditingController(text: item?.ctaText ?? '');
    final targetProductIdController =
        TextEditingController(text: item?.targetProductId ?? '');
    final sortOrderController = TextEditingController(
      text: (item?.sortOrder ?? heroItems.length + 1).toString(),
    );

    bool isActive = item?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              backgroundColor: AppColors.softBlack,
              title: Text(
                item == null ? 'Add Hero Banner' : 'Edit Hero Banner',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 520,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildField(
                        controller: titleController,
                        label: 'Banner Title',
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: subtitleController,
                        label: 'Banner Subtitle',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      AdminImageUploadField(
                        controller: imageUrlController,
                        storageFolder: 'hero_banners',
                        decoration: _inputDecoration('Banner Image URL'),
                        style: const TextStyle(color: AppColors.white),
                        buttonForegroundColor: AppColors.gold,
                        helperText:
                            'Paste a banner image URL or upload a banner image from your device.',
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: ctaTextController,
                        label: 'CTA Button Text',
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: targetProductIdController,
                        label: 'Target Product ID (optional)',
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: sortOrderController,
                        label: 'Sort Order',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Active',
                          style: TextStyle(color: AppColors.white),
                        ),
                        value: isActive,
                        activeThumbColor: AppColors.gold,
                        onChanged: (value) {
                          dialogSetState(() {
                            isActive = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    titleController.dispose();
                    subtitleController.dispose();
                    imageUrlController.dispose();
                    ctaTextController.dispose();
                    targetProductIdController.dispose();
                    sortOrderController.dispose();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.primaryBlack,
                  ),
                  onPressed: () {
                    final title = titleController.text.trim();
                    final subtitle = subtitleController.text.trim();
                    final imageUrl = imageUrlController.text.trim();
                    final ctaText = ctaTextController.text.trim();
                    final targetProductId =
                        targetProductIdController.text.trim();
                    final sortOrder =
                        int.tryParse(sortOrderController.text.trim()) ?? 0;

                    if (title.isEmpty ||
                        subtitle.isEmpty ||
                        imageUrl.isEmpty ||
                        ctaText.isEmpty ||
                        sortOrder <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill all required hero banner fields correctly.',
                          ),
                        ),
                      );
                      return;
                    }

                    final heroItem = HeroBannerItem(
                      id: item?.id ??
                          'hero_${DateTime.now().millisecondsSinceEpoch}',
                      title: title,
                      subtitle: subtitle,
                      imageUrl: imageUrl,
                      ctaText: ctaText,
                      targetProductId: targetProductId,
                      isActive: isActive,
                      sortOrder: sortOrder,
                    );

                    if (item == null) {
                      controller.addHeroBanner(heroItem);
                    } else {
                      controller.updateHeroBanner(item.id, heroItem);
                    }

                    titleController.dispose();
                    subtitleController.dispose();
                    imageUrlController.dispose();
                    ctaTextController.dispose();
                    targetProductIdController.dispose();
                    sortOrderController.dispose();

                    Navigator.pop(context);
                    _loadHeroItems();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          item == null
                              ? 'Hero banner added successfully.'
                              : 'Hero banner updated successfully.',
                        ),
                      ),
                    );
                  },
                  child: Text(item == null ? 'Add Banner' : 'Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteHeroItem(String id) {
    controller.deleteHeroBanner(id);
    _loadHeroItems();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hero banner deleted.')),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFFBDBDBD)),
      filled: true,
      fillColor: AppColors.primaryBlack,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.charcoal),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.charcoal),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.gold),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.white),
      decoration: _inputDecoration(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.softBlack,
        foregroundColor: AppColors.white,
        title: const Text(
          'Admin Hero Manager',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.primaryBlack,
              ),
              onPressed: () => _openHeroForm(),
              icon: const Icon(Icons.add),
              label: const Text('Add Banner'),
            ),
          ),
        ],
      ),
      body: heroItems.isEmpty
          ? const Center(
              child: Text(
                'No hero banners yet. Add your first banner.',
                style: TextStyle(color: AppColors.white),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: isMobile
                  ? ListView.builder(
                      itemCount: heroItems.length,
                      itemBuilder: (context, index) {
                        final item = heroItems[index];
                        return _HeroAdminCard(
                          item: item,
                          onEdit: () => _openHeroForm(item: item),
                          onDelete: () => _deleteHeroItem(item.id),
                        );
                      },
                    )
                  : GridView.builder(
                      itemCount: heroItems.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.9,
                      ),
                      itemBuilder: (context, index) {
                        final item = heroItems[index];
                        return _HeroAdminCard(
                          item: item,
                          onEdit: () => _openHeroForm(item: item),
                          onDelete: () => _deleteHeroItem(item.id),
                        );
                      },
                    ),
            ),
    );
  }
}

class _HeroAdminCard extends StatelessWidget {
  final HeroBannerItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _HeroAdminCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.softBlack,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.charcoal),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item.imageUrl.trim().isNotEmpty
                  ? Image.network(
                      item.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 100,
                          color: AppColors.charcoal,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_outlined,
                            size: 32,
                            color: AppColors.gold,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: AppColors.charcoal,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_outlined,
                        size: 32,
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
                    item.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFFBDBDBD)),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _chip(item.ctaText),
                      _chip('Sort: ${item.sortOrder}'),
                      _chip(item.isActive ? 'Active' : 'Inactive'),
                      if (item.targetProductId.isNotEmpty)
                        _chip('Target: ${item.targetProductId}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: AppColors.gold),
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: AppColors.white),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Chip(
      backgroundColor: AppColors.primaryBlack,
      side: const BorderSide(color: AppColors.charcoal),
      label: Text(
        text,
        style: const TextStyle(color: AppColors.white),
      ),
    );
  }
}
