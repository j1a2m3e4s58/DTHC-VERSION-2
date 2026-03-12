import '../models/category_item.dart';
import '../models/food_item.dart';
import '../models/food_pack.dart';
import '../models/hero_banner_item.dart';
import '../models/store_settings.dart';
import '../models/delivery_zone.dart';

class MockStoreData {
  static StoreSettings storeSettings = const StoreSettings(
    storeName: 'Drip Too Hard Collections',
    tagline: 'Streetwear • Premium Fits • Ghana Delivery',
    phoneNumber: '0534206256',
    email: 'hello@dthc.com',
    address: 'Accra, Ghana',
    logoUrl: '',
    heroTitle: 'Streetwear That Speaks Before You Do',
    heroSubtitle:
        'Shop premium tees, sneakers, caps, chains, belts, and socks built for bold fits and everyday drip.',
    announcementText: 'Free delivery in Accra on orders above GHS 300.',
    deliveryFee: 20.0,
    freeDeliveryThreshold: 300.0,
    instagram: '@driptoohardcollections',
    twitter: '@dthcwear',
    tiktok: '@driptoohardcollections',
  );

  static List<HeroBannerItem> heroBanners = const [
    HeroBannerItem(
      id: 'hero_1',
      title: 'Streetwear That Speaks Before You Do',
      subtitle:
          'Premium tees, sneakers, caps, chains, belts, and socks built for bold fits and everyday drip.',
      imageUrl:
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1600&q=80',
      ctaText: 'Shop This Drop',
      targetProductId: '9',
      isActive: true,
      sortOrder: 1,
    ),
    HeroBannerItem(
      id: 'hero_2',
      title: 'Luxury Street Energy',
      subtitle:
          'Curated statement pieces with premium styling, sharp layering, and standout fashion attitude.',
      imageUrl:
          'https://images.unsplash.com/photo-1503341504253-dff4815485f1?auto=format&fit=crop&w=1600&q=80',
      ctaText: 'Explore Collection',
      targetProductId: '2',
      isActive: true,
      sortOrder: 2,
    ),
    HeroBannerItem(
      id: 'hero_3',
      title: 'Built For Motion',
      subtitle:
          'Sneaker-led looks and sharp essentials designed for clean movement and city confidence.',
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1600&q=80',
      ctaText: 'View Sneakers',
      targetProductId: '3',
      isActive: true,
      sortOrder: 3,
    ),
  ];

  static List<CategoryItem> categories = const [
    CategoryItem(
      id: 'all',
      name: 'All',
      icon: 'grid',
      imageUrl:
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=1200&q=80',
      isActive: true,
      sortOrder: 0,
    ),
    CategoryItem(
      id: 'tees',
      name: 'Tees',
      icon: 'shirt',
      imageUrl:
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80',
      isActive: true,
      sortOrder: 1,
    ),
    CategoryItem(
      id: 'sneakers',
      name: 'Sneakers',
      icon: 'shoe',
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80',
      isActive: true,
      sortOrder: 2,
    ),
    CategoryItem(
      id: 'caps',
      name: 'Caps',
      icon: 'cap',
      imageUrl:
          'https://images.unsplash.com/photo-1521369909029-2afed882baee?auto=format&fit=crop&w=1200&q=80',
      isActive: true,
      sortOrder: 3,
    ),
    CategoryItem(
      id: 'chains',
      name: 'Chains',
      icon: 'chain',
      imageUrl:
          'https://images.unsplash.com/photo-1617038220319-276d3cfab638?auto=format&fit=crop&w=1200&q=80',
      isActive: true,
      sortOrder: 4,
    ),
    CategoryItem(
      id: 'belts',
      name: 'Belts',
      icon: 'belt',
      imageUrl:
          'https://images.unsplash.com/photo-1624222247344-550fb60583dc?auto=format&fit=crop&w=1200&q=80',
      isActive: true,
      sortOrder: 5,
    ),
    CategoryItem(
      id: 'socks',
      name: 'Socks',
      icon: 'socks',
      imageUrl:
          'https://images.unsplash.com/photo-1586350977771-b3b0abd50c82?auto=format&fit=crop&w=1200&q=80',
      isActive: true,
      sortOrder: 6,
    ),
  ];

