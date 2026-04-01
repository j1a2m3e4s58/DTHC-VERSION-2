import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../data/store_controller.dart';
import '../../data/theme_controller.dart';
import '../../models/food_item.dart';

class AdminFoodPage extends StatefulWidget {
  const AdminFoodPage({super.key});

  @override
  State<AdminFoodPage> createState() => _AdminFoodPageState();
}

class _AdminFoodPageState extends State<AdminFoodPage> {
  final StoreController controller = StoreController();

  late List<ProductItem> products;

  static const List<String> _collections = [
    'Essentials Drop',
    'Street Kings',
    'Luxury Street',
    'Urban Motion',
    'Night Code',
    'General Collection',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    products = controller.getAllProducts();
    setState(() {});
  }

  void _openProductForm({ProductItem? product}) {
    final palette =
        AppColors.palette(context.read<ThemeController>().isDarkMode);
    final nameController = TextEditingController(text: product?.name ?? '');
    final descriptionController =
        TextEditingController(text: product?.description ?? '');
    final priceController =
        TextEditingController(text: product?.price.toString() ?? '');
    final oldPriceController = TextEditingController(
      text: product?.oldPrice?.toString() ?? '',
    );
    final dealLabelController =
        TextEditingController(text: product?.dealLabel ?? '');
    final dealEndsAtController =
        TextEditingController(text: product?.dealEndsAt ?? '');
    final stockController =
        TextEditingController(text: product?.stockQuantity.toString() ?? '');

    final List<_ImageEntryFormGroup> imageGroups =
        (product?.imageEntries.isNotEmpty ?? false)
            ? product!.imageEntries
                .map(
                  (entry) => _ImageEntryFormGroup(
                    imageUrlController:
                        TextEditingController(text: entry.imageUrl),
                    titleController: TextEditingController(text: entry.title),
                    descriptionController:
                        TextEditingController(text: entry.description),
                    priceController:
                        TextEditingController(text: entry.price.toString()),
                    oldPriceController:
                        TextEditingController(text: entry.oldPrice?.toString() ?? ''),
                  ),
                )
                .toList()
            : [
                _ImageEntryFormGroup(
                  imageUrlController: TextEditingController(),
                  titleController: TextEditingController(text: product?.name ?? ''),
                  descriptionController:
                      TextEditingController(text: product?.description ?? ''),
                  priceController:
                      TextEditingController(text: product?.price.toString() ?? ''),
                  oldPriceController:
                      TextEditingController(text: product?.oldPrice?.toString() ?? ''),
                ),
              ];

    String selectedCategory =
        product?.category ?? StoreController.shopCategories[1];
    String selectedCollection = product?.collection ?? _collections.first;

    bool isAvailable = product?.isAvailable ?? true;
    bool isFeatured = product?.isFeatured ?? false;
    bool isNewArrival = product?.isNewArrival ?? false;
    bool isBestSeller = product?.isBestSeller ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            void addImageGroup() {
              dialogSetState(() {
                imageGroups.add(
                  _ImageEntryFormGroup(
                    imageUrlController: TextEditingController(),
                    titleController:
                        TextEditingController(text: nameController.text.trim()),
                    descriptionController: TextEditingController(
                      text: descriptionController.text.trim(),
                    ),
                    priceController: TextEditingController(
                      text: priceController.text.trim(),
                    ),
                    oldPriceController: TextEditingController(
                      text: oldPriceController.text.trim(),
                    ),
                  ),
                );
              });
            }

            return AlertDialog(
              backgroundColor: palette.card,
              title: Text(
                product == null ? 'Add Product' : 'Edit Product',
                style: TextStyle(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 560,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildField(
                        controller: nameController,
                        label: 'Base Product Name',
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: descriptionController,
                        label: 'Base Description',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: priceController,
                        label: 'Base Price',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: oldPriceController,
                        label: 'Old Price (optional)',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: dealLabelController,
                        label: 'Deal Label (optional)',
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: dealEndsAtController,
                        label: 'Deal Ends At (YYYY-MM-DDTHH:MM:SS)',
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedCategory,
                        dropdownColor: palette.surface,
                        style: TextStyle(color: palette.textPrimary),
                        items: StoreController.shopCategories
                            .where((category) => category != 'All')
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            dialogSetState(() {
                              selectedCategory = value;
                            });
                          }
                        },
                        decoration: _inputDecoration('Category'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedCollection,
                        dropdownColor: palette.surface,
                        style: TextStyle(color: palette.textPrimary),
                        items: _collections
                            .map(
                              (collection) => DropdownMenuItem(
                                value: collection,
                                child: Text(collection),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            dialogSetState(() {
                              selectedCollection = value;
                            });
                          }
                        },
                        decoration: _inputDecoration('Collection'),
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: stockController,
                        label: 'Stock Quantity',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Image Entries',
                              style: TextStyle(
                                color: palette.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.gold,
                              side: const BorderSide(color: AppColors.gold),
                            ),
                            onPressed: addImageGroup,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Entry'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(imageGroups.length, (index) {
                        final group = imageGroups[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: palette.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: palette.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Entry ${index + 1}',
                                    style: TextStyle(
                                      color: palette.textPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (imageGroups.length > 1)
                                    IconButton(
                                      onPressed: () {
                                        dialogSetState(() {
                                          group.dispose();
                                          imageGroups.removeAt(index);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: AppColors.gold,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildField(
                                controller: group.imageUrlController,
                                label: 'Image URL',
                              ),
                              const SizedBox(height: 10),
                              _buildField(
                                controller: group.titleController,
                                label: 'Image-specific Title',
                              ),
                              const SizedBox(height: 10),
                              _buildField(
                                controller: group.descriptionController,
                                label: 'Image-specific Description',
                                maxLines: 3,
                              ),
                              const SizedBox(height: 10),
                              _buildField(
                                controller: group.priceController,
                                label: 'Image-specific Price',
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildField(
                                controller: group.oldPriceController,
                                label: 'Image-specific Old Price (optional)',
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Available',
                          style: TextStyle(color: palette.textPrimary),
                        ),
                        value: isAvailable,
                        activeThumbColor: AppColors.gold,
                        onChanged: (value) {
                          dialogSetState(() {
                            isAvailable = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Featured',
                          style: TextStyle(color: palette.textPrimary),
                        ),
                        value: isFeatured,
                        activeThumbColor: AppColors.gold,
                        onChanged: (value) {
                          dialogSetState(() {
                            isFeatured = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'New Arrival',
                          style: TextStyle(color: palette.textPrimary),
                        ),
                        value: isNewArrival,
                        activeThumbColor: AppColors.gold,
                        onChanged: (value) {
                          dialogSetState(() {
                            isNewArrival = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Best Seller',
                          style: TextStyle(color: palette.textPrimary),
                        ),
                        value: isBestSeller,
                        activeThumbColor: AppColors.gold,
                        onChanged: (value) {
                          dialogSetState(() {
                            isBestSeller = value;
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
                    nameController.dispose();
                    descriptionController.dispose();
                    priceController.dispose();
                    oldPriceController.dispose();
                    dealLabelController.dispose();
                    dealEndsAtController.dispose();
                    stockController.dispose();
                    for (final group in imageGroups) {
                      group.dispose();
                    }
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
                    final name = nameController.text.trim();
                    final description = descriptionController.text.trim();
                    final price =
                        double.tryParse(priceController.text.trim()) ?? 0;
                    final oldPrice = oldPriceController.text.trim().isEmpty
                        ? null
                        : double.tryParse(oldPriceController.text.trim());
                    final stock =
                        int.tryParse(stockController.text.trim()) ?? 0;

                    final imageEntries = <ProductImageEntry>[];

                    for (final group in imageGroups) {
                      final imageUrl = group.imageUrlController.text.trim();
                      final entryTitle = group.titleController.text.trim();
                      final entryDescription =
                          group.descriptionController.text.trim();
                      final entryPrice =
                          double.tryParse(group.priceController.text.trim()) ?? 0;
                      final entryOldPrice =
                          group.oldPriceController.text.trim().isEmpty
                              ? null
                              : double.tryParse(
                                  group.oldPriceController.text.trim(),
                                );

                      if (imageUrl.isEmpty ||
                          entryTitle.isEmpty ||
                          entryDescription.isEmpty ||
                          entryPrice <= 0 ||
                          (entryOldPrice != null && entryOldPrice <= entryPrice)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Each image entry must have image URL, title, description, valid price, and any old price must be higher than the sale price.',
                            ),
                          ),
                        );
                        return;
                      }

                      imageEntries.add(
                        ProductImageEntry(
                          imageUrl: imageUrl,
                          title: entryTitle,
                          description: entryDescription,
                          price: entryPrice,
                          oldPrice: entryOldPrice,
                        ),
                      );
                    }

                    if (name.isEmpty ||
                        description.isEmpty ||
                        price <= 0 ||
                        (oldPrice != null && oldPrice <= price) ||
                        stock < 0 ||
                        imageEntries.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill all product fields correctly and add at least one image entry.',
                          ),
                        ),
                      );
                      return;
                    }

                    final item = ProductItem(
                      id: product?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      description: description,
                      price: price,
                      category: selectedCategory,
                      imageEntries: imageEntries,
                      oldPrice: oldPrice,
                      dealLabel: dealLabelController.text.trim(),
                      dealEndsAt: dealEndsAtController.text.trim(),
                      isAvailable: isAvailable,
                      isFeatured: isFeatured,
                      stockQuantity: stock,
                      collection: selectedCollection,
                      isNewArrival: isNewArrival,
                      isBestSeller: isBestSeller,
                    );

                    if (product == null) {
                      controller.addProductItem(item);
                    } else {
                      controller.updateProductItem(product.id, item);
                    }

                    nameController.dispose();
                    descriptionController.dispose();
                    priceController.dispose();
                    oldPriceController.dispose();
                    dealLabelController.dispose();
                    dealEndsAtController.dispose();
                    stockController.dispose();
                    for (final group in imageGroups) {
                      group.dispose();
                    }

                    Navigator.pop(context);
                    _loadProducts();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          product == null
                              ? 'Product added successfully.'
                              : 'Product updated successfully.',
                        ),
                      ),
                    );
                  },
                  child: Text(product == null ? 'Add Product' : 'Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteProduct(String id) {
    controller.deleteProductItem(id);
    _loadProducts();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product deleted.')),
    );
  }

  InputDecoration _inputDecoration(String label) {
    final palette = AppColors.palette(context.watch<ThemeController>().isDarkMode);
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: palette.textSecondary),
      filled: true,
      fillColor: palette.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: palette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: palette.border),
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
    final palette = AppColors.palette(context.watch<ThemeController>().isDarkMode);
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: palette.textPrimary),
      decoration: _inputDecoration(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.card,
        foregroundColor: palette.textPrimary,
        title: Text(
          'Admin Product Manager',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.primaryBlack,
              ),
              onPressed: () => _openProductForm(),
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
            ),
          ),
        ],
      ),
      body: products.isEmpty
          ? Center(
              child: Text(
                'No products yet. Add your first product.',
                style: TextStyle(color: palette.textPrimary),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: isMobile
                  ? ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _ProductAdminCard(
                          product: product,
                          onEdit: () => _openProductForm(product: product),
                          onDelete: () => _deleteProduct(product.id),
                          palette: palette,
                        );
                      },
                    )
                  : GridView.builder(
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 2.0,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _ProductAdminCard(
                          product: product,
                          onEdit: () => _openProductForm(product: product),
                          onDelete: () => _deleteProduct(product.id),
                          palette: palette,
                        );
                      },
                    ),
            ),
    );
  }
}

