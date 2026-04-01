import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../models/delivery_zone.dart';

class DeliveryZoneController extends ChangeNotifier {
  DatabaseReference? _zonesRef;

  final List<DeliveryZone> _zones = [];
  StreamSubscription<DatabaseEvent>? _zonesSubscription;

  final bool enableSync;

  DeliveryZoneController({this.enableSync = true}) {
    if (enableSync) {
      _zonesRef = FirebaseDatabase.instance.ref('deliveryZones');
      _listenToZones();
    }
  }

  List<DeliveryZone> get zones => List.unmodifiable(_zones);

  List<DeliveryZone> get activeZones =>
      _zones.where((zone) => zone.isActive).toList();

  bool get hasZones => _zones.isNotEmpty;

  void _listenToZones() {
    final zonesRef = _zonesRef;
    if (zonesRef == null) return;

    _zonesSubscription = zonesRef.onValue.listen((event) {
      final data = event.snapshot.value;
      final List<DeliveryZone> loadedZones = [];

      if (data is Map) {
        data.forEach((key, value) {
          if (value is Map) {
            final map = Map<String, dynamic>.from(
              value.map((k, v) => MapEntry(k.toString(), v)),
            );

            loadedZones.add(
              DeliveryZone.fromMap(
                key.toString(),
                map,
              ),
            );
          }
        });
      }

      loadedZones.sort((a, b) => a.name.toLowerCase().compareTo(
            b.name.toLowerCase(),
          ));

      _zones
        ..clear()
        ..addAll(loadedZones);

      notifyListeners();
    });
  }

  DeliveryZone? getZoneById(String id) {
    try {
      return _zones.firstWhere((zone) => zone.id == id);
    } catch (_) {
      return null;
    }
  }

  DeliveryZone? getZoneByName(String name) {
    try {
      return _zones.firstWhere(
        (zone) => zone.name.trim().toLowerCase() == name.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> addZone({
    required String name,
    required double fee,
    bool isActive = true,
  }) async {
    if (_zonesRef == null) return;
    final newRef = _zonesRef!.push();

    final zone = DeliveryZone(
      id: newRef.key ?? '',
      name: name.trim(),
      fee: fee,
      isActive: isActive,
    );

    await newRef.set(zone.toMap());
  }

  Future<void> updateZone({
    required String id,
    required String name,
    required double fee,
    bool? isActive,
  }) async {
    final Map<String, dynamic> updates = {
      'name': name.trim(),
      'fee': fee,
    };

    if (isActive != null) {
      updates['isActive'] = isActive;
    }

    if (_zonesRef == null) return;
    await _zonesRef!.child(id).update(updates);
  }

  Future<void> deleteZone(String id) async {
    if (_zonesRef == null) return;
    await _zonesRef!.child(id).remove();
  }

  Future<void> setZoneActiveStatus({
    required String id,
    required bool isActive,
  }) async {
    if (_zonesRef == null) return;
    await _zonesRef!.child(id).update({
      'isActive': isActive,
    });
  }

  @override
  void dispose() {
    _zonesSubscription?.cancel();
    super.dispose();
  }
}
