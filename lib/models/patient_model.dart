class PatientModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String address;
  final String? emergencyContact;
  final String? bloodGroup;
  final DateTime createdAt;
  final String? acquisitionSource;
  final String? ownReferralCode;
  
  String get phoneNumber => phone;

  PatientModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.address,
    this.emergencyContact,
    this.bloodGroup,
    required this.createdAt,
    this.acquisitionSource,
    this.ownReferralCode,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      emergencyContact: json['emergency_contact'],
      bloodGroup: json['blood_group'],
      createdAt: DateTime.parse(json['created_at']),
      acquisitionSource: json['acquisition_source'],
      ownReferralCode: json['own_referral_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'emergency_contact': emergencyContact,
      'blood_group': bloodGroup,
      'created_at': createdAt.toIso8601String(),
      'acquisition_source': acquisitionSource,
      'own_referral_code': ownReferralCode,
    };
  }
}
