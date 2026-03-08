import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'booking_summary_screen.dart';
import '../providers/diagnostics_provider.dart';
import '../widgets/test_card.dart';
import '../models/test_model.dart';
import '../models/diagnostics_models.dart';
import '../models/booking_model.dart';
import '../utils/colors.dart';
import '../widgets/shared_ui_components.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DiagnosticsProvider>().fetchDiagnostics();
    });
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

  Future<void> _bookTest(TestItem test) async {
    // Collect booking date and time
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (pickedTime == null || !mounted) return;

    final formattedTime = pickedTime.format(context);
    if (!mounted) return;

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
  }

  Future<void> _bookPackage(HealthPackage package) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (pickedTime == null || !mounted) return;

    final formattedTime = pickedTime.format(context);
    if (!mounted) return;

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diagnosticsProvider = context.watch<DiagnosticsProvider>();
    final isLoading = diagnosticsProvider.isLoading;
    final error = diagnosticsProvider.error;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Diagnostics'),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'All Tests'),
            Tab(text: 'Health Packages'),
          ],
        ),
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: error != null
                  ? ConnectionErrorWidget(
                      message: error.message,
                      onRetry: () => diagnosticsProvider.fetchDiagnostics(),
                    )
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTestsList(diagnosticsProvider.tests),
                        _buildPackagesList(diagnosticsProvider.packages),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search for tests or packages...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildTestsList(List<TestItem> tests) {
    final query = _searchController.text.toLowerCase();
    final filtered = tests.where((t) => 
      t.testName.toLowerCase().contains(query) || 
      t.category.toLowerCase().contains(query)
    ).toList();

    if (filtered.isEmpty && !context.read<DiagnosticsProvider>().isLoading) {
      return const Center(child: Text('No tests found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final testItem = filtered[index];
        // Convert TestItem to TestModel for TestCard
        final testModel = TestModel(
          id: testItem.testId,
          name: testItem.testName,
          category: testItem.category,
          price: testItem.price,
          description: testItem.description,
          sampleType: testItem.sampleType,
          timeRequired: testItem.reportingTime.contains('Day') ? 720 : 1440, // Rough conversion
        );

        return TestCard(
          test: testModel,
          onTap: () => _bookTest(testItem),
          onBookNow: () => _bookTest(testItem),
        );
      },
    );
  }

  Widget _buildPackagesList(List<HealthPackage> packages) {
    final query = _searchController.text.toLowerCase();
    final filtered = packages.where((p) => 
      p.packageName.toLowerCase().contains(query) || 
      p.description.toLowerCase().contains(query)
    ).toList();

    if (filtered.isEmpty && !context.read<DiagnosticsProvider>().isLoading) {
      return const Center(child: Text('No packages found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final package = filtered[index];
        return _buildPackageCard(package);
      },
    );
  }

  Widget _buildPackageCard(HealthPackage package) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.primaryGreen.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Icon(
                    Icons.health_and_safety,
                    size: 150,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        package.packageName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${package.includedTests.length} Tests Included',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.description,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${package.originalPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '₹${package.discountedPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppColors.primaryGreen,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => _bookPackage(package),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
