import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/medicine_service.dart';
import '../models/medicine_order_model.dart';
import '../models/booking_model.dart';
import 'dart:io';

class MedicineProvider with ChangeNotifier {
  final MedicineService _service = MedicineService();
  List<MedicineOrderModel> _orders = [];
  bool _isLoading = false;

  List<MedicineOrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> placeOrder({
    required String deliveryAddress,
    File? prescriptionImage,
    List<dynamic> items = const [],
  }) async {
    final User? currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) throw Exception('Not authenticated');

    _isLoading = true;
    notifyListeners();

    try {
      String? prescriptionPath;
      if (prescriptionImage != null) {
        prescriptionPath = await _service.uploadPrescription(prescriptionImage, currentUser.id);
      }

      final order = MedicineOrderModel(
        id: '', // Supabase will generate ID, but model requires it. Send empty or logic to omit in insert.
        patientId: currentUser.id,
        prescriptionUrl: prescriptionPath,
        items: items,
        deliveryAddress: deliveryAddress,
        createdAt: DateTime.now(),
        status: BookingStatus.pending,
      );

      final newId = await _service.createMedicineOrder(order);
      
      _orders.insert(0, MedicineOrderModel(
        id: newId,
        patientId: order.patientId,
        prescriptionUrl: order.prescriptionUrl,
        items: order.items,
        deliveryAddress: order.deliveryAddress,
        createdAt: order.createdAt,
        status: order.status,
      ));

      _isLoading = false;
      notifyListeners();
    } catch(e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchMyOrders() async {
    final User? currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) return;

    _isLoading = true;
    notifyListeners();
    
    try {
      _orders = await _service.getMyOrders(currentUser.id);
      _isLoading = false;
      notifyListeners();
    } catch(e) {
      _isLoading = false;
      notifyListeners();
    }
  }
}
