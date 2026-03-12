import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../models/customer_order.dart';

class OrderController extends ChangeNotifier {
  final DatabaseReference _ordersRef = FirebaseDatabase.instance.ref('orders');

  final List<CustomerOrder> _orders = [];
  StreamSubscription<DatabaseEvent>? _ordersSubscription;

  OrderController() {
    _listenToOrders();
  }

  List<CustomerOrder> get orders => List.unmodifiable(_orders);

  int get totalOrders => _orders.length;

  int get newOrdersCount => _orders.where((order) => order.isNew).length;

  int get deliveredOrdersCount =>
      _orders.where((order) => order.isDelivered).length;

  int get pendingOrdersCount =>
      _orders.where((order) => !order.isDelivered).length;

  int get paidOrdersCount =>
      _orders.where((order) => order.paymentStatus == 'Paid').length;

  int get unpaidOrdersCount =>
      _orders.where((order) => order.paymentStatus != 'Paid').length;

  int get ordersToday {
    final now = DateTime.now();

    return _orders.where((order) {
      final createdAt = order.createdAt;
      return _isSameDate(createdAt, now);
    }).length;
  }

  int get ordersThisWeek {
    final now = DateTime.now();
    final startOfWeek = _startOfWeek(now);
    final startOfNextWeek = startOfWeek.add(const Duration(days: 7));

    return _orders.where((order) {
      final createdAt = order.createdAt;
      return !createdAt.isBefore(startOfWeek) &&
          createdAt.isBefore(startOfNextWeek);
    }).length;
  }

  int get ordersThisMonth {
    final now = DateTime.now();

    return _orders.where((order) {
      final createdAt = order.createdAt;
      return createdAt.year == now.year && createdAt.month == now.month;
    }).length;
  }

  double get totalRevenue => _orders
      .where((order) => order.paymentStatus == 'Paid')
      .fold(0.0, (sum, order) => sum + order.total);

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime _startOfWeek(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final daysFromMonday = normalized.weekday - DateTime.monday;
    return normalized.subtract(Duration(days: daysFromMonday));
  }

  void _listenToOrders() {
    _ordersSubscription = _ordersRef.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data == null) {
        _orders.clear();
        notifyListeners();
        return;
      }

      final Map<dynamic, dynamic> rawMap =
          Map<dynamic, dynamic>.from(data as Map);

      final List<CustomerOrder> loadedOrders = rawMap.entries.map((entry) {
        final value = Map<dynamic, dynamic>.from(entry.value);
        return CustomerOrder.fromMap(value);
      }).toList();

      loadedOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _orders
        ..clear()
        ..addAll(loadedOrders);

      notifyListeners();
    });
  }

  Future<void> placeOrder(CustomerOrder order) async {
    final orderRef = _ordersRef.push();
    final orderId =
        orderRef.key ?? DateTime.now().millisecondsSinceEpoch.toString();

    final firebaseOrder = CustomerOrder(
      id: orderId,
      customerName: order.customerName,
      phoneNumber: order.phoneNumber,
      address: order.address,
      note: order.note,
      items: order.items,
      subtotal: order.subtotal,
      deliveryFee: order.deliveryFee,
      total: order.total,
      createdAt: order.createdAt,
      paymentMethod: order.paymentMethod,
      trackingCode: order.trackingCode,
      paymentStatus: order.paymentStatus,
      paymentProofStatus: order.paymentProofStatus,
      paymentUpdateSent: order.paymentUpdateSent,
      isNew: order.isNew,
      isDelivered: order.isDelivered,
    );

    await orderRef.set(firebaseOrder.toMap());
  }

  Future<void> markAllOrdersAsSeen() async {
    final futures = _orders
        .where((order) => order.isNew)
        .map((order) => _ordersRef.child(order.id).update({'isNew': false}))
        .toList();

    await Future.wait(futures);
  }

  Future<void> toggleDelivered(String orderId) async {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index == -1) return;

    final currentValue = _orders[index].isDelivered;

    await _ordersRef.child(orderId).update({
      'isDelivered': !currentValue,
    });
  }

  Future<void> updatePaymentStatus(String orderId, String paymentStatus) async {
    await _ordersRef.child(orderId).update({
      'paymentStatus': paymentStatus,
    });
  }

  Future<void> updatePaymentProofStatus(
    String orderId,
    String paymentProofStatus,
  ) async {
    await _ordersRef.child(orderId).update({
      'paymentProofStatus': paymentProofStatus,
    });
  }

  Future<void> markPaymentUpdateSent(String orderId, bool sent) async {
    await _ordersRef.child(orderId).update({
      'paymentUpdateSent': sent,
    });
  }

  Future<void> deleteOrder(String orderId) async {
    await _ordersRef.child(orderId).remove();
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    super.dispose();
  }
}