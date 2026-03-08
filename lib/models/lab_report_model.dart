class LabReportModel {
  final String id;
  final String bookingId;
  final String userId;
  final String reportUrl;
  final DateTime uploadDate;
  final bool isViewed;

  LabReportModel({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.reportUrl,
    required this.uploadDate,
    this.isViewed = false,
  });

  // Maps UI field names to Supabase DB columns
  factory LabReportModel.fromJson(Map<String, dynamic> json) {
    return LabReportModel(
      id: json['id'],
      bookingId: json['booking_id'],
      userId: json['patient_id'],
      reportUrl: json['file_url'],
      uploadDate: DateTime.parse(json['uploaded_at']),
      isViewed: json['is_viewed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'patient_id': userId,
      'file_url': reportUrl,
      'uploaded_at': uploadDate.toIso8601String(),
      'is_viewed': isViewed,
    };
  }
}
