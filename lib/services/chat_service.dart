import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String recipientId;
  final String message;
  final String messageType; // 'text', 'image', 'file', 'ai'
  final String? fileUrl;
  final bool isRead;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.message,
    required this.messageType,
    this.fileUrl,
    required this.isRead,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      recipientId: json['recipient_id'] as String,
      message: json['message'] as String,
      messageType: json['message_type'] as String? ?? 'text',
      fileUrl: json['file_url'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'recipient_id': recipientId,
      'message': message,
      'message_type': messageType,
      if (fileUrl != null) 'file_url': fileUrl,
    };
  }
}

class ChatParticipant {
  final String id;
  final String patientId;
  final String? doctorId;
  final bool isActive;
  final DateTime createdAt;

  ChatParticipant({
    required this.id,
    required this.patientId,
    this.doctorId,
    required this.isActive,
    required this.createdAt,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      doctorId: json['doctor_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class ChatService {
  final SupabaseClient _client = SupabaseClientConfig.client;
  RealtimeChannel? _messageChannel;

  /// Creates or retrieves existing chat participants link between patient and doctor.
  Future<ChatParticipant> getOrCreateParticipantLink({
    required String patientId,
    String? doctorId,
  }) async {
    try {
      final query = _client
          .from('chat_participants')
          .select()
          .eq('patient_id', patientId)
          .eq('is_active', true);
          
      final existing = await (doctorId != null ? query.eq('doctor_id', doctorId) : query.filter('doctor_id', 'is', 'null')).maybeSingle();

      if (existing != null) {
        return ChatParticipant.fromJson(existing);
      }

      // Create new participant link
      final response = await _client
          .from('chat_participants')
          .insert({
            'patient_id': patientId,
            if (doctorId != null) 'doctor_id': doctorId,
          })
          .select()
          .single();

      return ChatParticipant.fromJson(response);
    } on PostgrestException catch (e) {
      debugPrint('[ChatService] PostgrestException in getOrCreateParticipantLink: ${e.message}');
      throw Exception('Failed to get/create chat participant: ${e.message} (${e.code})');
    } catch (e) {
      debugPrint('[ChatService] Error in getOrCreateParticipantLink: $e');
      throw Exception('Unexpected error getting chat participant: $e');
    }
  }

  /// Fetches message history between a sender and recipient.
  Future<List<ChatMessage>> fetchMessages(String userId1, String userId2, {int limit = 50}) async {
    try {
      // Need messages where (sender=user1 AND recipient=user2) OR (sender=user2 AND recipient=user1)
      final response = await _client
          .from('chat_messages')
          .select()
          .or('and(sender_id.eq.$userId1,recipient_id.eq.$userId2),and(sender_id.eq.$userId2,recipient_id.eq.$userId1)')
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

  /// Sends a message directly to a recipient.
  Future<ChatMessage> sendMessage({
    required String senderId,
    required String recipientId,
    required String message,
    String messageType = 'text',
    String? fileUrl,
  }) async {
    try {
      final response = await _client
          .from('chat_messages')
          .insert({
            'sender_id': senderId,
            'recipient_id': recipientId,
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

  /// Subscribes to real-time messages for a specific user (either sent or received).
  /// Call [unsubscribe] when done.
  void subscribeToMessages(String currentUserId, String otherUserId, void Function(ChatMessage) onMessage) {
    _messageChannel = _client
        .channel('chat_messages:user_$currentUserId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          // Supabase Realtime doesn't easily support OR filters on channels,
          // so we listen to all inserts and filter client-side.
          // Note: In production you'd use RLS to secure the channel to only send allowed messages.
          callback: (PostgresChangePayload payload) {
            try {
              final message = ChatMessage.fromJson(payload.newRecord);
              // Only trigger if this message is between the two users we care about
              if ((message.senderId == currentUserId && message.recipientId == otherUserId) ||
                  (message.senderId == otherUserId && message.recipientId == currentUserId)) {
                onMessage(message);
              }
            } catch (e) {
              debugPrint('[ChatService] Error parsing realtime message: $e');
            }
          },
        )
        .subscribe();
  }

  /// Marks all unread messages from a specific sender as read for the recipient.
  Future<void> markMessagesRead(String senderId, String recipientId) async {
    try {
      await _client
          .from('chat_messages')
          .update({'is_read': true})
          .eq('sender_id', senderId)
          .eq('recipient_id', recipientId)
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
