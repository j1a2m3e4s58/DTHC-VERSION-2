import '../models/category_item.dart';
import '../models/food_item.dart';
import '../models/store_settings.dart';

class MockStoreData {
  static StoreSettings storeSettings = const StoreSettings(
    storeName: 'SuperFoods Kitchen & Bakery',
    tagline: 'Fresh Meals • Fast Delivery • Daily Specials',
    phoneNumber: '0543290967',
    email: 'hello@superfoods.com',
    address: 'Accra, Ghana',
    logoUrl: '',
    heroTitle:
        'Fresh meals, snacks, and special packs made for fast daily ordering.',
    heroSubtitle:
        'SuperFoods Kitchen & Bakery helps customers order jollof rice, fried rice, grilled chicken, pastries, fresh juice, and daily special packs through a clean, colorful, and modern interface.',
    announcementText: 'Free delivery on selected areas today.',
    deliveryFee: 10.0,
    minimumOrderAmount: 30.0,
  );

  static List<CategoryItem> categories = const [
    CategoryItem(
      id: 'all',
      name: 'All Items',
      icon: 'grid',
      isActive: true,
      sortOrder: 0,
    ),
    CategoryItem(
      id: 'rice_meals',
      name: 'Rice Meals',
      icon: 'rice',
      isActive: true,
      sortOrder: 1,
    ),
    CategoryItem(
      id: 'snacks',
      name: 'Snacks',
      icon: 'snack',
      isActive: true,
      sortOrder: 2,
    ),
    CategoryItem(
      id: 'drinks',
      name: 'Drinks',
      icon: 'drink',
      isActive: true,
      sortOrder: 3,
    ),
    CategoryItem(
      id: 'special_packs',
      name: 'Special Packs',
      icon: 'offer',
      isActive: true,
      sortOrder: 4,
    ),
    CategoryItem(
      id: 'bakery',
      name: 'Bakery',
      icon: 'bakery',
      isActive: true,
      sortOrder: 5,
    ),
  ];

  static List<FoodItem> foodItems = [
    const FoodItem(
      id: '1',
      name: 'Jollof Rice + Chicken',
      description: 'Hot rice meal served with grilled chicken and rich flavor.',
      price: 35,
      category: 'Rice Meals',
      imageUrl:
          'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=1200&q=80',
      isAvailable: true,
      isFeatured: true,
      stockQuantity: 25,
    ),
    const FoodItem(
      id: '2',
      name: 'Fried Rice Special',
      description:
          'Freshly prepared fried rice with chicken for everyday enjoyment.',
      price: 40,
      category: 'Rice Meals',
      imageUrl:
          'https://images.unsplash.com/photo-1515003197210-e0cd71810b5f?auto=format&fit=crop&w=1200&q=80',
      isAvailable: true,
      isFeatured: true,
      stockQuantity: 18,
    ),
    const FoodItem(
      id: '3',
      name: 'Fresh Juice',
      description: 'Watermelon, pineapple, and ginger blends served cold.',
      price: 15,
      category: 'Drinks',
      imageUrl:
          'https://images.unsplash.com/photo-1544145945-f90425340c7e?auto=format&fit=crop&w=1200&q=80',
      isAvailable: true,
      isFeatured: true,
      stockQuantity: 40,
    ),
    const FoodItem(
      id: '4',
      name: 'Meat Pie',
      description: 'Golden baked snack with tasty filling and soft crust.',
      price: 12,
      category: 'Bakery',
      imageUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=1200&q=80',
      isAvailable: true,
      isFeatured: true,
      stockQuantity: 30,
    ),
    const FoodItem(
      id: '5',
      name: 'Spring Rolls',
      description: 'Crispy snack rolls perfect for quick bites and sides.',
      price: 10,
      category: 'Snacks',
      imageUrl:
          'data:image/jpeg;base64,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',
      isAvailable: true,
      isFeatured: false,
      stockQuantity: 50,
    ),
    const FoodItem(
      id: '6',
      name: 'Joy Pack',
      description:
          'Rice, grilled chicken, juice, snack, popcorn, and gifts.',
      price: 100,
      category: 'Special Packs',
      imageUrl:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1200&q=80',
      isAvailable: true,
      isFeatured: true,
      stockQuantity: 10,
    ),
    const FoodItem(
      id: '7',
      name: 'Friend’s Pack',
      description:
          'Two rice packs, grilled chicken, juices, snacks, and gifts.',
      price: 250,
      category: 'Special Packs',
      imageUrl:
          'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=1200&q=80',
      isAvailable: true,
      isFeatured: false,
      stockQuantity: 6,
    ),
        const FoodItem(
      id: '8',
      name: 'Chicken Burger Deluxe',
      description: 'Juicy chicken burger with lettuce, cheese, and fresh sauce.',
      price: 32,
      category: 'Snacks',
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=1200&q=80',
      isAvailable: true,
      isFeatured: true,
      stockQuantity: 20,
    ),
  ];
}