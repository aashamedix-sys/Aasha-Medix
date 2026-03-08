class NurseModel {
  final String id;
  final String name;
  final String specialization;
  final List<String> serviceArea;
  final bool isAvailable;

  NurseModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.serviceArea,
    required this.isAvailable,
  });

  factory NurseModel.fromJson(Map<String, dynamic> json) {
    return NurseModel(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      serviceArea: List<String>.from(json['service_area'] ?? []),
      isAvailable: json['is_available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'service_area': serviceArea,
      'is_available': isAvailable,
    };
  }
}
