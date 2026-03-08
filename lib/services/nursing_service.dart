import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/nursing_request_model.dart';

class NursingService {
  final SupabaseClient _supabase = SupabaseClientConfig.client;

  Future<String> createNursingRequest(String bookingId, String careType) async {
    final response = await _supabase
        .from('nursing_requests')
        .insert({
          'booking_id': bookingId,
          'care_type': careType,
        })
        .select()
        .single();
    return response['id'];
  }

  Future<List<NursingRequestModel>> getMyNursingRequests(String patientId) async {
    // We join with bookings table to ensure the patient_id matches
    final response = await _supabase
        .from('nursing_requests')
        .select('*, bookings!inner(patient_id)')
        .eq('bookings.patient_id', patientId)
        .order('id', ascending: false);

    return (response as List).map((e) {
      // Clean up the joined booking data if necessary before parsing
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
