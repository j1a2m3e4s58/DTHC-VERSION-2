class DeliveryZone {
  final String id;
  final String name;
  final double fee;
  final bool isActive;

  const DeliveryZone({
    required this.id,
    required this.name,
    required this.fee,
    this.isActive = true,
  });

  factory DeliveryZone.fromMap(String id, Map<String, dynamic> map) {
    return DeliveryZone(
      id: id,
      name: (map['name'] ?? '').toString(),
      fee: _parseFee(map['fee']),
      isActive: map['isActive'] is bool ? map['isActive'] as bool : true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'fee': fee,
      'isActive': isActive,
    };
  }

  DeliveryZone copyWith({
    String? id,
    String? name,
    double? fee,
    bool? isActive,
  }) {
    return DeliveryZone(
      id: id ?? this.id,
      name: name ?? this.name,
      fee: fee ?? this.fee,
      isActive: isActive ?? this.isActive,
    );
  }

  static double _parseFee(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}