import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import '../models/booking_model.dart';
import '../models/booking_queue_model.dart';
import 'booking_automation_service.dart';

/// Backend sync service for managing booking queue and syncing to Google Sheets
///
/// Responsibilities:
/// - Enqueue bookings for backend sync
/// - Persist queue to SQLite (survives app restarts)
/// - Sync pending bookings with exponential backoff retry
/// - Mark successful syncs
/// - Handle errors silently
class BackendSyncService {
  static final BackendSyncService _instance = BackendSyncService._internal();
  static Database? _database;

  factory BackendSyncService() {
    return _instance;
  }

  BackendSyncService._internal();

  static const String _dbName = 'aasha_medix_sync.db';
  static const String _tableName = 'booking_queue';
  static const int _maxRetries = 3;
  static const Duration _baseBackoffDuration = Duration(seconds: 5);

  /// Initialize the database (call once on app startup)
  Future<void> initializeDatabase() async {
    if (_database != null && _database!.isOpen) return;

    final databasesPath = await getDatabasesPath();
    final dbPath = join(databasesPath, _dbName);

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            bookingId TEXT NOT NULL UNIQUE,
            payload TEXT NOT NULL,
            retryCount INTEGER DEFAULT 0,
            createdAt TEXT NOT NULL,
            lastAttemptAt TEXT,
            lastError TEXT,
            synced INTEGER DEFAULT 0
          )
        ''');

        debugPrint('[BackendSyncService] Database initialized');
      },
    );
  }

  /// Enqueue a booking for sync to Google Sheets
  ///
  /// This is called after BookingProvider.createBooking() succeeds.
  /// It stores the booking locally and triggers async sync.
  ///
  /// Does NOT await or block UI.
  Future<void> enqueueBooking(BookingModel booking) async {
    try {
      await initializeDatabase();
      if (_database == null || !_database!.isOpen) {
        debugPrint(
          '[BackendSyncService] Database not initialized, skipping enqueue',
        );
        return;
      }

      final queueItem = BookingQueueModel(
        id: '${booking.bookingId}_${DateTime.now().millisecondsSinceEpoch}',
        bookingId: booking.bookingId,
        payload: booking.toMap(),
        createdAt: DateTime.now(),
      );

      final payloadJson = jsonEncode(queueItem.payload);

      await _database!.insert(_tableName, {
        'id': queueItem.id,
        'bookingId': queueItem.bookingId,
        'payload': payloadJson,
        'retryCount': queueItem.retryCount,
        'createdAt': queueItem.createdAt.toIso8601String(),
        'synced': 0,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      debugPrint('[BackendSyncService] Enqueued booking: ${booking.bookingId}');

      // Trigger sync in background (fire and forget)
      syncAllPendingBookings().catchError(
        (e) => debugPrint('[BackendSyncService] Background sync error: $e'),
      );
    } catch (e) {
      debugPrint('[BackendSyncService] Error enqueuing booking: $e');
      // Fail silently - do not crash the app
    }
  }

  /// Sync all pending bookings to Google Sheets
  ///
  /// This is an async background operation that:
  /// - Fetches all unsynced bookings
  /// - Attempts to send each one
  /// - Retries failed bookings with exponential backoff
  /// - Marks successful syncs
  ///
  /// Does NOT block the UI.
  Future<void> syncAllPendingBookings() async {
    try {
      await initializeDatabase();
      if (_database == null || !_database!.isOpen) return;

      final pendingBookings = await getPendingBookings();
      if (pendingBookings.isEmpty) return;

      debugPrint(
        '[BackendSyncService] Syncing ${pendingBookings.length} pending bookings',
      );

      for (final queueItem in pendingBookings) {
        try {
          // Check if should retry (exponential backoff)
          if (!queueItem.isRetryable(_maxRetries, _baseBackoffDuration)) {
            if (queueItem.retryCount >= _maxRetries) {
              debugPrint(
                '[BackendSyncService] Max retries exceeded for ${queueItem.bookingId}',
              );
              // Give up silently
              continue;
            }
            // Not yet time to retry
            continue;
          }

          // Attempt to sync
          final success = await BookingAutomationService.sendToGoogleSheets(
            queueItem.payload,
          );

          if (success) {
            // Mark as synced
            await markSynced(queueItem.id);
            debugPrint('[BackendSyncService] ✓ Synced: ${queueItem.bookingId}');
          } else {
            // Mark failed attempt
            await _recordFailedAttempt(queueItem.id, 'HTTP request failed');
            debugPrint(
              '[BackendSyncService] ✗ Sync failed: ${queueItem.bookingId}',
            );
          }
        } catch (e) {
          await _recordFailedAttempt(queueItem.id, e.toString());
          debugPrint(
            '[BackendSyncService] Error syncing ${queueItem.bookingId}: $e',
          );
        }
      }
    } catch (e) {
      debugPrint('[BackendSyncService] Error in syncAllPendingBookings: $e');
    }
  }

  /// Get all bookings that haven't been synced yet or need retry
  Future<List<BookingQueueModel>> getPendingBookings() async {
    try {
      await initializeDatabase();
      if (_database == null || !_database!.isOpen) return [];

      final result = await _database!.query(
        _tableName,
        where: 'synced = 0',
        orderBy: 'createdAt ASC',
      );

      return result.map((row) {
        final payloadJson = jsonDecode(row['payload'] as String);
        return BookingQueueModel.fromMap({...row, 'payload': payloadJson});
      }).toList();
    } catch (e) {
      debugPrint('[BackendSyncService] Error fetching pending bookings: $e');
      return [];
    }
  }

  /// Mark a queue item as successfully synced
  ///
  /// After this, the item will NOT be retried.
  Future<void> markSynced(String queueItemId) async {
    try {
      await initializeDatabase();
      if (_database == null || !_database!.isOpen) return;

      await _database!.update(
        _tableName,
        {'synced': 1, 'lastAttemptAt': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [queueItemId],
      );

      debugPrint('[BackendSyncService] Marked as synced: $queueItemId');
    } catch (e) {
      debugPrint('[BackendSyncService] Error marking synced: $e');
    }
  }

  /// Record a failed sync attempt (for retry tracking)
  Future<void> _recordFailedAttempt(String queueItemId, String error) async {
    try {
      await initializeDatabase();
      if (_database == null || !_database!.isOpen) return;

      // Get current retry count
      final result = await _database!.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [queueItemId],
      );

      if (result.isEmpty) return;

      final currentRetryCount = (result.first['retryCount'] as int?) ?? 0;

      await _database!.update(
        _tableName,
        {
          'retryCount': currentRetryCount + 1,
          'lastAttemptAt': DateTime.now().toIso8601String(),
          'lastError': error,
        },
        where: 'id = ?',
        whereArgs: [queueItemId],
      );
    } catch (e) {
      debugPrint('[BackendSyncService] Error recording failed attempt: $e');
    }
  }

  /// Delete all synced items (cleanup)
  ///
  /// Call this periodically to clean up old completed syncs.
  Future<void> deleteSyncedItems() async {
    try {
      await initializeDatabase();
      if (_database == null || !_database!.isOpen) return;

      await _database!.delete(_tableName, where: 'synced = 1');

      debugPrint('[BackendSyncService] Cleaned up synced items');
    } catch (e) {
      debugPrint('[BackendSyncService] Error deleting synced items: $e');
    }
  }

  /// Close database (call on app shutdown if needed)
  Future<void> closeDatabase() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
      debugPrint('[BackendSyncService] Database closed');
    }
  }

  /// Debug: Get total pending count
  Future<int> getPendingCount() async {
    try {
      await initializeDatabase();
      if (_database == null || !_database!.isOpen) return 0;

      final result = await _database!.rawQuery(
        'SELECT COUNT(*) as count FROM $_tableName WHERE synced = 0',
      );

      return (result.isNotEmpty ? (result.first['count'] as int?) ?? 0 : 0);
    } catch (e) {
      debugPrint('[BackendSyncService] Error getting pending count: $e');
      return 0;
    }
  }
}
