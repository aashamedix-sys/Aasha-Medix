class NursingRequestModel {
  final String id;
  final String bookingId;
  final String? assignedNurseId;
  final String careType;
  final String visitStatus;
  final String? visitNotes;
  final DateTime? completedAt;

  NursingRequestModel({
    required this.id,
    required this.bookingId,
    this.assignedNurseId,
    required this.careType,
    this.visitStatus = 'pending',
    this.visitNotes,
    this.completedAt,
  });

  factory NursingRequestModel.fromJson(Map<String, dynamic> json) {
    return NursingRequestModel(
      id: json['id'],
      bookingId: json['booking_id'],
      assignedNurseId: json['assigned_nurse_id'],
      careType: json['care_type'],
      visitStatus: json['visit_status'] ?? 'pending',
      visitNotes: json['visit_notes'],
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'assigned_nurse_id': assignedNurseId,
      'care_type': careType,
      'visit_status': visitStatus,
      'visit_notes': visitNotes,
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
