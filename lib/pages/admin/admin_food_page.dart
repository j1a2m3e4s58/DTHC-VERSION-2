import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/store_controller.dart';
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
    final nameController = TextEditingController(text: product?.name ?? '');
    final descriptionController =
        TextEditingController(text: product?.description ?? '');
    final priceController =
        TextEditingController(text: product?.price.toString() ?? '');
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
                  ),
                );
              });
            }

            return AlertDialog(
              backgroundColor: AppColors.softBlack,
              title: Text(
                product == null ? 'Add Product' : 'Edit Product',
                style: const TextStyle(
                  color: AppColors.white,
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
                      DropdownButtonFormField<String>(
                        initialValue: selectedCategory,
                        dropdownColor: AppColors.softBlack,
                        style: const TextStyle(color: AppColors.white),
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
                        dropdownColor: AppColors.softBlack,
                        style: const TextStyle(color: AppColors.white),
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
                          const Expanded(
                            child: Text(
                              'Image Entries',
                              style: TextStyle(
                                color: AppColors.white,
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
                            color: AppColors.primaryBlack,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.charcoal),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Entry ${index + 1}',
                                    style: const TextStyle(
                                      color: AppColors.white,
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
                                        color: AppColors.white,
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
                            ],
                          ),
                        );
                      }),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Available',
                          style: TextStyle(color: AppColors.white),
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
                        title: const Text(
                          'Featured',
                          style: TextStyle(color: AppColors.white),
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
                        title: const Text(
                          'New Arrival',
                          style: TextStyle(color: AppColors.white),
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
                        title: const Text(
                          'Best Seller',
                          style: TextStyle(color: AppColors.white),
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

                      if (imageUrl.isEmpty ||
                          entryTitle.isEmpty ||
                          entryDescription.isEmpty ||
                          entryPrice <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Each image entry must have image URL, title, description, and valid price.',
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
                        ),
                      );
                    }

                    if (name.isEmpty ||
                        description.isEmpty ||
                        price <= 0 ||
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
          'Admin Product Manager',
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
              onPressed: () => _openProductForm(),
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
            ),
          ),
        ],
      ),
      body: products.isEmpty
          ? const Center(
              child: Text(
                'No products yet. Add your first product.',
                style: TextStyle(color: AppColors.white),
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

  _ImageEntryFormGroup({
    required this.imageUrlController,
    required this.titleController,
    required this.descriptionController,
    required this.priceController,
  });

  void dispose() {
    imageUrlController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
  }
}

class _ProductAdminCard extends StatelessWidget {
  final ProductItem product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductAdminCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final primaryEntry = product.primaryImageEntry;
    final image = primaryEntry.imageUrl.trim();

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
                          color: AppColors.charcoal,
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
                      color: AppColors.charcoal,
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
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
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
                    style: const TextStyle(color: Color(0xFFBDBDBD)),
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