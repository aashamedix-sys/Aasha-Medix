import '../models/visit.dart';
import 'webhook_service.dart';

class VisitsService {
  /// Creates a new visit via webhook
  /// Note: Data refresh is manual - no real-time streams used for pilot stability
  static Future<bool> createVisit(Visit visit) async {
    final payload = {
      'lead_id': visit.leadId,
      'patient_name': visit.patientName,
      'mobile_number': visit.mobileNumber,
      'service': visit.service,
      'visit_type': visit.visitType,
      'visit_date': visit.visitDate,
    };

    return await WebhookService.createVisit(payload);
  }

  /// Fetches today's visits via webhook
  /// Note: Data refresh is manual - no real-time streams used for pilot stability
  static Future<List<Visit>> fetchTodayVisits() async {
    // Get today's date in dd-mm-yyyy format
    final now = DateTime.now();
    final today =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';

    final payload = {'date': today};

    final data = await WebhookService.fetchVisits(payload);
    return data.map((json) => Visit.fromJson(json)).toList();
  }

  /// Updates visit status via webhook
  /// Note: Data refresh is manual - no real-time streams used for pilot stability
  static Future<bool> updateVisitStatus(String visitId, String status) async {
    final payload = {'visit_id': visitId, 'visit_status': status};

    return await WebhookService.updateVisitStatus(payload);
  }
}
