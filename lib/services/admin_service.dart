import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/booking_model.dart';
import '../models/patient_model.dart';
import '../models/nurse_model.dart';
import '../models/doctor_model.dart';

class AdminService {
  final SupabaseClient _supabase = SupabaseClientConfig.client;

  // Bookings Management
  Future<List<Map<String, dynamic>>> fetchAllBookings() async {
    // Joining with patient to display names
    final response = await _supabase
        .from('bookings')
        .select('*, patients(name, phone)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _supabase
        .from('bookings')
        .update({'status': status})
        .eq('id', bookingId);
  }

  // Nurses Management
  Future<List<NurseModel>> fetchAllNurses() async {
    final response = await _supabase.from('nurses').select();
    return (response as List).map((e) => NurseModel.fromJson(e)).toList();
  }
  
  Future<void> assignNurseToRequest(String requestId, String nurseId) async {
    await _supabase
        .from('nursing_requests')
        .update({'nurse_id': nurseId, 'visit_status': 'assigned'})
        .eq('id', requestId);
    
    // Also update associated booking status if applicable
    final request = await _supabase.from('nursing_requests').select('booking_id').eq('id', requestId).single();
    if (request != null && request['booking_id'] != null) {
      await updateBookingStatus(request['booking_id'], 'assigned');
    }
  }

  // Upload Lab Reports
  Future<void> assignReportToPatient(String bookingId, String patientId, String fileUrl) async {
    await _supabase.from('lab_reports').insert({
      'booking_id': bookingId,
      'patient_id': patientId,
      'file_url': fileUrl,
      'uploaded_at': DateTime.now().toIso8601String(),
    });
    // Mark booking as completed when report is uploaded
    await updateBookingStatus(bookingId, 'completed');
  }
}
