import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/lab_report_model.dart';

class ReportsService {
  final SupabaseClient _supabase = SupabaseClientConfig.client;

  Future<List<LabReportModel>> getMyReports(String patientId) async {
    final response = await _supabase
        .from('lab_reports')
        .select()
        .eq('patient_id', patientId)
        .order('uploaded_at', ascending: false);
        
    return (response as List).map((e) => LabReportModel.fromJson(e)).toList();
  }

  Future<String> getSecureDownloadUrl(String filePath) async {
    // Generate a signed URL for a file in the 'reports' bucket valid for 60 seconds
    final signedUrl = await _supabase.storage
        .from('reports')
        .createSignedUrl(filePath, 60);
    return signedUrl;
  }
}
