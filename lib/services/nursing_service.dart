import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/nursing_request_model.dart';
import '../models/nurse_model.dart';

class NursingService {
  final SupabaseClient _supabase = SupabaseClientConfig.client;

  Future<List<NurseModel>> getAvailableNurses() async {
    final response = await _supabase
        .from('nurses')
        .select()
        .eq('is_active', true);
    
    return (response as List).map((e) => NurseModel.fromJson(e)).toList();
  }

  Future<String> bookNursingVisit({
    required String careType,
    required DateTime scheduledDate,
    required String scheduledTime,
    String? address,
    String? notes,
    double? totalAmount,
  }) async {
    final patientId = _supabase.auth.currentUser?.id;
    if (patientId == null) throw Exception('User not authenticated');

    // 1. Insert into bookings table
    final bookingData = {
      'patient_id': patientId,
      'service_type': 'nursing',
      'test_or_package': careType,
      'scheduled_time': scheduledDate.toUtc().toIso8601String(),
      'status': 'pending',
      'created_at': DateTime.now().toUtc().toIso8601String(),
      'notes': notes,
      if (address != null) 'address': address,
      if (totalAmount != null) 'total_amount': totalAmount,
    };

    final bookingResponse = await _supabase
        .from('bookings')
        .insert(bookingData)
        .select()
        .single();

    final bookingId = bookingResponse['id'];

    // 2. Insert into nursing_requests table
    await _supabase
        .from('nursing_requests')
        .insert({
          'booking_id': bookingId,
          'care_type': careType,
          'scheduled_at': scheduledDate.toUtc().toIso8601String(),
          'visit_status': 'pending',
        });

    return bookingId;
  }

  Future<void> assignNurse(String requestId, String nurseId) async {
    await _supabase
        .from('nursing_requests')
        .update({
          'assigned_nurse_id': nurseId,
          'visit_status': 'assigned',
        })
        .eq('id', requestId);
  }

  Future<List<NursingRequestModel>> getRequestsForNurse(String nurseId) async {
    final response = await _supabase
        .from('nursing_requests')
        .select('*, bookings!inner(patient_id)')
        .eq('assigned_nurse_id', nurseId)
        .order('scheduled_at', ascending: true);

    return (response as List).map((e) => NursingRequestModel.fromJson(e)).toList();
  }

  Future<List<NursingRequestModel>> getMyNursingRequests(String patientId) async {
    // We join with bookings table to ensure the patient_id matches
    final response = await _supabase
        .from('nursing_requests')
        .select('*, bookings!inner(patient_id)')
        .eq('bookings.patient_id', patientId)
        .order('id', ascending: false);

    return (response as List).map((e) {
      return NursingRequestModel.fromJson(e);
    }).toList();
  }

  Future<void> markVisitCompleted(String requestId, String notes) async {
    await _supabase
        .from('nursing_requests')
        .update({
          'visit_notes': notes,
          'visit_status': 'completed',
          'completed_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId);
  }
}

