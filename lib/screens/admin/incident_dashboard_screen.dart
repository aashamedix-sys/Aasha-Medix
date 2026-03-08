import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/shared_ui_components.dart';

class IncidentDashboardScreen extends StatefulWidget {
  const IncidentDashboardScreen({super.key});

  @override
  State<IncidentDashboardScreen> createState() => _IncidentDashboardScreenState();
}

class _IncidentDashboardScreenState extends State<IncidentDashboardScreen> {
  // Mock data for UI demonstration. In production, this would be a Stream/Future from Supabase.
  final List<Map<String, dynamic>> _incidents = [
    {
      'id': 'INC-001',
      'severity': 'P1',
      'category': 'app_crash',
      'description': 'App crashing on login for Android 10 users.',
      'status': 'investigating',
      'created_at': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': 'INC-002',
      'severity': 'P2',
      'category': 'staff_no_show',
      'description': 'Nurse failed to arrive at Suryapet Central booking #123.',
      'status': 'open',
      'created_at': DateTime.now().subtract(const Duration(hours: 5)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incident Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildSummaryCards(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _incidents.length,
              itemBuilder: (context, index) {
                final incident = _incidents[index];
                return _IncidentCard(incident: incident);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new incident manually
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.primary.withOpacity(0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatCard(label: 'Open', value: '1', color: Colors.red),
          _StatCard(label: 'Investigating', value: '1', color: Colors.orange),
          _StatCard(label: 'Resolved Today', value: '0', color: Colors.green),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _IncidentCard extends StatelessWidget {
  final Map<String, dynamic> incident;

  const _IncidentCard({required this.incident});

  @override
  Widget build(BuildContext context) {
    final severityColor = incident['severity'] == 'P1' ? Colors.red : Colors.orange;
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    incident['severity'],
                    style: TextStyle(color: severityColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Text(
                  incident['status'].toString().toUpperCase(),
                  style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              incident['category'].toString().replaceAll('_', ' ').toUpperCase(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              incident['description'],
              style: TextStyle(color: Colors.grey[800], fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reported ${_formatDate(incident['created_at'])}',
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                TextButton(
                  onPressed: () {
                    // Open details / Update status
                  },
                  child: const Text('Resolve'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
