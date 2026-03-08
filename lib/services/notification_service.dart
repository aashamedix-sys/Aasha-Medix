import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../core/supabase_client.dart';
import '../models/notification_model.dart';
import '../core/env_config.dart';
import 'dart:developer';

class NotificationService {
  final SupabaseClient _supabase = SupabaseClientConfig.client;

  /// Request FCM permission and register the device token.
  /// Call this after user logs in.
  Future<void> requestPermissionAndRegister() async {
    try {
      final messaging = FirebaseMessaging.instance;

      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final token = await messaging.getToken();
        if (token != null) {
          await registerDeviceToken(token);
        }

        // Listen for token refreshes
        messaging.onTokenRefresh.listen(registerDeviceToken);
      }
    } catch (e) {
      log('Failed to request FCM permission: $e');
    }
  }

  /// Store the FCM device token in the `device_tokens` table.
  Future<void> registerDeviceToken(String token) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('device_tokens').upsert(
        {
          'user_id': user.id,
          'fcm_token': token,
          'updated_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'user_id',
      );
      log('FCM token registered for user ${user.id}');
    } catch (e) {
      log('Failed to register FCM token: $e');
    }
  }

  Future<List<NotificationModel>> getMyNotifications(String userId) async {
    final response = await _supabase
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50);

    return (response as List).map((e) => NotificationModel.fromJson(e)).toList();
  }

  Future<void> markAsRead(String notificationId) async {
    await _supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  /// Trigger a push notification via Supabase Edge Function.
  Future<void> triggerPushNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _supabase.functions.invoke(
        'send-push-notification',
        body: {
          'user_id': userId,
          'title': title,
          'body': body,
          'data': data ?? {},
        },
      );
    } catch (e) {
      log('Push notification trigger failed: $e');
      // Not critical — just log, don't disrupt user flow
    }
  }

  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    await _supabase.from('notifications').insert({
      'user_id': userId,
      'title': title,
      'body': body,
      'is_read': false,
    });
  }
}
