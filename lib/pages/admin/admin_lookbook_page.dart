import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../data/store_controller.dart';
import '../../widgets/admin_image_upload_field.dart';
import '../../widgets/store_image.dart';

class AdminLookbookPage extends StatelessWidget {
  const AdminLookbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StoreController>();
    final entries = controller.getLookbookEntries();
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryBlack,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lookbook Manager',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Manage editorial looks and CTA routing',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () => _openEditor(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.primaryBlack,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Add Lookbook',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isMobile ? 16 : 24,
          12,
          isMobile ? 16 : 24,
          28,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LookbookHero(isMobile: isMobile, totalEntries: entries.length),
                const SizedBox(height: 24),
                if (entries.isEmpty)
                  _EmptyLookbookState(
                    onAddTap: () => _openEditor(context),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: entries.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 1 : 2,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                      childAspectRatio: isMobile ? 1.08 : 1.34,
                    ),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return _LookbookEntryCard(
                        entry: entry,
                        onEdit: () => _openEditor(context, entry: entry),
                        onDelete: () => _confirmDelete(
                          context,
                          entryId: (entry['id'] ?? '').toString(),
                          title: (entry['title'] ?? '').toString(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openEditor(BuildContext context, {Map<String, dynamic>? entry}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _LookbookEditorPage(entry: entry),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context, {
    required String entryId,
    required String title,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.softBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete Lookbook Entry',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "$title"?',
            style: const TextStyle(
              color: Color(0xFFBDBDBD),
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<StoreController>().deleteLookbookEntry(entryId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class _LookbookHero extends StatelessWidget {
  final bool isMobile;
  final int totalEntries;

  const _LookbookHero({
    required this.isMobile,
    required this.totalEntries,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF0E0E0E),
          ],
        ),
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
                const Text(
                  'Control your lookbook visuals without breaking the public page.',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Add mood-based entries, edit CTA links, and keep the editorial side of the DTHC storefront clean and premium.',
                  style: TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 15,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 18),
                _HeroChip(
                  label: '$totalEntries entries',
                  icon: Icons.photo_library_outlined,
                ),
              ],
            )
          : Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Control your lookbook visuals without breaking the public page.',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Add mood-based entries, edit CTA links, and keep the editorial side of the DTHC storefront clean and premium.',
                        style: TextStyle(
                          color: Color(0xFFBDBDBD),
                          fontSize: 15,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                _HeroChip(
                  label: '$totalEntries entries',
                  icon: Icons.photo_library_outlined,
                ),
              ],
            ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _HeroChip({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryBlack),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primaryBlack,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyLookbookState extends StatelessWidget {
  final VoidCallback onAddTap;

  const _EmptyLookbookState({
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Column(
        children: [
          Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              color: AppColors.gold,
              size: 34,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'No lookbook entries yet',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Start by adding your first editorial entry with image, title, tag, CTA text, and target routing.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 14,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: onAddTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.primaryBlack,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Add Lookbook Entry',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _LookbookEntryCard extends StatelessWidget {
  final Map<String, dynamic> entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _LookbookEntryCard({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = (entry['imageUrl'] ?? '').toString();
    final title = (entry['title'] ?? '').toString();
    final subtitle = (entry['subtitle'] ?? '').toString();
    final tag = (entry['tag'] ?? '').toString();
    final ctaText = (entry['ctaText'] ?? '').toString();
    final targetType = (entry['targetType'] ?? '').toString();
    final targetValue = (entry['targetValue'] ?? '').toString();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.softBlack,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.charcoal),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  StoreImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: Container(
                      color: AppColors.charcoal,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.broken_image_outlined,
                        color: AppColors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlack.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.charcoal),
                      ),
                      child: Text(
                        tag.isEmpty ? 'No Tag' : tag,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isEmpty ? 'Untitled Lookbook Entry' : title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle.isEmpty ? 'No subtitle added.' : subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetaPill(label: 'CTA: ${ctaText.isEmpty ? 'None' : ctaText}'),
                    _MetaPill(
                      label:
                          'Target: ${targetType.isEmpty ? 'none' : '$targetType / $targetValue'}',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onEdit,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.white,
                          side: const BorderSide(color: AppColors.charcoal),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Edit',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onDelete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final String label;

  const _MetaPill({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryBlack,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.charcoal),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LookbookEditorPage extends StatefulWidget {
  final Map<String, dynamic>? entry;

  const _LookbookEditorPage({
    this.entry,
  });

  @override
  State<_LookbookEditorPage> createState() => _LookbookEditorPageState();
}

class _LookbookEditorPageState extends State<_LookbookEditorPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _imageUrlController;
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late final TextEditingController _tagController;
  late final TextEditingController _ctaTextController;
  late final TextEditingController _targetValueController;

  late String _targetType;

  bool get isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    _imageUrlController = TextEditingController(
      text: (widget.entry?['imageUrl'] ?? '').toString(),
    );
    _titleController = TextEditingController(
      text: (widget.entry?['title'] ?? '').toString(),
    );
    _subtitleController = TextEditingController(
      text: (widget.entry?['subtitle'] ?? '').toString(),
    );
    _tagController = TextEditingController(
      text: (widget.entry?['tag'] ?? '').toString(),
    );
    _ctaTextController = TextEditingController(
      text: (widget.entry?['ctaText'] ?? '').toString(),
    );
    _targetValueController = TextEditingController(
      text: (widget.entry?['targetValue'] ?? '').toString(),
    );
    _targetType = (widget.entry?['targetType'] ?? 'collection').toString();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    _tagController.dispose();
    _ctaTextController.dispose();
    _targetValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryBlack,
        surfaceTintColor: Colors.transparent,
        title: Text(
          isEditing ? 'Edit Lookbook Entry' : 'Add Lookbook Entry',
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isMobile ? 16 : 24,
          16,
          isMobile ? 16 : 24,
          28,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Container(
              padding: EdgeInsets.all(isMobile ? 18 : 24),
              decoration: BoxDecoration(
                color: AppColors.softBlack,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppColors.charcoal),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AdminImageUploadField(
                      controller: _imageUrlController,
                      storageFolder: 'lookbook',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Image URL is required';
                        }
                        return null;
                      },
                      style: const TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                        labelStyle: const TextStyle(color: AppColors.greyText),
                        filled: true,
                        fillColor: AppColors.primaryBlack,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.charcoal),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.charcoal),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.gold),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.danger),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.danger),
                        ),
                      ),
                      buttonForegroundColor: AppColors.gold,
                      helperText:
                          'Paste an image URL or upload a lookbook image from your device.',
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _titleController,
                      label: 'Title',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _subtitleController,
                      label: 'Subtitle',
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Subtitle is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _tagController,
                      label: 'Tag',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Tag is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _ctaTextController,
                      label: 'CTA Text',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'CTA text is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: _targetType,
                      dropdownColor: AppColors.softBlack,
                      style: const TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        labelText: 'Target Type',
                        labelStyle: const TextStyle(color: AppColors.greyText),
                        filled: true,
                        fillColor: AppColors.primaryBlack,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.charcoal,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.charcoal,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.gold,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'collection',
                          child: Text('Collection'),
                        ),
                        DropdownMenuItem(
                          value: 'category',
                          child: Text('Category'),
                        ),
                        DropdownMenuItem(
                          value: 'product',
                          child: Text('Product'),
                        ),
                        DropdownMenuItem(
                          value: 'none',
                          child: Text('None'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _targetType = value ?? 'collection';
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _targetValueController,
                      label: 'Target Value',
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          foregroundColor: AppColors.primaryBlack,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          isEditing ? 'Save Changes' : 'Add Lookbook Entry',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.greyText),
        filled: true,
        fillColor: AppColors.primaryBlack,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.charcoal),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.charcoal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.gold),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final controller = context.read<StoreController>();

    final data = <String, dynamic>{
      'id': isEditing
          ? (widget.entry!['id'] ?? '').toString()
          : 'lb_${DateTime.now().millisecondsSinceEpoch}',
      'title': _titleController.text.trim(),
      'subtitle': _subtitleController.text.trim(),
      'imageUrl': _imageUrlController.text.trim(),
      'tag': _tagController.text.trim(),
      'ctaText': _ctaTextController.text.trim(),
      'targetType': _targetType,
      'targetValue': _targetValueController.text.trim(),
    };

    if (isEditing) {
      controller.updateLookbookEntry(
        (widget.entry!['id'] ?? '').toString(),
        data,
      );
    } else {
      controller.addLookbookEntry(data);
    }

    Navigator.pop(context);
  }
}
