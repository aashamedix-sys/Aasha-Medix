/// Represents a booking pending sync to Google Sheets
///
/// This model persists bookings that need to be sent to the backend.
/// It survives app crashes and retries failed syncs with exponential backoff.
class BookingQueueModel {
  final String id; // Unique queue ID (generated locally)
  final String bookingId; // The actual booking ID from BookingModel
  final Map<String, dynamic> payload; // booking.toMap() JSON
  final int retryCount; // Number of failed sync attempts
  final DateTime createdAt; // When booking was queued
  final DateTime? lastAttemptAt; // Last time we tried to sync
  final String? lastError; // Error message from last failed attempt
  final bool synced; // Successfully sent to Google Sheets

  const BookingQueueModel({
    required this.id,
    required this.bookingId,
    required this.payload,
    this.retryCount = 0,
    required this.createdAt,
    this.lastAttemptAt,
    this.lastError,
    this.synced = false,
  });

  /// Convert to JSON for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'payload': payload, // Will be converted to JSON string in service
      'retryCount': retryCount,
      'createdAt': createdAt.toIso8601String(),
      'lastAttemptAt': lastAttemptAt?.toIso8601String(),
      'lastError': lastError,
      'synced': synced ? 1 : 0, // SQLite stores as int
    };
  }

  /// Reconstruct from JSON
  factory BookingQueueModel.fromMap(Map<String, dynamic> map) {
    return BookingQueueModel(
      id: map['id'] as String,
      bookingId: map['bookingId'] as String,
      payload: map['payload'] as Map<String, dynamic>,
      retryCount: map['retryCount'] as int? ?? 0,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastAttemptAt: map['lastAttemptAt'] != null
          ? DateTime.parse(map['lastAttemptAt'] as String)
          : null,
      lastError: map['lastError'] as String?,
      synced: (map['synced'] as int? ?? 0) == 1,
    );
  }

  /// Create a copy with updated fields (for retry tracking)
  BookingQueueModel copyWith({
    int? retryCount,
    DateTime? lastAttemptAt,
    String? lastError,
    bool? synced,
  }) {
    return BookingQueueModel(
      id: id,
      bookingId: bookingId,
      payload: payload,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      lastError: lastError ?? this.lastError,
      synced: synced ?? this.synced,
    );
  }

  /// Check if this booking should be retried
  ///
  /// Rules:
  /// - Already synced? No
  /// - Exceeded max retries? No
  /// - Never attempted? Yes
  /// - Has retry delay elapsed? Yes
  bool isRetryable(int maxRetries, Duration backoffDuration) {
    if (synced) return false;
    if (retryCount >= maxRetries) return false;

    // Calculate next retry time: exponential backoff
    // Retry 1: 5s, Retry 2: 25s (5s * 5), Retry 3: 125s (25s * 5)
    final delayMultiplier = 5; // Exponential factor
    final nextRetryTime =
        lastAttemptAt?.add(
          Duration(
            seconds: backoffDuration.inSeconds * (delayMultiplier * retryCount),
          ),
        ) ??
        createdAt; // First attempt: use createdAt

    return DateTime.now().isAfter(nextRetryTime);
  }

  @override
  String toString() =>
      'BookingQueueModel(id: $id, bookingId: $bookingId, synced: $synced, retryCount: $retryCount)';
}
