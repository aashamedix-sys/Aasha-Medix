import 'booking_model.dart'; // To reuse BookingStatus

class MedicineOrderModel {
  final String id;
  final String patientId;
  final String? prescriptionUrl;
  final List<dynamic> items; // Can be typed stricter later
  final String deliveryAddress;
  final BookingStatus status;
  final DateTime createdAt;

  MedicineOrderModel({
    required this.id,
    required this.patientId,
    this.prescriptionUrl,
    required this.items,
    required this.deliveryAddress,
    this.status = BookingStatus.pending,
    required this.createdAt,
  });

  factory MedicineOrderModel.fromJson(Map<String, dynamic> json) {
    return MedicineOrderModel(
      id: json['id'],
      patientId: json['patient_id'],
      prescriptionUrl: json['prescription_url'],
      items: json['items'] ?? [],
      deliveryAddress: json['delivery_address'],
      status: BookingStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => BookingStatus.pending),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'prescription_url': prescriptionUrl,
      'items': items,
      'delivery_address': deliveryAddress,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
