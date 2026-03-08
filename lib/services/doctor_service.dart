import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/doctor_model.dart';

class DoctorService {
  final SupabaseClient _supabase = SupabaseClientConfig.client;

  Future<List<DoctorModel>> getAvailableDoctors({int limit = 50}) async {
    final response = await _supabase
        .from('doctors')
        .select()
        .eq('is_available', true)
        .order('name', ascending: true)
        .limit(limit);
        
    return (response as List).map((e) => DoctorModel.fromJson(e)).toList();
  }

  Future<DoctorModel?> getDoctorById(String doctorId) async {
    try {
      final response = await _supabase
          .from('doctors')
          .select()
          .eq('id', doctorId)
          .single();
      return DoctorModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getConsultationSlots(String doctorId, DateTime date) async {
    // Start of day and end of day in UTC to query the timestamptz column
    final DateTime startOfDay = DateTime(date.year, date.month, date.day);
    final DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    final response = await _supabase
        .from('consultation_slots')
        .select()
        .eq('doctor_id', doctorId)
        .eq('is_booked', false)
        .gte('slot_time', startOfDay.toUtc().toIso8601String())
        .lt('slot_time', endOfDay.toUtc().toIso8601String())
        .order('slot_time', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<String> bookConsultation({
    required String doctorId,
    required String slotId,
    required DateTime appointmentDate,
    required String appointmentTime,
    String? testOrPackage,
    String? notes,
    String? address,
    double? totalAmount,
  }) async {
    final patientId = _supabase.auth.currentUser?.id;
    if (patientId == null) throw Exception('User not authenticated');

    // 1. Insert into bookings table
    final bookingData = {
      'patient_id': patientId,
      'service_type': 'doctor',
      'test_or_package': testOrPackage ?? 'Doctor Consultation',
      'scheduled_time': appointmentDate.toUtc().toIso8601String(), // appointment_date combined
      'status': 'pending', // booking_status
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

    // 2. Mark the consultation slot as booked
    await _supabase
        .from('consultation_slots')
        .update({
          'is_booked': true,
          'booking_id': bookingId,
        })
        .eq('id', slotId);

    // Also store a reference under doctor_bookings just as a join detail if needed, but per prompt:
    // "Do NOT use the doctor_bookings table... Do not create or depend on a doctor_bookings table."
    // We only write to bookings and consultation_slots.

    return bookingId;
  }
}
