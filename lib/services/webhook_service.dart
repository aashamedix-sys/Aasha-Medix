import 'dart:convert';
import 'package:http/http.dart' as http;

class WebhookService {
  static const String _webhookUrl =
      'https://hook.eu2.make.com/781nmlxgteqkuh0g1zft2ktrwrddesbc';

  // Visit-specific webhook URLs (to be configured in Make.com)
  static const String _createVisitUrl =
      'https://hook.eu2.make.com/create-visit-endpoint';
  static const String _updateVisitUrl =
      'https://hook.eu2.make.com/update-visit-endpoint';
  static const String _fetchVisitsUrl =
      'https://hook.eu2.make.com/fetch-visits-endpoint';

  /// Submits lead data to Make.com webhook
  /// Returns true on success, throws exception on failure
  static Future<bool> submitLead({
    required String patientName,
    required String mobileNumber,
    required String service,
    required String visitType,
  }) async {
    try {
      // Create current date in dd-mm-yyyy format
      final now = DateTime.now();
      final createdAt =
          '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';

      // Prepare JSON payload matching Google Sheet headers
      final payload = {
        'Patient_Name': patientName,
        'Mobile_Number': mobileNumber, // Sent as string
        'Service': service,
        'Visit_Type': visitType,
        'Source': 'Flutter App', // Hardcoded as specified
        'Created_At': createdAt, // dd-mm-yyyy format
      };

      // Make POST request
      final response = await http.post(
        Uri.parse(_webhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      // Check for success (HTTP 200)
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
          'Server error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      // Re-throw with more context
      throw Exception('Failed to submit lead: $e');
    }
  }

  /// Creates a visit via webhook
  static Future<bool> createVisit(Map<String, dynamic> payload) async {
    try {
      final response = await http.post(
        Uri.parse(_createVisitUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Visit creation failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Visit creation error: $e');
    }
  }

  /// Updates visit status via webhook
  static Future<bool> updateVisitStatus(Map<String, dynamic> payload) async {
    try {
      final response = await http.post(
        Uri.parse(_updateVisitUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Visit update failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Visit update error: $e');
    }
  }

  /// Fetches visits via webhook
  static Future<List<Map<String, dynamic>>> fetchVisits(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(_fetchVisitsUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Fetch visits failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fetch visits error: $e');
    }
  }
}
