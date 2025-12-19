class UserModel {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final int? age;
  final String? gender;
  final String? address;
  final String role;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    this.age,
    this.gender,
    this.address,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      name: map['name'],
      email: map['email'],
      age: map['age'],
      gender: map['gender'],
      address: map['address'],
      role: map['role'] ?? 'patient',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'address': address,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
