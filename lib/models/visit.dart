class Visit {
  final String? visitId; // Auto-generated in Sheet
  final String leadId;
  final String patientName;
  final String mobileNumber;
  final String service;
  final String visitType;
  final String visitDate;
  final String visitStatus;
  final String createdAt;

  Visit({
    this.visitId,
    required this.leadId,
    required this.patientName,
    required this.mobileNumber,
    required this.service,
    required this.visitType,
    required this.visitDate,
    required this.visitStatus,
    required this.createdAt,
  });

  // Create from JSON (for reading from Sheets)
  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      visitId: json['Visit_ID'] as String?,
      leadId: json['Lead_ID'] as String,
      patientName: json['Patient_Name'] as String,
      mobileNumber: json['Mobile_Number'] as String,
      service: json['Service'] as String,
      visitType: json['Visit_Type'] as String,
      visitDate: json['Visit_Date'] as String,
      visitStatus: json['Visit_Status'] as String,
      createdAt: json['Created_At'] as String,
    );
  }

  // Convert to JSON (for sending to webhook)
  Map<String, dynamic> toJson() {
    return {
      'Visit_ID': visitId,
      'Lead_ID': leadId,
      'Patient_Name': patientName,
      'Mobile_Number': mobileNumber,
      'Service': service,
      'Visit_Type': visitType,
      'Visit_Date': visitDate,
      'Visit_Status': visitStatus,
      'Created_At': createdAt,
    };
  }

  // Copy with updated status (for status updates)
  Visit copyWith({String? visitStatus}) {
    return Visit(
      visitId: visitId,
      leadId: leadId,
      patientName: patientName,
      mobileNumber: mobileNumber,
      service: service,
      visitType: visitType,
      visitDate: visitDate,
      visitStatus: visitStatus ?? this.visitStatus,
      createdAt: createdAt,
    );
  }
}
