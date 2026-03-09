import 'package:flutter/material.dart';

import '../../data/store_controller.dart';
import '../../models/food_item.dart';

class AdminFoodPage extends StatefulWidget {
  const AdminFoodPage({super.key});

  @override
  State<AdminFoodPage> createState() => _AdminFoodPageState();
}

class _AdminFoodPageState extends State<AdminFoodPage> {
  final StoreController controller = StoreController();

  late List<FoodItem> foods;

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  void _loadFoods() {
    foods = controller.getAllFoods();
    setState(() {});
  }

  void _openFoodForm({FoodItem? food}) {
    final nameController = TextEditingController(text: food?.name ?? '');
    final descriptionController =
        TextEditingController(text: food?.description ?? '');
    final priceController =
        TextEditingController(text: food?.price.toString() ?? '');
    final imageUrlController =
        TextEditingController(text: food?.imageUrl ?? '');
    final stockController =
        TextEditingController(text: food?.stockQuantity.toString() ?? '');

    String selectedCategory = food?.category ?? StoreController.menuCategories[1];
    bool isAvailable = food?.isAvailable ?? true;
    bool isFeatured = food?.isFeatured ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: Text(food == null ? 'Add Food Item' : 'Edit Food Item'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 420,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Food Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
  initialValue: selectedCategory,
  items: StoreController.menuCategories
      .where((category) => category != 'All Items')
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
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: stockController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Stock Quantity',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: imageUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Image URL',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Available'),
                        value: isAvailable,
                        onChanged: (value) {
                          dialogSetState(() {
                            isAvailable = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Featured'),
                        value: isFeatured,
                        onChanged: (value) {
                          dialogSetState(() {
                            isFeatured = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final description = descriptionController.text.trim();
                    final imageUrl = imageUrlController.text.trim();
                    final price =
                        double.tryParse(priceController.text.trim()) ?? 0;
                    final stock =
                        int.tryParse(stockController.text.trim()) ?? 0;

                    if (name.isEmpty ||
                        description.isEmpty ||
                        price <= 0 ||
                        stock < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all fields correctly.'),
                        ),
                      );
                      return;
                    }

                    final item = FoodItem(
                      id: food?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      description: description,
                      price: price,
                      category: selectedCategory,
                      imageUrl: imageUrl,
                      isAvailable: isAvailable,
                      isFeatured: isFeatured,
                      stockQuantity: stock,
                    );

                    if (food == null) {
                      controller.addFoodItem(item);
                    } else {
                      controller.updateFoodItem(food.id, item);
                    }

                    Navigator.pop(context);
                    _loadFoods();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          food == null
                              ? 'Food item added successfully.'
                              : 'Food item updated successfully.',
                        ),
                      ),
                    );
                  },
                  child: Text(food == null ? 'Add Food' : 'Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteFood(String id) {
    controller.deleteFoodItem(id);
    _loadFoods();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Food item deleted.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Food Manager'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () => _openFoodForm(),
              icon: const Icon(Icons.add),
              label: const Text('Add Food'),
            ),
          ),
        ],
      ),
      body: foods.isEmpty
          ? const Center(
              child: Text('No food items yet. Add your first food item.'),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: isMobile
                  ? ListView.builder(
                      itemCount: foods.length,
                      itemBuilder: (context, index) {
                        final food = foods[index];
                        return _FoodAdminCard(
                          food: food,
                          onEdit: () => _openFoodForm(food: food),
                          onDelete: () => _deleteFood(food.id),
                        );
                      },
                    )
                  : GridView.builder(
                      itemCount: foods.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 2.2,
                      ),
                      itemBuilder: (context, index) {
                        final food = foods[index];
                        return _FoodAdminCard(
                          food: food,
                          onEdit: () => _openFoodForm(food: food),
                          onDelete: () => _deleteFood(food.id),
                        );
                      },
                    ),
            ),
    );
  }
}

class _FoodAdminCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FoodAdminCard({
    required this.food,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final image = food.imageUrl.trim();

    return Card(
      elevation: 3,
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
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Icon(Icons.fastfood, size: 32),
                        );
                      },
                    )
                  : Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.fastfood, size: 32),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    food.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(label: Text(food.category)),
                      Chip(label: Text('GHS ${food.price.toStringAsFixed(2)}')),
                      Chip(label: Text('Stock: ${food.stockQuantity}')),
                      Chip(
                        label: Text(
                          food.isAvailable ? 'Available' : 'Unavailable',
                        ),
                      ),
                      if (food.isFeatured) const Chip(label: Text('Featured')),
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
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}