import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/diagnostics_models.dart';
import '../models/booking_model.dart';
import '../core/supabase_client.dart';

// DiagnosticsData static file is DEPRECATED as of v2.1.
// All data must be fetched from Supabase tables: diagnostic_tests, health_packages.
// Do NOT import DiagnosticsData anywhere in the codebase.

class DiagnosticsService {
  final SupabaseClient _client = SupabaseClientConfig.client;

  Future<List<TestItem>> fetchTests() async {
    try {
      final response = await _client
          .from('tests')
          .select()
          .order('testName', ascending: true);

      return (response as List)
          .map((item) => TestItem.fromMap(item))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
          'Supabase query failed [tests]: ${e.message} (code: ${e.code})');
    } catch (e) {
      throw Exception('Unexpected error fetching diagnostic tests: $e');
    }
  }

  Future<List<HealthPackage>> fetchPackages() async {
    try {
      final response = await _client
          .from('health_packages')
          .select()
          .order('packageName', ascending: true);

      return (response as List)
          .map((item) => HealthPackage.fromMap(item))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
          'Supabase query failed [health_packages]: ${e.message} (code: ${e.code})');
    } catch (e) {
      throw Exception('Unexpected error fetching health packages: $e');
    }
  }

  Future<BookingModel> createBooking({
    required ServiceType serviceType,
    required String testOrPackage,
    required DateTime scheduledTime,
    String? address,
    double? totalAmount,
    String? notes,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User must be logged in to create a booking.');
      }

      final response = await _client
          .from('bookings')
          .insert({
            'patient_id': userId,
            'service_type': serviceType == ServiceType.homeSample ? 'home_sample' : 'diagnostics',
            'test_or_package': testOrPackage,
            'scheduled_time': scheduledTime.toUtc().toIso8601String(),
            if (address != null) 'address': address,
            if (totalAmount != null) 'total_amount': totalAmount,
            if (notes != null) 'notes': notes,
            'status': 'pending',
            'payment_status': 'unpaid',
          })
          .select()
          .single();

      return BookingModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Supabase booking failed: ${e.message} (code: ${e.code})');
    } catch (e) {
      throw Exception('Unexpected error creating booking: $e');
    }
  }
}
