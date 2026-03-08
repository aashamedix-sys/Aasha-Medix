import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // To get current user id
import '../models/booking_model.dart';
import '../services/booking_service.dart';
import '../services/audit_service.dart';
import '../utils/app_error.dart';

class BookingProvider with ChangeNotifier {
  final BookingService _service = BookingService();
  final AuditService _auditService = AuditService();
  BookingModel? _latestBooking;
  List<BookingModel> _myBookings = [];
  bool _isLoading = false;

  BookingModel? get latestBooking => _latestBooking;
  List<BookingModel> get myBookings => _myBookings;
  bool get hasActiveBooking => _latestBooking != null;
  bool get isLoading => _isLoading;

  Future<void> createBooking({
    required ServiceType serviceType,
    required String testOrPackage,
    required DateTime bookingDate,
    required String bookingTime,
    String? userPhone,
    String? address,
    String? notes,
    double? totalAmount,
  }) async {
    final User? currentUser = Supabase.instance.client.auth.currentUser;

    if (currentUser == null) {
      throw Exception('User not authenticated. Please login to create a booking.');
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Create temporary booking object to send to backend
      // Note: Backend might override the ID we send or we generate UUID here if DB expects it.
      // Usually, Postgres UUIDs are generated on the server using uuid_generate_v4() defaults.
      // But Since our model requires an ID, we'll send a temporary ID or just omit it in JSON dynamically.

      final String tempId = DateTime.now().millisecondsSinceEpoch.toString();

      final BookingModel newBooking = BookingModel(
        bookingId: tempId, // Might be ignored by Supabase if it's default uuid on insert
        userId: currentUser.id,
        userPhone: userPhone ?? currentUser.phone,
        serviceType: serviceType,
        testOrPackage: testOrPackage,
        bookingDate: bookingDate,
        bookingTime: bookingTime,
        bookingStatus: BookingStatus.booked,
        paymentStatus: PaymentStatus.pending,
        address: address,
        notes: notes,
        totalAmount: totalAmount,
        createdAt: DateTime.now(),
      );

      final realId = await _service.createBooking(newBooking);

      // Update with the real ID
      _latestBooking = BookingModel(
        bookingId: realId,
        userId: currentUser.id,
        userPhone: userPhone ?? currentUser.phone,
        serviceType: serviceType,
        testOrPackage: testOrPackage,
        bookingDate: bookingDate,
        bookingTime: bookingTime,
        bookingStatus: BookingStatus.booked,
        paymentStatus: PaymentStatus.pending,
        address: address,
        notes: notes,
        totalAmount: totalAmount,
        createdAt: newBooking.createdAt,
      );

      _myBookings.insert(0, _latestBooking!);

      await _auditService.logAction(
        action: 'BOOKING_CREATED',
        details: 'Booking ID: $realId, Service: ${serviceType.name}'
      );

      _isLoading = false;
      notifyListeners();

    } catch(e) {
      _isLoading = false;
      notifyListeners();
      throw AppError.from(e);
    }
  }

  Future<void> fetchMyBookings() async {
    final User? currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      _myBookings = await _service.fetchUserBookings(currentUser.id);
      if (_myBookings.isNotEmpty) {
        _latestBooking = _myBookings.first;
      }
      _isLoading = false;
      notifyListeners();
    } catch(e) {
      _isLoading = false;
      notifyListeners();
      throw AppError.from(e);
    }
  }

  Map<String, dynamic>? get bookingToMap {
    return _latestBooking?.toMap();
  }

  void clearBooking() {
    _latestBooking = null;
    notifyListeners();
  }
}
