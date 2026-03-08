class DiagnosticTestModel {
  final String id;
  final String testName;
  final String? description;
  final double price;
  final bool requiresFasting;

  DiagnosticTestModel({
    required this.id,
    required this.testName,
    this.description,
    required this.price,
    this.requiresFasting = false,
  });

  factory DiagnosticTestModel.fromJson(Map<String, dynamic> json) {
    return DiagnosticTestModel(
      id: json['id'],
      testName: json['test_name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      requiresFasting: json['requires_fasting'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'test_name': testName,
      'description': description,
      'price': price,
      'requires_fasting': requiresFasting,
    };
  }
}
