import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/booking_model.dart';
import '../services/backend_sync_service.dart';

class BookingProvider with ChangeNotifier {
  BookingModel? _latestBooking;

  // Getter for the latest booking
  BookingModel? get latestBooking => _latestBooking;

  // Check if there's an active booking
  bool get hasActiveBooking => _latestBooking != null;

  // Create a new booking for authenticated user
  Future<void> createBooking({
    required ServiceType serviceType,
    required String testOrPackage,
    required DateTime bookingDate,
    required String bookingTime,
    String? userPhone,
  }) async {
    // Get current authenticated user
    final User? currentUser = FirebaseAuth.instance.currentUser;

    // Throw controlled exception if user is not authenticated
    if (currentUser == null) {
      throw Exception(
        'User not authenticated. Please login to create a booking.',
      );
    }

    // Generate unique booking ID using timestamp and random suffix
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String randomSuffix = (DateTime.now().microsecondsSinceEpoch % 1000)
        .toString()
        .padLeft(3, '0');
    final String bookingId = 'BK$timestamp$randomSuffix';

    // Create the booking model
    final BookingModel newBooking = BookingModel(
      bookingId: bookingId,
      userId: currentUser.uid,
      userPhone: userPhone ?? currentUser.phoneNumber,
      serviceType: serviceType,
      testOrPackage: testOrPackage,
      bookingDate: bookingDate,
      bookingTime: bookingTime,
      bookingStatus: BookingStatus.booked,
      paymentStatus: PaymentStatus.pending,
      createdAt: DateTime.now(),
    );

    // Store the booking locally
    _latestBooking = newBooking;

    // Trigger backend sync (fire and forget - no await, no block)
    // This will queue the booking for sync to Google Sheets with retry logic
    try {
      BackendSyncService().enqueueBooking(newBooking);
    } catch (e) {
      debugPrint('[BookingProvider] Background sync error (non-blocking): $e');
    }

    // Notify listeners about the new booking
    notifyListeners();
  }

  // Get booking data as map (ready for automation/webhooks)
  Map<String, dynamic>? get bookingToMap {
    return _latestBooking?.toMap();
  }

  // Clear the current booking (useful for logout or reset)
  void clearBooking() {
    _latestBooking = null;
    notifyListeners();
  }

  // Update booking status (for future use when connecting to backend)
  void updateBookingStatus(BookingStatus newStatus) {
    if (_latestBooking != null) {
      // Note: Since BookingModel is immutable, we'd need to create a new instance
      // This is prepared for when we add backend integration
      _latestBooking = BookingModel(
        bookingId: _latestBooking!.bookingId,
        userId: _latestBooking!.userId,
        userPhone: _latestBooking!.userPhone,
        serviceType: _latestBooking!.serviceType,
        testOrPackage: _latestBooking!.testOrPackage,
        bookingDate: _latestBooking!.bookingDate,
        bookingTime: _latestBooking!.bookingTime,
        bookingStatus: newStatus,
        paymentStatus: _latestBooking!.paymentStatus,
        createdAt: _latestBooking!.createdAt,
      );
      notifyListeners();
    }
  }
}
