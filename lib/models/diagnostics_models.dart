class TestItem {
  final String testId;
  final String testName;
  final String category;
  final String sampleType;
  final String reportingTime;
  final double price;
  final String description;
  final bool isPopular;

  const TestItem({
    required this.testId,
    required this.testName,
    required this.category,
    required this.sampleType,
    required this.reportingTime,
    required this.price,
    required this.description,
    this.isPopular = false,
  });

  factory TestItem.fromMap(Map<String, dynamic> map) {
    return TestItem(
      testId: map['testId'] ?? '',
      testName: map['testName'] ?? '',
      category: map['category'] ?? '',
      sampleType: map['sampleType'] ?? '',
      reportingTime: map['reportingTime'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      isPopular: map['isPopular'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'testId': testId,
      'testName': testName,
      'category': category,
      'sampleType': sampleType,
      'reportingTime': reportingTime,
      'price': price,
      'description': description,
      'isPopular': isPopular,
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
      packageId: map['packageId'] ?? '',
      packageName: map['packageName'] ?? '',
      includedTests: List<String>.from(map['includedTests'] ?? []),
      originalPrice: (map['originalPrice'] ?? 0.0).toDouble(),
      discountedPrice: (map['discountedPrice'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'packageId': packageId,
      'packageName': packageName,
      'includedTests': includedTests,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'description': description,
    };
  }
}
