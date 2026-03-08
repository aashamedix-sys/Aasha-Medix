import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/audit_log_model.dart';
import 'dart:developer';

class AuditService {
  final SupabaseClient _supabase = SupabaseClientConfig.client;

  Future<void> logAction({required String action, String? details}) async {
    try {
      final user = _supabase.auth.currentUser;
      final logEntry = {
        'user_id': user?.id,
        'action': action,
        'details': details,
      };

      await _supabase.from('audit_logs').insert(logEntry);
      log('AUDIT LOG: $action - \${details ?? ''}');
    } catch (e) {
      log('Failed to write audit log: $e');
      // We generally do not rethrow audit log failures to prevent disrupting patient flows
    }
  }
  
  Future<List<AuditLogModel>> getRecentLogs() async {
    try {
      final response = await _supabase
          .from('audit_logs')
          .select()
          .order('created_at', ascending: false)
          .limit(100);
      return (response as List).map((e) => AuditLogModel.fromJson(e)).toList();
    } catch (e) {
      log('Failed to fetch audit logs: $e');
      return [];
    }
  }
}
