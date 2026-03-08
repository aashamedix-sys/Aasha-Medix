class DoctorModel {
  final String id;
  final String name;
  final String specialization;
  final double fee;
  final List<String> availableDays;
  final bool isAvailable;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.fee,
    required this.availableDays,
    required this.isAvailable,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      fee: (json['fee'] as num).toDouble(),
      availableDays: List<String>.from(json['available_days'] ?? []),
      isAvailable: json['is_available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'fee': fee,
      'available_days': availableDays,
      'is_available': isAvailable,
    };
  }
}
