import 'package:flutter/material.dart';
import '../widgets/test_card.dart';
import '../models/test_model.dart';
import '../utils/colors.dart';
import 'search_screen.dart';
import 'cart_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final List<String> _categories = [
    'All',
    'Blood Tests',
    'Urine Tests',
    'Imaging',
    'Cardiac',
    'Diabetes',
    'Thyroid',
    'Liver',
    'Kidney',
  ];

  String _selectedCategory = 'All';

  void _bookTest(TestModel test) {
    // Navigate to booking confirmation screen - Create a temporary booking model
    // NOTE: Update to use new booking flow via diagnostics_screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please use Diagnostics tab to book tests'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Sample test data - in real app this would come from API
  final List<TestModel> _allTests = [
    TestModel(
      id: '1',
      name: 'Complete Blood Count (CBC)',
      description:
          'Comprehensive blood analysis including hemoglobin, WBC, RBC counts',
      price: 450,
      category: 'Blood Tests',
      sampleType: 'Blood',
      timeRequired: 15,
      preparation: 'Fasting required for 8-12 hours',
    ),
    TestModel(
      id: '2',
      name: 'Lipid Profile',
      description: 'Cholesterol and triglyceride levels assessment',
      price: 650,
      category: 'Cardiac',
      sampleType: 'Blood',
      timeRequired: 15,
      preparation: 'Fasting required for 12 hours',
    ),
    TestModel(
      id: '3',
      name: 'Thyroid Function Test',
      description: 'TSH, T3, T4 levels for thyroid function evaluation',
      price: 550,
      category: 'Thyroid',
      sampleType: 'Blood',
      timeRequired: 15,
      preparation: 'No special preparation required',
    ),
    TestModel(
      id: '4',
      name: 'HbA1c (Diabetes)',
      description: 'Glycated hemoglobin test for diabetes monitoring',
      price: 400,
      category: 'Diabetes',
      sampleType: 'Blood',
      timeRequired: 10,
      preparation: 'No fasting required',
    ),
    TestModel(
      id: '5',
      name: 'Liver Function Test',
      description: 'ALT, AST, ALP, bilirubin levels for liver health',
      price: 600,
      category: 'Liver',
      sampleType: 'Blood',
      timeRequired: 15,
      preparation: 'Fasting required for 8-12 hours',
    ),
    TestModel(
      id: '6',
      name: 'Kidney Function Test',
      description: 'Creatinine, urea, electrolytes for kidney assessment',
      price: 500,
      category: 'Kidney',
      sampleType: 'Blood',
      timeRequired: 15,
      preparation: 'Fasting required for 8-12 hours',
    ),
  ];

  List<TestModel> get _filteredTests {
    if (_selectedCategory == 'All') {
      return _allTests;
    }
    return _allTests
        .where((test) => test.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Services'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color.fromRGBO(46, 125, 50, 0.1),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : Colors.grey[600],
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey[300]!,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Test List
          Expanded(
            child: _filteredTests.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tests found in $_selectedCategory',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredTests.length,
                    itemBuilder: (context, index) {
                      final test = _filteredTests[index];
                      return TestCard(
                        test: test,
                        onTap: () => _showTestDetails(test),
                        onBookNow: () => _bookTest(test),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showTestDetails(TestModel test) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(test.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                test.description,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Price', '₹${test.price}'),
              _buildDetailRow('Category', test.category),
              _buildDetailRow('Sample Type', test.sampleType),
              _buildDetailRow('Time Required', '${test.timeRequired} minutes'),
              if (test.preparation?.isNotEmpty ?? false) ...[
                const SizedBox(height: 16),
                const Text(
                  'Preparation Instructions:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(test.preparation!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _bookTest(test);
            },
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 2),
          ),
        ],
      ),
    );
  }
}
