class NurseModel {
  final String id;
  final String name;
  final String? specialization;
  final String? qualification;
  final int experienceYears;
  final String? phone;
  final String? email;
  final String? zoneId;
  final bool isActive;

  NurseModel({
    required this.id,
    required this.name,
    this.specialization,
    this.qualification,
    this.experienceYears = 0,
    this.phone,
    this.email,
    this.zoneId,
    this.isActive = true,
  });

  factory NurseModel.fromJson(Map<String, dynamic> json) {
    return NurseModel(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      qualification: json['qualification'],
      experienceYears: json['experience_years'] ?? 0,
      phone: json['phone'],
      email: json['email'],
      zoneId: json['zone_id'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'qualification': qualification,
      'experience_years': experienceYears,
      'phone': phone,
      'email': email,
      'zone_id': zoneId,
      'is_active': isActive,
    };
  }
}