  static List<ProductItem> foodItems = [
    const ProductItem(
      id: '1',
      name: 'DTHC Oversized Logo Tee',
      description:
          'Premium oversized streetwear tee with a bold front logo and soft heavyweight cotton feel.',
      price: 120,
      category: 'Tees',
      imageEntries: [
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80',
          title: 'Oversized Logo Tee - Front Drop',
          description:
              'Heavyweight cotton tee with a bold front-facing DTHC identity and relaxed premium silhouette.',
          price: 120,
        ),
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1503341504253-dff4815485f1?auto=format&fit=crop&w=1200&q=80',
          title: 'Oversized Logo Tee - Street Fit View',
          description:
              'Styled loose for layered city fits with a sharper streetwear attitude.',
          price: 125,
        ),
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1200&q=80',
          title: 'Oversized Logo Tee - Premium Graphic Mood',
          description:
              'Statement-ready version built for standout everyday drip and clean accessories.',
          price: 130,
        ),
      ],
      isAvailable: true,
      isFeatured: true,
      stockQuantity: 25,
      collection: 'Essentials Drop',
      isNewArrival: true,
      isBestSeller: true,
    ),
    const ProductItem(
      id: '2',
      name: 'Midnight Statement Tee',
      description:
          'Clean black tee designed for everyday drip, relaxed fits, and layered streetwear looks.',
      price: 135,
      category: 'Tees',
      imageEntries: [
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1503341504253-dff4815485f1?auto=format&fit=crop&w=1200&q=80',
          title: 'Midnight Statement Tee - Core Black',
          description:
              'A clean black premium tee made for minimal, sharp, night-ready styling.',
          price: 135,
        ),
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=1200&q=80',
          title: 'Midnight Statement Tee - Elevated Layering',
          description:
              'Relaxed streetwear energy for layered fits and understated luxury.',
          price: 140,
        ),
      ],
      isAvailable: true,
      isFeatured: true,
      stockQuantity: 18,
      collection: 'Night Code',
      isNewArrival: true,
      isBestSeller: false,
    ),
    const ProductItem(
      id: '3',
      name: 'DTHC Street Runner Sneakers',
      description:
          'Sharp low-top sneakers built for clean movement, comfort, and standout city style.',
      price: 320,
      category: 'Sneakers',
      imageEntries: [
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80',
          title: 'Street Runner Sneakers - Velocity Red',
          description:
              'Bold low-top sneakers for standout movement, high visibility, and premium street rotation.',
          price: 320,
        ),
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?auto=format&fit=crop&w=1200&q=80',
          title: 'Street Runner Sneakers - Clean Motion White',
          description:
              'A cleaner rotation built for luxury casual fits and smooth everyday wear.',
          price: 335,
        ),
      ],
      isAvailable: true,
      isFeatured: true,
      stockQuantity: 12,
      collection: 'Urban Motion',
      isNewArrival: true,
      isBestSeller: true,
    ),
    const ProductItem(
      id: '4',
      name: 'White Heat Sneakers',
      description:
          'Minimal luxury sneakers with a fresh white finish for premium casual fits.',
      price: 295,
      category: 'Sneakers',
      imageEntries: [
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?auto=format&fit=crop&w=1200&q=80',
          title: 'White Heat Sneakers - Pure White',
          description:
              'Luxury white sneakers with a polished finish for premium casual dressing.',
          price: 295,
        ),
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80',
          title: 'White Heat Sneakers - Contrast Edge',
          description:
              'A more aggressive sneaker mood for street-ready styling and sharper contrast.',
          price: 305,
        ),
      ],
      isAvailable: true,
      isFeatured: true,
      stockQuantity: 10,
      collection: 'Urban Motion',
      isNewArrival: false,
      isBestSeller: true,
    ),
    const ProductItem(
      id: '5',
      name: 'Signature Snapback Cap',
      description:
          'Structured cap with embroidered DTHC identity for everyday streetwear styling.',
      price: 85,
      category: 'Caps',
      imageEntries: [
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1521369909029-2afed882baee?auto=format&fit=crop&w=1200&q=80',
          title: 'Signature Snapback - Core Logo',
          description:
              'A structured logo cap built for everyday premium streetwear fits.',
          price: 85,
        ),
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80',
          title: 'Signature Snapback - Editorial Style',
          description:
              'A more fashion-forward cap mood for elevated styling and clean accessories.',
          price: 90,
        ),
      ],
      isAvailable: true,
      isFeatured: false,
      stockQuantity: 30,
      collection: 'Essentials Drop',
      isNewArrival: false,
      isBestSeller: true,
    ),
    const ProductItem(
      id: '6',
      name: 'Gold Layer Chain',
      description:
          'Fashion chain accessory made to elevate simple tees, open shirts, and clean fit combos.',
      price: 110,
      category: 'Chains',
      imageEntries: [
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1617038220319-276d3cfab638?auto=format&fit=crop&w=1200&q=80',
          title: 'Gold Layer Chain - Hero Shine',
          description:
              'A polished layered chain for premium neckwear styling and clean standout detail.',
          price: 110,
        ),
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=1200&q=80',
          title: 'Gold Layer Chain - Styled Luxury View',
          description:
              'Built to elevate simple tops, open shirts, and upscale streetwear combinations.',
          price: 118,
        ),
      ],
      isAvailable: true,
      isFeatured: true,
      stockQuantity: 20,
      collection: 'Luxury Street',
      isNewArrival: true,
      isBestSeller: false,
    ),
    const ProductItem(
      id: '7',
      name: 'DTHC Leather Belt',
      description:
          'Premium belt piece with a clean buckle finish to complete elevated streetwear looks.',
      price: 95,
      category: 'Belts',
      imageEntries: [
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1624222247344-550fb60583dc?auto=format&fit=crop&w=1200&q=80',
          title: 'Leather Belt - Classic Buckle',
          description:
              'A clean premium leather belt with a refined buckle for polished styling.',
          price: 95,
        ),
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=1200&q=80',
          title: 'Leather Belt - Luxury Street Pairing',
          description:
              'Designed to finish elevated denim, trousers, and upscale streetwear fits.',
          price: 102,
        ),
      ],
      isAvailable: true,
      isFeatured: false,
      stockQuantity: 15,
      collection: 'Luxury Street',
      isNewArrival: false,
      isBestSeller: true,
    ),
    const ProductItem(
      id: '8',
      name: 'Street Essential Socks',
      description:
          'Soft high-rise socks with a clean sporty look for sneakers, shorts, and stacked fits.',
      price: 45,
      category: 'Socks',
      imageEntries: [
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1586350977771-b3b0abd50c82?auto=format&fit=crop&w=1200&q=80',
          title: 'Street Essential Socks - Clean Pair',
          description:
              'Soft sport-inspired socks for low-top sneakers, shorts, and easy daily wear.',
          price: 45,
        ),
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1544441893-675973e31985?auto=format&fit=crop&w=1200&q=80',
          title: 'Street Essential Socks - Stack Fit Edition',
          description:
              'Made for layered sneaker fits and stronger sporty streetwear presentation.',
          price: 50,
        ),
      ],
      isAvailable: true,
      isFeatured: false,
      stockQuantity: 40,
      collection: 'Essentials Drop',
      isNewArrival: true,
      isBestSeller: false,
    ),
    const ProductItem(
      id: '9',
      name: 'Graphic Drop Tee',
      description:
          'Bold graphic tee for statement styling, layered fits, and standout everyday wear.',
      price: 140,
      category: 'Tees',
      imageEntries: [
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1200&q=80',
          title: 'Graphic Drop Tee - Street Poster Look',
          description:
              'A bold visual tee made for statement dressing and louder everyday streetwear.',
          price: 140,
        ),
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80',
          title: 'Graphic Drop Tee - Clean Front Edition',
          description:
              'A slightly cleaner take for balanced styling with caps, chains, and layered pieces.',
          price: 145,
        ),
      ],
      isAvailable: true,
      isFeatured: true,
      stockQuantity: 22,
      collection: 'Street Kings',
      isNewArrival: true,
      isBestSeller: true,
    ),
    const ProductItem(
      id: '10',
      name: 'Luxury Street Cap',
      description:
          'Premium cap with a neat silhouette built for polished casual and urban outfits.',
      price: 90,
      category: 'Caps',
      imageEntries: [
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80',
          title: 'Luxury Street Cap - Polished Fit',
          description:
              'A premium cap silhouette for polished casual wear and urban luxury moods.',
          price: 90,
        ),
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1521369909029-2afed882baee?auto=format&fit=crop&w=1200&q=80',
          title: 'Luxury Street Cap - Everyday Rotation',
          description:
              'A more relaxed daily styling version that still keeps the premium DTHC edge.',
          price: 94,
        ),
      ],
      isAvailable: true,
      isFeatured: true,
      stockQuantity: 16,
      collection: 'Street Kings',
      isNewArrival: false,
      isBestSeller: false,
    ),
    const ProductItem(
      id: '11',
      name: 'After Dark Premium Tee',
      description:
          'Heavy cotton black tee with a strong fit and elevated night-style streetwear energy.',
      price: 145,
      category: 'Tees',
      imageEntries: [
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=1200&q=80',
          title: 'After Dark Premium Tee - Night Mode',
          description:
              'Heavy cotton black tee built for confident night styling and premium energy.',
          price: 145,
        ),
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1503341504253-dff4815485f1?auto=format&fit=crop&w=1200&q=80',
          title: 'After Dark Premium Tee - Relaxed Shadow Fit',
          description:
              'A looser luxury streetwear mood for darker layered rotations.',
          price: 150,
        ),
      ],
      isAvailable: true,
      isFeatured: false,
      stockQuantity: 14,
      collection: 'Night Code',
      isNewArrival: true,
      isBestSeller: false,
    ),
    const ProductItem(
      id: '12',
      name: 'Urban Motion Socks Set',
      description:
          'Sport-inspired fashion socks built to pair well with clean sneaker rotations.',
      price: 55,
      category: 'Socks',
      imageEntries: [
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1544441893-675973e31985?auto=format&fit=crop&w=1200&q=80',
          title: 'Urban Motion Socks Set - Performance Look',
          description:
              'Sport-inspired fashion socks made for cleaner sneaker rotations and movement.',
          price: 55,
        ),
        ProductImageEntry(
          imageUrl:
              'https://images.unsplash.com/photo-1586350977771-b3b0abd50c82?auto=format&fit=crop&w=1200&q=80',
          title: 'Urban Motion Socks Set - Everyday Pair',
          description:
              'A softer daily option for sneakers, shorts, and premium casual layering.',
          price: 60,
        ),
      ],
      isAvailable: true,
      isFeatured: false,
      stockQuantity: 28,
      collection: 'Urban Motion',
      isNewArrival: false,
      isBestSeller: false,
    ),
  ];

  static List<CollectionModel> collections = const [
    CollectionModel(
      id: '1',
      name: 'Essentials Drop',
      description:
          'Clean everyday pieces built for simple, premium streetwear fits.',
      imageUrl:
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80',
      isFeatured: true,
    ),
    CollectionModel(
      id: '2',
      name: 'Street Kings',
      description:
          'Bold statement pieces for confident styling and standout looks.',
      imageUrl:
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1200&q=80',
      isFeatured: true,
    ),
    CollectionModel(
      id: '3',
      name: 'Luxury Street',
      description:
          'Accessories and polished fashion pieces with a premium edge.',
      imageUrl:
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=1200&q=80',
      isFeatured: true,
    ),
    CollectionModel(
      id: '4',
      name: 'Urban Motion',
      description:
          'Sneaker-led styling with movement, comfort, and city confidence.',
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80',
      isFeatured: true,
    ),
    CollectionModel(
      id: '5',
      name: 'Night Code',
      description:
          'Dark premium looks built for after-hours fashion and standout fits.',
      imageUrl:
          'https://images.unsplash.com/photo-1503341504253-dff4815485f1?auto=format&fit=crop&w=1200&q=80',
      isFeatured: false,
    ),
  ];
    static List<DeliveryZone> deliveryZones = [
    const DeliveryZone(
      id: 'zone_1',
      name: 'Accra Central',
      fee: 15,
    ),
    const DeliveryZone(
      id: 'zone_2',
      name: 'East Legon',
      fee: 20,
    ),
    const DeliveryZone(
      id: 'zone_3',
      name: 'Tema',
      fee: 25,
    ),
    const DeliveryZone(
      id: 'zone_4',
      name: 'Kasoa',
      fee: 30,
    ),
  ];
  static List<Map<String, dynamic>> lookbookEntries = [
    {
      'id': 'lb1',
      'title': 'Downtown Layered Fit',
      'subtitle': 'Oversized tee, fitted cap, chain, and low-top sneakers.',
      'imageUrl':
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80',
      'tag': 'City Edit',
      'ctaText': 'Shop This Mood',
      'targetType': 'collection',
      'targetValue': 'Street Kings',
    },
    {
      'id': 'lb2',
      'title': 'After Dark Premium',
      'subtitle': 'Clean black styling with luxury details and bold confidence.',
      'imageUrl':
          'https://images.unsplash.com/photo-1503341504253-dff4815485f1?auto=format&fit=crop&w=1200&q=80',
      'tag': 'Night Code',
      'ctaText': 'Shop Night Code',
      'targetType': 'collection',
      'targetValue': 'Night Code',
    },
    {
      'id': 'lb3',
      'title': 'Weekend Street Rotation',
      'subtitle': 'Easy statement wear for relaxed premium casual styling.',
      'imageUrl':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1200&q=80',
      'tag': 'Weekend Heat',
      'ctaText': 'Shop Featured Tees',
      'targetType': 'category',
      'targetValue': 'Tees',
    },
    {
      'id': 'lb4',
      'title': 'Luxury Street Minimal',
      'subtitle': 'Accessories-first styling with clean premium layering.',
      'imageUrl':
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=1200&q=80',
      'tag': 'Luxury Street',
      'ctaText': 'Shop Luxury Street',
      'targetType': 'collection',
      'targetValue': 'Luxury Street',
    },
    {
      'id': 'lb5',
      'title': 'Sneaker Focused Energy',
      'subtitle': 'Sharp footwear-led fits built for movement and attention.',
      'imageUrl':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80',
      'tag': 'Urban Motion',
      'ctaText': 'Shop Urban Motion',
      'targetType': 'collection',
      'targetValue': 'Urban Motion',
    },
    {
      'id': 'lb6',
      'title': 'Essential Everyday Drip',
      'subtitle': 'Simple premium pieces that still feel bold and elevated.',
      'imageUrl':
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80',
      'tag': 'Essentials',
      'ctaText': 'Shop Essentials Drop',
      'targetType': 'collection',
      'targetValue': 'Essentials Drop',
    },
  ];

  static const List<Map<String, dynamic>> paymentMethods = [
    {
      'title': 'Mobile Money',
      'subtitle':
          'Pay with MTN MoMo and other mobile money options after checkout confirmation.',
      'icon': 'momo',
    },
    {
      'title': 'Card Payment',
      'subtitle':
          'Customers can be guided to pay securely with supported debit or bank cards.',
      'icon': 'card',
    },
    {
      'title': 'Pay on Delivery (Optional)',
      'subtitle':
          'For selected areas, the store can confirm orders first before final payment.',
      'icon': 'delivery',
    },
  ];

  static const List<Map<String, dynamic>> deliverySteps = [
    {
      'title': 'Order Confirmation',
      'subtitle':
          'After checkout, the DTHC team confirms item availability and delivery details.',
    },
    {
      'title': 'Payment Processing',
      'subtitle':
          'Customers complete payment using the agreed payment method before dispatch.',
    },
    {
      'title': 'Dispatch & Delivery',
      'subtitle':
          'Orders are packed and delivered within Accra or sent to other locations in Ghana.',
    },
  ];

  static const List<Map<String, dynamic>> returnExchangeNotes = [
    {
      'title': 'Size Exchange',
      'subtitle':
          'Items can be exchanged for a different size where stock is available.',
    },
    {
      'title': 'Wrong Item Support',
      'subtitle':
          'Customers should report incorrect items quickly for fast support and replacement.',
    },
    {
      'title': 'Condition Requirement',
      'subtitle':
          'Products must remain unused and in good condition for returns or exchanges.',
    },
  ];

  static const List<Map<String, dynamic>> contactChannels = [
    {
      'title': 'Phone',
      'value': '0534206256',
      'subtitle': 'Call for order help, delivery clarification, and quick support.',
      'icon': 'phone',
    },
    {
      'title': 'Email',
      'value': 'hello@dthc.com',
      'subtitle': 'Use email for collaborations, support requests, and inquiries.',
      'icon': 'email',
    },
    {
      'title': 'Instagram',
      'value': '@driptoohardcollections',
      'subtitle': 'Follow the latest drops, fit inspiration, and collection updates.',
      'icon': 'instagram',
    },
    {
      'title': 'TikTok',
      'value': '@driptoohardcollections',
      'subtitle': 'See styling clips, product showcases, and short promo content.',
      'icon': 'tiktok',
    },
  ];

  static List<CollectionModel> getFeaturedCollections() {
    return collections.where((collection) => collection.isFeatured).toList();
  }

  static List<ProductItem> getProductsByCollection(String collectionName) {
    return foodItems
        .where((product) => product.collection == collectionName)
        .toList();
  }
}