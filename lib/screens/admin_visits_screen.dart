import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/visit.dart';
import '../services/visits_service.dart';
import 'visit_details_screen.dart';

class AdminVisitsScreen extends StatefulWidget {
  const AdminVisitsScreen({super.key});

  @override
  State<AdminVisitsScreen> createState() => _AdminVisitsScreenState();
}

class _AdminVisitsScreenState extends State<AdminVisitsScreen> {
  List<Visit> _visits = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchVisits();
  }

  Future<void> _fetchVisits() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final visits = await VisitsService.fetchTodayVisits();
      // Sort by Visit_Date ascending
      visits.sort((a, b) => a.visitDate.compareTo(b.visitDate));

      setState(() {
        _visits = visits;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _navigateToVisitDetails(Visit visit) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VisitDetailsScreen(visit: visit)),
    ).then((_) => _fetchVisits()); // Refresh after returning
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_admin_logged_in', false);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/'); // Go back to home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Visits'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
          IconButton(
            onPressed: _fetchVisits,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $_errorMessage'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchVisits,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _visits.isEmpty
          ? const Center(child: Text('No visits scheduled for today'))
          : ListView.builder(
              itemCount: _visits.length,
              itemBuilder: (context, index) {
                final visit = _visits[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _navigateToVisitDetails(visit),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  visit.patientName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              _buildStatusBadge(visit.visitStatus),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Service: ${visit.service}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Type: ${visit.visitType} | Time: ${visit.visitDate}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'confirmed':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      case 'completed':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
