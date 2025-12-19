import 'package:flutter/material.dart';

enum ServiceType {
  diagnosticTest,
  healthPackage,
  homeSample,
  doctorConsultation,
}

class BookingSummaryModel {
  final String bookingId;
  final ServiceType serviceType;
  final String patientName;
  final String phoneNumber;
  final List<String> items; // Test IDs or package name or consultation type
  final String? address;
  final DateTime? date;
  final TimeOfDay? time;
  final double amount;
  final DateTime createdAt;
  final String source;

  const BookingSummaryModel({
    required this.bookingId,
    required this.serviceType,
    required this.patientName,
    required this.phoneNumber,
    required this.items,
    this.address,
    this.date,
    this.time,
    required this.amount,
    required this.createdAt,
    this.source = "AASHA_MEDIX_APP",
  });

  factory BookingSummaryModel.fromMap(Map<String, dynamic> map) {
    return BookingSummaryModel(
      bookingId: map['bookingId'] ?? '',
      serviceType: ServiceType.values[map['serviceType'] ?? 0],
      patientName: map['patientName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      items: List<String>.from(map['items'] ?? []),
      address: map['address'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      time: map['time'] != null
          ? TimeOfDay(hour: map['time']['hour'], minute: map['time']['minute'])
          : null,
      amount: (map['amount'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      source: map['source'] ?? "AASHA_MEDIX_APP",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'serviceType': serviceType.index,
      'patientName': patientName,
      'phoneNumber': phoneNumber,
      'items': items,
      'address': address,
      'date': date?.toIso8601String(),
      'time': time != null
          ? {'hour': time!.hour, 'minute': time!.minute}
          : null,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'source': source,
    };
  }

  // Automation-ready payload for Make.com webhook → Google Sheets CRM
  Map<String, dynamic> toAutomationPayload() {
    return {
      'bookingId': bookingId,
      'serviceType': serviceType.name,
      'patientName': patientName,
      'phone': phoneNumber, // Changed from phoneNumber to phone as per spec
      'items': items,
      'address': address,
      'date': date?.toIso8601String(),
      'time': time != null
          ? '${time!.hour}:${time!.minute.toString().padLeft(2, '0')}'
          : null,
      'amount': amount,
      'source': source,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get whatsappMessage {
    final dateStr = date != null
        ? '${date!.day} ${date!.month == 1
              ? 'Jan'
              : date!.month == 2
              ? 'Feb'
              : date!.month == 3
              ? 'Mar'
              : date!.month == 4
              ? 'Apr'
              : date!.month == 5
              ? 'May'
              : date!.month == 6
              ? 'Jun'
              : date!.month == 7
              ? 'Jul'
              : date!.month == 8
              ? 'Aug'
              : date!.month == 9
              ? 'Sep'
              : date!.month == 10
              ? 'Oct'
              : date!.month == 11
              ? 'Nov'
              : 'Dec'}'
        : 'TBD';

    final timeStr = time != null
        ? '${time!.hour}:${time!.minute.toString().padLeft(2, '0')}'
        : 'TBD';

    return '''
Thank you for booking with AASHA MEDIX 💚
Booking ID: $bookingId
Service: $serviceTypeDisplay
${items.isNotEmpty ? 'Items: ${items.join(', ')}' : ''}
${address != null ? 'Address: $address' : ''}
Date: $dateStr | $timeStr
Amount: ₹$amount
Our team will contact you shortly.
'''
        .trim();
  }

  String get serviceTypeDisplay {
    switch (serviceType) {
      case ServiceType.diagnosticTest:
        return 'Diagnostic Test';
      case ServiceType.healthPackage:
        return 'Health Package';
      case ServiceType.homeSample:
        return 'Home Sample Collection';
      case ServiceType.doctorConsultation:
        return 'Doctor Consultation';
    }
  }

  static String generateBookingId() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString().substring(8);
    return 'AMX$timestamp';
  }
}
