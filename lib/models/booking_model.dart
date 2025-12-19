enum ServiceType { diagnostics, doctor, homeSample }

enum BookingStatus { booked, collected, completed, cancelled }

enum PaymentStatus { pending, paid }

class BookingModel {
  final String bookingId;
  final String userId;
  final String? userPhone;
  final ServiceType serviceType;
  final String testOrPackage;
  final DateTime bookingDate;
  final String bookingTime;
  final BookingStatus bookingStatus;
  final PaymentStatus paymentStatus;
  final DateTime createdAt;

  const BookingModel({
    required this.bookingId,
    required this.userId,
    this.userPhone,
    required this.serviceType,
    required this.testOrPackage,
    required this.bookingDate,
    required this.bookingTime,
    required this.bookingStatus,
    required this.paymentStatus,
    required this.createdAt,
  });

  // Convert enum to string for Firestore/JSON
  String get serviceTypeString {
    switch (serviceType) {
      case ServiceType.diagnostics:
        return 'diagnostics';
      case ServiceType.doctor:
        return 'doctor';
      case ServiceType.homeSample:
        return 'home_sample';
    }
  }

  String get bookingStatusString {
    switch (bookingStatus) {
      case BookingStatus.booked:
        return 'booked';
      case BookingStatus.collected:
        return 'collected';
      case BookingStatus.completed:
        return 'completed';
      case BookingStatus.cancelled:
        return 'cancelled';
    }
  }

  String get paymentStatusString {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.paid:
        return 'paid';
    }
  }

  // Create from Firestore/JSON map
  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      bookingId: map['bookingId'] ?? '',
      userId: map['userId'] ?? '',
      userPhone: map['userPhone'],
      serviceType: _parseServiceType(map['serviceType'] ?? ''),
      testOrPackage: map['testOrPackage'] ?? '',
      bookingDate: DateTime.parse(
        map['bookingDate'] ?? DateTime.now().toIso8601String(),
      ),
      bookingTime: map['bookingTime'] ?? '',
      bookingStatus: _parseBookingStatus(map['bookingStatus'] ?? ''),
      paymentStatus: _parsePaymentStatus(map['paymentStatus'] ?? ''),
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // Convert to Firestore/JSON map
  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'userPhone': userPhone,
      'serviceType': serviceTypeString,
      'testOrPackage': testOrPackage,
      'bookingDate': bookingDate.toIso8601String(),
      'bookingTime': bookingTime,
      'bookingStatus': bookingStatusString,
      'paymentStatus': paymentStatusString,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Helper methods to parse strings back to enums
  static ServiceType _parseServiceType(String value) {
    switch (value) {
      case 'diagnostics':
        return ServiceType.diagnostics;
      case 'doctor':
        return ServiceType.doctor;
      case 'home_sample':
        return ServiceType.homeSample;
      default:
        return ServiceType.diagnostics; // fallback
    }
  }

  static BookingStatus _parseBookingStatus(String value) {
    switch (value) {
      case 'booked':
        return BookingStatus.booked;
      case 'collected':
        return BookingStatus.collected;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.booked; // fallback
    }
  }

  static PaymentStatus _parsePaymentStatus(String value) {
    switch (value) {
      case 'pending':
        return PaymentStatus.pending;
      case 'paid':
        return PaymentStatus.paid;
      default:
        return PaymentStatus.pending; // fallback
    }
  }

  @override
  String toString() {
    return 'BookingModel(bookingId: $bookingId, userId: $userId, serviceType: $serviceTypeString, testOrPackage: $testOrPackage, status: $bookingStatusString)';
  }
}
