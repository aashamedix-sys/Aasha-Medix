import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/diagnostics_models.dart';
import '../core/supabase_client.dart';

// DiagnosticsData static file is DEPRECATED as of v2.1.
// All data must be fetched from Supabase tables: diagnostic_tests, health_packages.
// Do NOT import DiagnosticsData anywhere in the codebase.

class DiagnosticsService {
  final SupabaseClient _client = SupabaseClientConfig.client;

  Future<List<TestItem>> fetchTests() async {
    try {
      final response = await _client
          .from('diagnostic_tests')
          .select()
          .order('testName', ascending: true);

      return (response as List)
          .map((item) => TestItem.fromMap(item))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
          'Supabase query failed [diagnostic_tests]: ${e.message} (code: ${e.code})');
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
}
