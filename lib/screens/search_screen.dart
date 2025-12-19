import 'package:flutter/material.dart';
import '../widgets/test_card.dart';
import '../models/test_model.dart';
import '../utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<TestModel> _searchResults = [];
  bool _isSearching = false;

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
      description: 'TSH, T3, T4 levels assessment',
      price: 550,
      category: 'Thyroid',
      sampleType: 'Blood',
      timeRequired: 15,
      preparation: 'No special preparation required',
    ),
    TestModel(
      id: '4',
      name: 'Blood Glucose (Fasting)',
      description: 'Fasting blood sugar level test',
      price: 150,
      category: 'Diabetes',
      sampleType: 'Blood',
      timeRequired: 10,
      preparation: 'Fasting required for 8-12 hours',
    ),
    TestModel(
      id: '5',
      name: 'Urine Routine',
      description: 'Complete urine analysis',
      price: 200,
      category: 'Urine Tests',
      sampleType: 'Urine',
      timeRequired: 10,
      preparation: 'Clean catch midstream urine sample',
    ),
    TestModel(
      id: '6',
      name: 'Chest X-Ray',
      description: 'Digital chest X-ray imaging',
      price: 800,
      category: 'Imaging',
      sampleType: 'Imaging',
      timeRequired: 30,
      preparation: 'Remove metal objects from chest area',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _isSearching = _searchQuery.isNotEmpty;
      if (_isSearching) {
        _searchResults = _allTests.where((test) {
          final query = _searchQuery.toLowerCase();
          return test.name.toLowerCase().contains(query) ||
              test.description.toLowerCase().contains(query) ||
              test.category.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Tests'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search for tests, conditions, or categories...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_isSearching) {
      return _buildSearchSuggestions();
    }

    if (_searchResults.isEmpty) {
      return _buildNoResults();
    }

    return _buildSearchResults();
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Searches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Blood Test',
              'Diabetes',
              'Thyroid',
              'Cholesterol',
              'Urine Test',
              'X-Ray',
              'CBC',
              'Lipid Profile',
            ].map((suggestion) => _buildSuggestionChip(suggestion)).toList(),
          ),
          const SizedBox(height: 32),
          const Text(
            'Browse by Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Blood Tests',
              'Urine Tests',
              'Imaging',
              'Cardiac',
              'Diabetes',
              'Thyroid',
              'Liver',
              'Kidney',
            ].map((category) => _buildCategoryChip(category)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String suggestion) {
    return ActionChip(
      label: Text(suggestion),
      onPressed: () {
        _searchController.text = suggestion;
      },
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      labelStyle: const TextStyle(color: AppColors.primary),
    );
  }

  Widget _buildCategoryChip(String category) {
    return FilterChip(
      label: Text(category),
      onSelected: (selected) {
        if (selected) {
          _searchController.text = category;
        }
      },
      backgroundColor: Colors.grey[100],
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No tests found for "$_searchQuery"',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final test = _searchResults[index];
        return TestCard(
          test: test,
          onTap: () {
            // Navigate to test details
          },
          onBookNow: () {
            // Navigate to booking
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Booking ${test.name}...'),
                backgroundColor: AppColors.primary,
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
