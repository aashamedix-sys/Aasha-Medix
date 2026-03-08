import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/booking_model.dart';

class BookingService {
  final SupabaseClient _supabase = SupabaseClientConfig.client;

  Future<String> createBooking(BookingModel booking) async {
    final data = booking.toJson();
    data.remove('id'); // Let Supabase Postgres generate the real UUID
    // Supabase will automatically return inserted rows if you call .select()
    final response = await _supabase.from('bookings').insert(data).select().single();
    return response['id'];
  }

  Future<List<BookingModel>> fetchUserBookings(String patientId, {int limit = 20, int offset = 0}) async {
    final response = await _supabase
        .from('bookings')
        .select()
        .eq('patient_id', patientId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List).map((e) => BookingModel.fromJson(e)).toList();
  }

  Future<void> updateBookingStatus(String bookingId, BookingStatus status) async {
    final Map<String, dynamic> updateData = {'status': status.name == 'inProgress' ? 'in_progress' : status.name};
    
    // Automatically set timing milestones based on status transition
    final now = DateTime.now().toIso8601String();
    if (status == BookingStatus.assigned) {
      updateData['assigned_at'] = now;
    } else if (status == BookingStatus.inProgress) {
      updateData['service_started_at'] = now;
    } else if (status == BookingStatus.completed) {
      updateData['service_completed_at'] = now;
    }

    await _supabase
        .from('bookings')
        .update(updateData)
        .eq('id', bookingId);
  }

  Future<void> markReportUploaded(String bookingId) async {
    await _supabase
        .from('bookings')
        .update({'report_uploaded_at': DateTime.now().toIso8601String()})
        .eq('id', bookingId);
  }
}