class _ImageEntryFormGroup {
  final TextEditingController imageUrlController;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController oldPriceController;

  _ImageEntryFormGroup({
    required this.imageUrlController,
    required this.titleController,
    required this.descriptionController,
    required this.priceController,
    required this.oldPriceController,
  });

  void dispose() {
    imageUrlController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    oldPriceController.dispose();
  }
}

class _ProductAdminCard extends StatelessWidget {
  final ProductItem product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final AppPalette palette;

  const _ProductAdminCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final primaryEntry = product.primaryImageEntry;
    final image = primaryEntry.imageUrl.trim();

    return Card(
      color: palette.card,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: palette.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image.isNotEmpty
                  ? Image.network(
                      image,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 90,
                          height: 90,
                          color: palette.surfaceAlt,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 32,
                            color: AppColors.gold,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 90,
                      height: 90,
                      color: palette.surfaceAlt,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.shopping_bag_outlined,
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
                    product.name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    primaryEntry.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    primaryEntry.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: palette.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _chip(product.category),
                      _chip(product.collection),
                      _chip('Base GHS ${product.price.toStringAsFixed(2)}'),
                      _chip('Entry GHS ${primaryEntry.price.toStringAsFixed(2)}'),
                      if (product.oldPrice != null)
                        _chip('Old GHS ${product.oldPrice!.toStringAsFixed(2)}'),
                      if (product.dealLabel.trim().isNotEmpty)
                        _chip(product.dealLabel),
                      _chip('Stock: ${product.stockQuantity}'),
                      _chip('${product.imageEntries.length} image entry(s)'),
                      _chip(product.isAvailable ? 'Available' : 'Unavailable'),
                      if (product.isFeatured) _chip('Featured'),
                      if (product.isNewArrival) _chip('New Arrival'),
                      if (product.isBestSeller) _chip('Best Seller'),
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
                  icon: Icon(Icons.delete, color: palette.textPrimary),
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
      backgroundColor: palette.surface,
      side: BorderSide(color: palette.border),
      label: Text(
        text,
        style: TextStyle(color: palette.textPrimary),
      ),
    );
  }
}
