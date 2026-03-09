import 'order_item.dart';

class CustomerOrder {
  final String id;
  final String customerName;
  final String phoneNumber;
  final String address;
  final String note;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final DateTime createdAt;
  bool isNew;
  bool isDelivered;

  CustomerOrder({
    required this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.address,
    required this.note,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.createdAt,
    this.isNew = true,
    this.isDelivered = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'address': address,
      'note': note,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'isNew': isNew,
      'isDelivered': isDelivered,
    };
  }

  factory CustomerOrder.fromMap(Map<dynamic, dynamic> map) {
    final rawItems = map['items'];

    List<OrderItem> parsedItems = [];

    if (rawItems is List) {
      parsedItems = rawItems
          .where((item) => item != null)
          .map((item) => OrderItem.fromMap(Map<dynamic, dynamic>.from(item)))
          .toList();
    } else if (rawItems is Map) {
      parsedItems = rawItems.values
          .where((item) => item != null)
          .map((item) => OrderItem.fromMap(Map<dynamic, dynamic>.from(item)))
          .toList();
    }

    return CustomerOrder(
      id: (map['id'] ?? '').toString(),
      customerName: (map['customerName'] ?? '').toString(),
      phoneNumber: (map['phoneNumber'] ?? '').toString(),
      address: (map['address'] ?? '').toString(),
      note: (map['note'] ?? '').toString(),
      items: parsedItems,
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      deliveryFee: (map['deliveryFee'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
      createdAt: DateTime.tryParse((map['createdAt'] ?? '').toString()) ??
          DateTime.now(),
      isNew: (map['isNew'] ?? true) as bool,
      isDelivered: (map['isDelivered'] ?? false) as bool,
    );
  }
}