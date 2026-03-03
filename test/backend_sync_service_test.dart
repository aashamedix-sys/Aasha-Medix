import 'package:flutter_test/flutter_test.dart';
import 'package:aasha_medix/models/booking_model.dart';
import 'package:aasha_medix/models/booking_queue_model.dart';

void main() {
  group('BookingQueueModel', () {
    test('creates a queue item with correct defaults', () {
      final payload = {
        'bookingId': 'BK12345',
        'userId': 'user123',
        'serviceType': 'consultation',
      };

      final queueItem = BookingQueueModel(
        id: 'queue123',
        bookingId: 'BK12345',
        payload: payload,
        createdAt: DateTime.now(),
      );

      expect(queueItem.bookingId, 'BK12345');
      expect(queueItem.retryCount, 0);
      expect(queueItem.synced, false);
      expect(queueItem.payload, payload);
    });

    test('toMap serializes correctly', () {
      final now = DateTime.now();
      final payload = {'bookingId': 'BK12345'};

      final queueItem = BookingQueueModel(
        id: 'queue123',
        bookingId: 'BK12345',
        payload: payload,
        createdAt: now,
      );

      final map = queueItem.toMap();

      expect(map['id'], 'queue123');
      expect(map['bookingId'], 'BK12345');
      expect(map['payload'], payload);
      expect(map['retryCount'], 0);
      expect(map['synced'], 0); // synced is stored as int (0 or 1) in DB
    });

    test('fromMap deserializes correctly', () {
      final now = DateTime.now();
      final payload = {'bookingId': 'BK12345'};

      final map = {
        'id': 'queue123',
        'bookingId': 'BK12345',
        'payload': payload,
        'retryCount': 2,
        'createdAt': now.toIso8601String(),
        'synced': 0, // 0 = not synced, 1 = synced (stored as int in DB)
      };

      final queueItem = BookingQueueModel.fromMap(map);

      expect(queueItem.id, 'queue123');
      expect(queueItem.bookingId, 'BK12345');
      expect(queueItem.retryCount, 2);
      expect(queueItem.synced, false); // 0 becomes false
    });

    test('copyWith creates a new instance with updated fields', () {
      final queueItem = BookingQueueModel(
        id: 'queue123',
        bookingId: 'BK12345',
        payload: {'bookingId': 'BK12345'},
        createdAt: DateTime.now(),
      );

      final updated = queueItem.copyWith(retryCount: 1, synced: true);

      expect(updated.id, queueItem.id);
      expect(updated.retryCount, 1);
      expect(updated.synced, true);
      expect(queueItem.retryCount, 0); // Original unchanged
    });

    test('isRetryable returns true for new item (0 retries)', () {
      final queueItem = BookingQueueModel(
        id: 'queue123',
        bookingId: 'BK12345',
        payload: {},
        createdAt: DateTime.now().subtract(
          const Duration(seconds: 1),
        ), // Created 1 second ago
      );

      // First attempt (retryCount == 0, no lastAttemptAt) should be retryable
      // because nextRetryTime = createdAt, and now is after createdAt
      final isRetryable = queueItem.isRetryable(3, const Duration(seconds: 5));

      expect(isRetryable, true);
    });

    test('isRetryable respects exponential backoff', () {
      final now = DateTime.now();

      // Item with 1 retry already attempted
      final queueItem = BookingQueueModel(
        id: 'queue123',
        bookingId: 'BK12345',
        payload: {},
        createdAt: now,
        retryCount: 1,
        lastAttemptAt: now.subtract(const Duration(seconds: 10)), // 10s ago
      );

      // Should be retryable because (1 * 5 * 5) = 25s wait, but only 10s passed
      // Wait, let me recalculate: for retry 1, delay = 5 * (5^1) = 25s
      // If 10s passed, should NOT be retryable yet
      final maxRetries = 3;
      final baseDelay = const Duration(seconds: 5);

      final isRetryable = queueItem.isRetryable(maxRetries, baseDelay);
      expect(isRetryable, false); // Not enough time has passed
    });

    test('isRetryable respects max retries limit', () {
      final now = DateTime.now();

      // Item that has been retried 3 times (max is 3)
      final queueItem = BookingQueueModel(
        id: 'queue123',
        bookingId: 'BK12345',
        payload: {},
        createdAt: now,
        retryCount: 3,
        lastAttemptAt: now.subtract(const Duration(hours: 1)), // Long ago
      );

      final isRetryable = queueItem.isRetryable(3, const Duration(seconds: 5));
      expect(isRetryable, false); // Max retries exceeded
    });

    test('BookingModel toMap includes all required fields', () {
      final booking = BookingModel(
        bookingId: 'BK12345',
        userId: 'user123',
        userPhone: '9876543210',
        serviceType: ServiceType.diagnostics,
        testOrPackage: 'Blood Test',
        bookingDate: DateTime(2024, 12, 20),
        bookingTime: '10:00 AM',
        bookingStatus: BookingStatus.booked,
        paymentStatus: PaymentStatus.pending,
        createdAt: DateTime.now(),
      );

      final map = booking.toMap();

      expect(map['bookingId'], 'BK12345');
      expect(map['userId'], 'user123');
      expect(map['userPhone'], '9876543210');
      expect(map['serviceType'], 'diagnostics'); // Enum string value
      expect(map['testOrPackage'], 'Blood Test');
      expect(map['bookingStatus'], 'booked');
      expect(map['paymentStatus'], 'pending');
    });
  });

  group('Backend Sync Integration', () {
    test('Queue item payload matches BookingModel format', () {
      // This ensures Google Sheets will receive the correct format
      final booking = BookingModel(
        bookingId: 'BK99999',
        userId: 'user999',
        userPhone: '1234567890',
        serviceType: ServiceType.doctor,
        testOrPackage: 'General Consultation',
        bookingDate: DateTime(2024, 12, 25),
        bookingTime: '02:00 PM',
        bookingStatus: BookingStatus.booked,
        paymentStatus: PaymentStatus.pending,
        createdAt: DateTime.now(),
      );

      final queueItem = BookingQueueModel(
        id: 'queue999',
        bookingId: booking.bookingId,
        payload: booking.toMap(),
        createdAt: DateTime.now(),
      );

      final payload = queueItem.payload;

      // Verify all fields are present for Google Sheets
      expect(payload['bookingId'], isNotNull);
      expect(payload['userId'], isNotNull);
      expect(payload['serviceType'], isNotNull);
      expect(payload['testOrPackage'], isNotNull);
      expect(payload['bookingDate'], isNotNull);
      expect(payload['bookingTime'], isNotNull);
    });
  });
}
