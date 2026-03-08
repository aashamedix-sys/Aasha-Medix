import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';
import 'dart:async';

class NotificationProvider with ChangeNotifier {
  final NotificationService _service = NotificationService();
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> loadMyNotifications() async {
    final User? currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) return;

    _isLoading = true;
    notifyListeners();
    
    try {
      _notifications = await _service.getMyNotifications(currentUser.id);
      _isLoading = false;
      notifyListeners();
    } catch(e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _service.markAsRead(notificationId);
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final old = _notifications[index];
        _notifications[index] = NotificationModel(
          id: old.id,
          userId: old.userId,
          title: old.title,
          body: old.body,
          createdAt: old.createdAt,
          isRead: true,
        );
        notifyListeners();
      }
    } catch (e) {
      // Handle error implicitly
    }
  }

  Future<void> registerDeviceToken(String token) async {
    await _service.registerDeviceToken(token);
  }

  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    await _service.createNotification(
      userId: userId,
      title: title,
      body: body,
    );
  }
}
