import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/medicine_order_model.dart';
import '../utils/file_validator.dart';
import 'dart:io';

class MedicineService {
  final SupabaseClient _supabase = SupabaseClientConfig.client;

  Future<String?> uploadPrescription(File file, String patientId) async {
    // Validate file before upload
    final validationError = FileValidator.validatePdf(file);
    if (validationError != null) {
      throw Exception(validationError);
    }

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.pdf';
      final path = '$patientId/$fileName';
      
      await _supabase.storage
          .from('prescriptions')
          .upload(path, file);
          
      return path;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createMedicineOrder(MedicineOrderModel order) async {
    // 1. Create a primary record in bookings architecture
    final bookingData = {
      'patient_id': order.patientId,
      'service_type': 'medicine',
      'test_or_package': 'Medicine Delivery',
      'scheduled_time': order.createdAt.toUtc().toIso8601String(),
      'status': 'pending',
      'created_at': order.createdAt.toUtc().toIso8601String(),
    };
    await _supabase.from('bookings').insert(bookingData);

    // 2. Create the specialized medicine order record
    final response = await _supabase
        .from('medicine_orders')
        .insert(order.toJson())
        .select()
        .single();
    return response['id'];
  }

  Future<List<MedicineOrderModel>> getMyOrders(String patientId) async {
    final response = await _supabase
        .from('medicine_orders')
        .select()
        .eq('patient_id', patientId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => MedicineOrderModel.fromJson(e)).toList();
  }
}
