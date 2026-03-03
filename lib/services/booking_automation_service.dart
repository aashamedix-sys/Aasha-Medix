import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../utils/constants.dart';

/// Booking automation service for posting booking data to Google Sheets via webhook
///
/// This service is responsible for:
/// - Converting booking data to Google Sheets format
/// - Sending HTTP requests to the webhook endpoint
/// - Handling network errors gracefully
/// - No UI interaction (silent operation)
class BookingAutomationService {
  // Private constructor to prevent instantiation
  BookingAutomationService._();

  static const Duration _httpTimeout = Duration(seconds: 10);

  /// Send booking data to Google Sheets webhook
  ///
  /// Returns true if the request was successful (HTTP 2xx status).
  /// Returns false if the request failed for any reason.
  ///
  /// Does NOT throw exceptions - all errors are logged and suppressed.
  ///
  /// Payload format: Map with booking details
  static Future<bool> sendToGoogleSheets(Map<String, dynamic> payload) async {
    try {
      // Validate payload
      if (payload.isEmpty) {
        debugPrint('[BookingAutomationService] Empty payload, skipping');
        return false;
      }

      final webhookUrl = AppConstants.googleSheetsWebhookUrl;
      if (webhookUrl.isEmpty) {
        debugPrint(
          '[BookingAutomationService] No webhook URL configured, skipping',
        );
        return false;
      }

      // Convert payload to JSON
      final jsonPayload = jsonEncode(payload);

      debugPrint(
        '[BookingAutomationService] Sending booking to: ${webhookUrl.split('?').first}...',
      );

      // Prepare HTTP request
      final uri = Uri.parse(webhookUrl);

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonPayload,
          )
          .timeout(
            _httpTimeout,
            onTimeout: () {
              throw TimeoutException(
                'HTTP request timeout after ${_httpTimeout.inSeconds}s',
              );
            },
          );

      // Check response status
      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint(
          '[BookingAutomationService] ✓ Success (HTTP ${response.statusCode})',
        );
        return true;
      } else {
        debugPrint(
          '[BookingAutomationService] ✗ HTTP ${response.statusCode}: ${response.body}',
        );
        return false;
      }
    } on TimeoutException catch (e) {
      debugPrint('[BookingAutomationService] Timeout: $e');
      return false;
    } on http.ClientException catch (e) {
      debugPrint('[BookingAutomationService] Network error: $e');
      return false;
    } catch (e) {
      debugPrint('[BookingAutomationService] Unexpected error: $e');
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
}
