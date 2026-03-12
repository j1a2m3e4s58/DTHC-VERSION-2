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
  final String paymentMethod;
  final String trackingCode;
  final String deliveryZoneName;

  final String paymentStatus;
  final String paymentProofStatus;
  final bool paymentUpdateSent;

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
    this.paymentMethod = 'Mobile Money',
    this.trackingCode = '',
    this.deliveryZoneName = '',
    this.paymentStatus = 'Pending',
    this.paymentProofStatus = 'Not Sent',
    this.paymentUpdateSent = false,
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
      'paymentMethod': paymentMethod,
      'trackingCode': trackingCode,
      'deliveryZoneName': deliveryZoneName,
      'paymentStatus': paymentStatus,
      'paymentProofStatus': paymentProofStatus,
      'paymentUpdateSent': paymentUpdateSent,
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
      subtotal: ((map['subtotal'] ?? 0) as num).toDouble(),
      deliveryFee: ((map['deliveryFee'] ?? 0) as num).toDouble(),
      total: ((map['total'] ?? 0) as num).toDouble(),
      createdAt:
          DateTime.tryParse((map['createdAt'] ?? '').toString()) ??
          DateTime.now(),
      paymentMethod: (map['paymentMethod'] ?? 'Mobile Money').toString(),
      trackingCode: (map['trackingCode'] ?? '').toString(),
      deliveryZoneName: (map['deliveryZoneName'] ?? '').toString(),
      paymentStatus: (map['paymentStatus'] ?? 'Pending').toString(),
      paymentProofStatus: (map['paymentProofStatus'] ?? 'Not Sent').toString(),
      paymentUpdateSent: (map['paymentUpdateSent'] ?? false) == true,
      isNew: (map['isNew'] ?? true) == true,
      isDelivered: (map['isDelivered'] ?? false) == true,
    );
  }

  CustomerOrder copyWith({
    String? id,
    String? customerName,
    String? phoneNumber,
    String? address,
    String? note,
    List<OrderItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? total,
    DateTime? createdAt,
    String? paymentMethod,
    String? trackingCode,
    String? deliveryZoneName,
    String? paymentStatus,
    String? paymentProofStatus,
    bool? paymentUpdateSent,
    bool? isNew,
    bool? isDelivered,
  }) {
    return CustomerOrder(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      note: note ?? this.note,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      trackingCode: trackingCode ?? this.trackingCode,
      deliveryZoneName: deliveryZoneName ?? this.deliveryZoneName,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentProofStatus: paymentProofStatus ?? this.paymentProofStatus,
      paymentUpdateSent: paymentUpdateSent ?? this.paymentUpdateSent,
      isNew: isNew ?? this.isNew,
      isDelivered: isDelivered ?? this.isDelivered,
    );
  }

  String generateWhatsAppMessage() {
    final buffer = StringBuffer();

    buffer.writeln('NEW DTHC ORDER');
    buffer.writeln('');
    buffer.writeln('Customer: $customerName');
    buffer.writeln('Phone: $phoneNumber');
    buffer.writeln('Address: $address');

    if (deliveryZoneName.isNotEmpty) {
      buffer.writeln('Delivery Zone: $deliveryZoneName');
    }

    buffer.writeln('');
    buffer.writeln('Items:');
    for (final item in items) {
      buffer.writeln('${item.quantity} × ${item.name}');
    }

    buffer.writeln('');
    buffer.writeln('Total: GHS ${total.toStringAsFixed(2)}');

    if (trackingCode.isNotEmpty) {
      buffer.writeln('Tracking Code: $trackingCode');
    }

    return buffer.toString();
  }
}