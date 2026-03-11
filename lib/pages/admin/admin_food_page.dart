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

    final List<TextEditingController> imageControllers =
        (product?.imageUrls.isNotEmpty ?? false)
            ? product!.imageUrls
                .map((url) => TextEditingController(text: url))
                .toList()
            : [TextEditingController()];

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
                  width: 460,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildField(
                        controller: nameController,
                        label: 'Product Name',
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: descriptionController,
                        label: 'Description',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: priceController,
                        label: 'Price',
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
                      const SizedBox(height: 16),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Product Images',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.gold,
                                side: const BorderSide(
                                  color: AppColors.gold,
                                ),
                              ),
                              onPressed: () {
                                dialogSetState(() {
                                  imageControllers.add(
                                    TextEditingController(),
                                  );
                                });
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add Image'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      ...List.generate(imageControllers.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildField(
                                  controller: imageControllers[index],
                                  label: 'Image URL ${index + 1}',
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (imageControllers.length > 1)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: IconButton(
                                    onPressed: () {
                                      dialogSetState(() {
                                        imageControllers[index].dispose();
                                        imageControllers.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: AppColors.white,
                                    ),
                                    tooltip: 'Remove image',
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 8),
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
                    for (final controller in imageControllers) {
                      controller.dispose();
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

                    final imageUrls = imageControllers
                        .map((controller) => controller.text.trim())
                        .where((url) => url.isNotEmpty)
                        .toList();

                    if (name.isEmpty ||
                        description.isEmpty ||
                        price <= 0 ||
                        stock < 0 ||
                        imageUrls.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill all fields correctly and add at least one image.',
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
                      imageUrls: imageUrls,
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

                    for (final controller in imageControllers) {
                      controller.dispose();
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
    final images = product.imageUrls;
    final image = images.isNotEmpty ? images.first.trim() : '';

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
                  const SizedBox(height: 6),
                  Text(
                    product.description,
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
                      _chip('GHS ${product.price.toStringAsFixed(2)}'),
                      _chip('Stock: ${product.stockQuantity}'),
                      _chip('${product.imageUrls.length} image(s)'),
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