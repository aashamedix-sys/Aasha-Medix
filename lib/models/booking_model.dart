enum ServiceType { diagnostics, doctor, homeSample, nursing, pharmacy }
enum BookingStatus { pending, booked, scheduled, assigned, inProgress, completed, cancelled }
enum PaymentStatus { pending, paid, failed, refunded }

class BookingModel {
  // UI-compatible property names
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
  final double? totalAmount;
  final String? notes;
  final String? address;

  // Milestone Timestamps
  final DateTime? assignedAt;
  final DateTime? serviceStartedAt;
  final DateTime? serviceCompletedAt;
  final DateTime? reportUploadedAt;

  BookingModel({
    required this.bookingId,
    required this.userId,
    this.userPhone,
    required this.serviceType,
    required this.testOrPackage,
    required this.bookingDate,
    required this.bookingTime,
    this.bookingStatus = BookingStatus.pending,
    this.paymentStatus = PaymentStatus.pending,
    required this.createdAt,
    this.totalAmount,
    this.notes,
    this.address,
    this.assignedAt,
    this.serviceStartedAt,
    this.serviceCompletedAt,
    this.reportUploadedAt,
  });

  // Maps UI names to Supabase DB schema
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['id'],
      userId: json['patient_id'],
      serviceType: ServiceType.values.firstWhere((e) => e.name == json['service_type'], orElse: () => ServiceType.diagnostics),
      bookingStatus: _parseStatus(json['status']),
      bookingDate: DateTime.parse(json['scheduled_time']),
      bookingTime: "TBD", // Derived from scheduled_time
      totalAmount: json['total_amount'] != null ? (json['total_amount'] as num).toDouble() : 0.0,
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      testOrPackage: json['test_or_package'] ?? 'Unknown',
      userPhone: json['user_phone'],
      address: json['address'],
      paymentStatus: PaymentStatus.pending,
      assignedAt: json['assigned_at'] != null ? DateTime.parse(json['assigned_at']) : null,
      serviceStartedAt: json['service_started_at'] != null ? DateTime.parse(json['service_started_at']) : null,
      serviceCompletedAt: json['service_completed_at'] != null ? DateTime.parse(json['service_completed_at']) : null,
      reportUploadedAt: json['report_uploaded_at'] != null ? DateTime.parse(json['report_uploaded_at']) : null,
    );
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) => BookingModel.fromJson(map);

  Map<String, dynamic> toJson() {
    return {
      'id': bookingId,
      'patient_id': userId,
      'service_type': serviceType.name,
      'status': bookingStatus == BookingStatus.inProgress ? 'in_progress' : bookingStatus.name,
      'scheduled_time': bookingDate.toUtc().toIso8601String(),
      'total_amount': totalAmount ?? 0.0,
      'notes': notes,
      if (address != null) 'address': address,
      if (userPhone != null) 'user_phone': userPhone,
      'created_at': createdAt.toUtc().toIso8601String(),
      'assigned_at': assignedAt?.toIso8601String(),
      'service_started_at': serviceStartedAt?.toIso8601String(),
      'service_completed_at': serviceCompletedAt?.toIso8601String(),
      'report_uploaded_at': reportUploadedAt?.toIso8601String(),
    };
  }

  static BookingStatus _parseStatus(String? status) {
    if (status == null) return BookingStatus.pending;
    if (status == 'in_progress') return BookingStatus.inProgress;
    return BookingStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => BookingStatus.pending,
    );
  }

  Map<String, dynamic> toMap() => toJson();
}
