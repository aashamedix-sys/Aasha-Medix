class TestItem {
  final String testId;
  final String testName;
  final String category;
  final String sampleType;
  final String reportingTime;
  final double price;
  final String description;
  final bool isPopular;
  final bool isActive;

  const TestItem({
    required this.testId,
    required this.testName,
    required this.category,
    required this.sampleType,
    required this.reportingTime,
    required this.price,
    required this.description,
    this.isPopular = false,
    this.isActive = true,
  });

  factory TestItem.fromMap(Map<String, dynamic> map) {
    return TestItem(
      testId: map['test_id'] ?? map['id'] ?? '',
      testName: map['test_name'] ?? '',
      category: map['category'] ?? '',
      sampleType: map['sample_type'] ?? '',
      reportingTime: map['tat'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      isPopular: map['is_popular'] ?? false,
      isActive: map['status'] == 'active',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'test_id': testId,
      'test_name': testName,
      'category': category,
      'sample_type': sampleType,
      'tat': reportingTime,
      'price': price,
      'description': description,
      'is_popular': isPopular,
      'status': isActive ? 'active' : 'inactive',
    };
  }
}

class HealthPackage {
  final String packageId;
  final String packageName;
  final List<String> includedTests; // List of test IDs
  final double originalPrice;
  final double discountedPrice;
  final String description;

  const HealthPackage({
    required this.packageId,
    required this.packageName,
    required this.includedTests,
    required this.originalPrice,
    required this.discountedPrice,
    required this.description,
  });

  double get savings => originalPrice - discountedPrice;

  factory HealthPackage.fromMap(Map<String, dynamic> map) {
    return HealthPackage(
      packageId: map['package_id'] ?? map['id'] ?? '',
      packageName: map['package_name'] ?? '',
      includedTests: List<String>.from(map['included_tests'] ?? []),
      originalPrice: (map['original_price'] ?? 0.0).toDouble(),
      discountedPrice: (map['discounted_price'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'package_id': packageId,
      'package_name': packageName,
      'included_tests': includedTests,
      'original_price': originalPrice,
      'discounted_price': discountedPrice,
      'description': description,
    };
  }
}
