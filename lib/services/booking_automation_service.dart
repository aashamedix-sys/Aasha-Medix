import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingAutomationService {
  // LIVE Make.com webhook URL for Google Sheets CRM integration
  static const String _webhookUrl =
      'https://hook.eu2.make.com/781nmlxgteqkuh0g1zft2ktrwrddesbc';

  // Timeout duration for HTTP requests (10 seconds as specified)
  static const Duration _timeout = Duration(seconds: 10);

  /// Sends booking data to Make.com webhook for Google Sheets CRM
  /// Returns true on success, false on failure
  static Future<bool> sendBookingToWebhook(Map<String, dynamic> payload) async {
    try {
      final response = await http
          .post(
            Uri.parse(_webhookUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(_timeout);

      // Consider 200-299 as success
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Validates webhook URL format (basic check)
  static bool isValidWebhookUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == 'https' && uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Test webhook connectivity (optional utility method)
  static Future<bool> testWebhook() async {
    try {
      final testPayload = {
        'test': true,
        'timestamp': DateTime.now().toIso8601String(),
        'source': 'AASHA_MEDIX_APP_TEST',
      };

      final response = await http
          .post(
            Uri.parse(_webhookUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(testPayload),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      return false;
    }
  }
}
