class AuditLogModel {
  final String id;
  final String? userId; // Could be admin, nurse, or patient
  final String action;
  final String? details;
  final DateTime createdAt;

  AuditLogModel({
    required this.id,
    this.userId,
    required this.action,
    this.details,
    required this.createdAt,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: json['id'],
      userId: json['user_id'],
      action: json['action'],
      details: json['details'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'action': action,
      'details': details,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
