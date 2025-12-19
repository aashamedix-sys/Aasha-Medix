import 'package:flutter/material.dart';
import '../models/diagnostics_models.dart';
import '../data/diagnostics_data.dart';
import '../models/booking_summary_model.dart';
import 'booking_summary_screen.dart';

class DiagnosticsScreen extends StatefulWidget {
  const DiagnosticsScreen({super.key});

  @override
  State<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends State<DiagnosticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  List<TestItem> _allTests = [];
  List<HealthPackage> _allPackages = [];
  List<TestItem> _filteredTests = [];
  List<HealthPackage> _filteredPackages = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() {
    _allTests = DiagnosticsData.getCommonTests();
    _allPackages = DiagnosticsData.getHealthPackages();
    _filteredTests = _allTests;
    _filteredPackages = _allPackages;
  }

  void _filterTests(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTests = _allTests;
      } else {
        _filteredTests = _allTests.where((test) {
          return test.testName.toLowerCase().contains(query.toLowerCase()) ||
              test.category.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _filterPackages(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPackages = _allPackages;
      } else {
        _filteredPackages = _allPackages.where((package) {
          return package.packageName.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              package.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_tabController.index == 0) {
      _filterTests(query);
    } else {
      _filterPackages(query);
    }
  }

  void _bookTest(TestItem test) {
    // Collect booking date and time
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 10, minute: 0),
      ).then((pickedTime) {
        if (pickedTime == null) return;
        final String formattedTime = pickedTime.format(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingSummaryScreen(
              serviceType: ServiceType.diagnostics,
              testOrPackage: test.testName,
              bookingDate: pickedDate,
              bookingTime: formattedTime,
            ),
          ),
        );
      });
    });
  }

  void _bookPackage(HealthPackage package) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 10, minute: 0),
      ).then((pickedTime) {
        if (pickedTime == null) return;
        final String formattedTime = pickedTime.format(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingSummaryScreen(
              serviceType: ServiceType.diagnostics,
              testOrPackage: package.packageName,
              bookingDate: pickedDate,
              bookingTime: formattedTime,
            ),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostics'),
        backgroundColor: const Color(0xFF2E7D32),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tests'),
            Tab(text: 'Packages'),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildTestsTab(), _buildPackagesTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredTests.length,
      itemBuilder: (context, index) {
        final test = _filteredTests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  test.testName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (test.isPopular)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Popular',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            test.category,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            test.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${test.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.science, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      test.sampleType,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      test.reportingTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _bookTest(test),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Book Now'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPackagesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredPackages.length,
      itemBuilder: (context, index) {
        final package = _filteredPackages[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            package.packageName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${package.includedTests.length} tests included',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${package.discountedPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        Text(
                          '₹${package.originalPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          'Save ₹${package.savings.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  package.description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _bookPackage(package),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Book Package'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
