import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';

class ChatMessage {
  final String id;
  final String roomId;
  final String senderId;
  final String senderRole; // 'patient', 'doctor', 'ai', 'admin'
  final String message;
  final String messageType; // 'text', 'image', 'file', 'ai'
  final String? fileUrl;
  final bool isRead;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderRole,
    required this.message,
    required this.messageType,
    this.fileUrl,
    required this.isRead,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      senderId: json['sender_id'] as String,
      senderRole: json['sender_role'] as String? ?? 'patient',
      message: json['message'] as String,
      messageType: json['message_type'] as String? ?? 'text',
      fileUrl: json['file_url'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_id': roomId,
      'sender_id': senderId,
      'sender_role': senderRole,
      'message': message,
      'message_type': messageType,
      if (fileUrl != null) 'file_url': fileUrl,
    };
  }
}

class ChatRoom {
  final String id;
  final String patientId;
  final String? doctorId;
  final String roomType;
  final bool isActive;
  final DateTime createdAt;

  ChatRoom({
    required this.id,
    required this.patientId,
    this.doctorId,
    required this.roomType,
    required this.isActive,
    required this.createdAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      doctorId: json['doctor_id'] as String?,
      roomType: json['room_type'] as String? ?? 'patient_doctor',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class ChatService {
  final SupabaseClient _client = SupabaseClientConfig.client;
  RealtimeChannel? _messageChannel;

  /// Creates or retrieves existing chat room between patient and doctor.
  Future<ChatRoom> getOrCreateRoom({
    required String patientId,
    String? doctorId,
    String roomType = 'patient_doctor',
  }) async {
    try {
      // Check if room already exists
      final existing = await _client
          .from('chat_rooms')
          .select()
          .eq('patient_id', patientId)
          .eq('is_active', true)
          .maybeSingle();

      if (existing != null) {
        return ChatRoom.fromJson(existing);
      }

      // Create new room
      final response = await _client
          .from('chat_rooms')
          .insert({
            'patient_id': patientId,
            if (doctorId != null) 'doctor_id': doctorId,
            'room_type': roomType,
          })
          .select()
          .single();

      return ChatRoom.fromJson(response);
    } on PostgrestException catch (e) {
      debugPrint('[ChatService] PostgrestException in getOrCreateRoom: ${e.message}');
      throw Exception('Failed to get/create chat room: ${e.message} (${e.code})');
    } catch (e) {
      debugPrint('[ChatService] Error in getOrCreateRoom: $e');
      throw Exception('Unexpected error getting chat room: $e');
    }
  }

  /// Fetches message history for a room.
  Future<List<ChatMessage>> fetchMessages(String roomId, {int limit = 50}) async {
    try {
      final response = await _client
          .from('chat_messages')
          .select()
          .eq('room_id', roomId)
          .order('timestamp', ascending: false)
          .limit(limit);

      final messages = (response as List)
          .map((e) => ChatMessage.fromJson(e))
          .toList();

      // Return in chronological order
      return messages.reversed.toList();
    } on PostgrestException catch (e) {
      debugPrint('[ChatService] PostgrestException in fetchMessages: ${e.message}');
      throw Exception('Failed to fetch messages: ${e.message} (${e.code})');
    } catch (e) {
      debugPrint('[ChatService] Error in fetchMessages: $e');
      throw Exception('Unexpected error fetching messages: $e');
    }
  }

  /// Sends a message to a chat room.
  Future<ChatMessage> sendMessage({
    required String roomId,
    required String senderId,
    required String senderRole,
    required String message,
    String messageType = 'text',
    String? fileUrl,
  }) async {
    try {
      final response = await _client
          .from('chat_messages')
          .insert({
            'room_id': roomId,
            'sender_id': senderId,
            'sender_role': senderRole,
            'message': message,
            'message_type': messageType,
            if (fileUrl != null) 'file_url': fileUrl,
          })
          .select()
          .single();

      return ChatMessage.fromJson(response);
    } on PostgrestException catch (e) {
      debugPrint('[ChatService] PostgrestException in sendMessage: ${e.message}');
      throw Exception('Failed to send message: ${e.message} (${e.code})');
    } catch (e) {
      debugPrint('[ChatService] Error in sendMessage: $e');
      throw Exception('Unexpected error sending message: $e');
    }
  }

  /// Subscribes to real-time messages for a room using Supabase Realtime.
  /// Call [unsubscribe] when done.
  void subscribeToMessages(String roomId, void Function(ChatMessage) onMessage) {
    _messageChannel = _client
        .channel('room:$roomId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'room_id',
            value: roomId,
          ),
          callback: (PostgresChangePayload payload) {
            try {
              final message = ChatMessage.fromJson(payload.newRecord);
              onMessage(message);
            } catch (e) {
              debugPrint('[ChatService] Error parsing realtime message: $e');
            }
          },
        )
        .subscribe();
  }

  /// Marks all unread messages in a room as read for the given user.
  Future<void> markMessagesRead(String roomId, String readerId) async {
    try {
      await _client
          .from('chat_messages')
          .update({'is_read': true})
          .eq('room_id', roomId)
          .neq('sender_id', readerId)
          .eq('is_read', false);
    } on PostgrestException catch (e) {
      debugPrint('[ChatService] PostgrestException in markMessagesRead: ${e.message}');
      // Non-critical — do not rethrow
    }
  }

  /// Unsubscribes from realtime channel.
  Future<void> unsubscribe() async {
    if (_messageChannel != null) {
      await _client.removeChannel(_messageChannel!);
      _messageChannel = null;
    }
  }
}
