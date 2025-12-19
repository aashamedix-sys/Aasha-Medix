class TestModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String sampleType;
  final String? preparation;
  final int timeRequired; // in minutes

  TestModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.sampleType,
    this.preparation,
    required this.timeRequired,
  });

  factory TestModel.fromMap(Map<String, dynamic> map) {
    return TestModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      sampleType: map['sampleType'] ?? '',
      preparation: map['preparation'],
      timeRequired: map['timeRequired'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'sampleType': sampleType,
      'preparation': preparation,
      'timeRequired': timeRequired,
    };
  }
}
