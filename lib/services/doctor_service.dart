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
      return null; // or throw
    }
  }
}
