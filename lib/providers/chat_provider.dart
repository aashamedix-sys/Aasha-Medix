import 'package:flutter/material.dart';
import '../services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> loadMessages(String userId1, String userId2) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _messages = await _chatService.fetchMessages(userId1, userId2);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> sendMessage({
    required String senderId,
    required String recipientId,
    required String message,
  }) async {
    try {
      final newMessage = await _chatService.sendMessage(
        senderId: senderId,
        recipientId: recipientId,
        message: message,
      );
      
      // Realtime subscription will handle adding the message, 
      // but we add it manually for immediate feedback if no subscription active
      if (!_messages.any((m) => m.id == newMessage.id)) {
        _messages.add(newMessage);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  void setupRealtime(String currentUserId, String otherUserId) {
    _chatService.subscribeToMessages(currentUserId, otherUserId, (newMessage) {
      if (!_messages.any((m) => m.id == newMessage.id)) {
        _messages.add(newMessage);
        notifyListeners();
      }
    });
  }

  void disposeRealtime() {
    _chatService.unsubscribe();
  }

  Future<void> markAsRead(String senderId, String recipientId) async {
    await _chatService.markMessagesRead(senderId, recipientId);
  }
}
