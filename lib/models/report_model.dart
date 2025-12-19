class ReportModel {
  final String id;
  final String bookingId;
  final String userId;
  final String reportUrl;
  final DateTime uploadDate;

  ReportModel({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.reportUrl,
    required this.uploadDate,
  });

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] ?? '',
      bookingId: map['bookingId'] ?? '',
      userId: map['userId'] ?? '',
      reportUrl: map['reportUrl'] ?? '',
      uploadDate: DateTime.parse(
        map['uploadDate'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'userId': userId,
      'reportUrl': reportUrl,
      'uploadDate': uploadDate.toIso8601String(),
    };
  }
}
