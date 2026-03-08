import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

/// Central monitoring service for AASHA MEDIX.
/// Wraps Firebase Crashlytics and Analytics with healthcare-specific helpers.
class MonitoringService {
  static final _crashlytics = FirebaseCrashlytics.instance;
  static final _analytics = FirebaseAnalytics.instance;

  /// Call once in main() after Firebase.initializeApp()
  static Future<void> initialize() async {
    // Forward all Flutter errors to Crashlytics
    FlutterError.onError = _crashlytics.recordFlutterFatalError;
    
    // Enable analytics collection
    await _analytics.setAnalyticsCollectionEnabled(true);
  }

  // ------- CRASHLYTICS -------

  /// Record a non-fatal error (use in catch blocks for graceful errors)
  static Future<void> recordError(dynamic error, StackTrace? stack, {String? context}) async {
    log('[MonitoringService] Error in $context: $error');
    await _crashlytics.recordError(
      error, 
      stack, 
      reason: context,
      fatal: false,
    );
  }

  /// Set the current logged-in user ID for crash attribution
  static Future<void> setUser(String userId, String role) async {
    await _crashlytics.setUserIdentifier(userId);
    await _crashlytics.setCustomKey('user_role', role);
  }

  /// Log a custom diagnostic key for debugging context
  static Future<void> addBreadcrumb(String key, String value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  // ------- ANALYTICS EVENTS -------

  static Future<void> logBookingCreated(String serviceType) async {
    await _analytics.logEvent(name: 'booking_created', parameters: {'service_type': serviceType});
  }

  static Future<void> logPaymentSuccess(double amount) async {
    await _analytics.logEvent(name: 'payment_success', parameters: {'amount': amount});
  }

  static Future<void> logReportDownloaded() async {
    await _analytics.logEvent(name: 'report_downloaded');
  }

  static Future<void> logNurseVisitCompleted() async {
    await _analytics.logEvent(name: 'nurse_visit_completed');
  }

  static Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  static Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }
}
