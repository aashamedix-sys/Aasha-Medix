// MOCK DATA WARNING — Phase 2 (v2.1)
// The zone data below is HARDCODED. It does not reflect real database records.
// TODO(Phase 4): Replace `_zones` with a Supabase query to a `zones` or
// `regions` table. Until that table and query exist, the data on this screen
// is illustrative only and MUST NOT be presented to end-users as real metrics.
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/shared_ui_components.dart';

class RegionalOperationsDashboard extends StatefulWidget {
  const RegionalOperationsDashboard({super.key});

  @override
  State<RegionalOperationsDashboard> createState() => _RegionalOperationsDashboardState();
}

class _RegionalOperationsDashboardState extends State<RegionalOperationsDashboard> {
  // TODO(Phase 4): Replace with Supabase query to `zones` table
  // ignore: unused_field -- retained to prevent blank screen; remove when table exists
  final List<Map<String, dynamic>> _zones = [
    {
      'city': 'Suryapet',
      'name': 'Central Suryapet',
      'bookings': 142,
      'completion': 94.2,
      'tat': '1.2h',
      'rating': 4.8,
      'status': 'active',
      'load': 12,
      'capacity': 100,
      'margin': '22%'
    },
    {
      'city': 'Nalgonda',
      'name': 'Nalgonda Main',
      'bookings': 56,
      'completion': 88.5,
      'tat': '2.1h',
      'rating': 4.5,
      'status': 'active',
      'load': 8,
      'capacity': 50,
      'margin': '18%'
    },
    {
      'city': 'Khammam',
      'name': 'Khammam West',
      'bookings': 0,
      'completion': 0.0,
      'tat': 'N/A',
      'rating': 0.0,
      'status': 'paused',
      'load': 0,
      'capacity': 30,
      'margin': '0%'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Operations', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildNetworkSummary(),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _zones.length,
              itemBuilder: (context, index) {
                final zone = _zones[index];
                return _ZoneOperationCard(zone: zone);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Launch new zone workflow
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_location_alt, color: Colors.white),
        label: const Text('New Zone', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildNetworkSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      color: Colors.grey[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(label: 'Active Zones', value: '2', color: AppColors.primary),
          _Stat(label: 'Total Bookings', value: '198', color: Colors.black),
          _Stat(label: 'Avg Completion', value: '91.3%', color: Colors.green),
          _Stat(label: 'Health Index', value: 'A+', color: Colors.blue),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

class _ZoneOperationCard extends StatelessWidget {
  final Map<String, dynamic> zone;
  const _ZoneOperationCard({required this.zone});

  @override
  Widget build(BuildContext context) {
    final bool isPaused = zone['status'] == 'paused';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Opacity(
        opacity: isPaused ? 0.7 : 1.0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(zone['city'].toString().toUpperCase(), 
                               style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          Text(zone['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      _StatusChip(status: zone['status']),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Metric(label: 'Bookings', value: zone['bookings'].toString()),
                      _Metric(label: 'Completion', value: '${zone['completion']}%'),
                      _Metric(label: 'TAT', value: zone['tat']),
                      _Metric(label: 'Margin', value: zone['margin'], color: Colors.green),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Daily Load: ${zone['load']} / ${zone['capacity']}', 
                       style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: zone['load'] / zone['capacity'],
                    backgroundColor: Colors.grey[200],
                    color: (zone['load'] / zone['capacity']) > 0.8 ? Colors.red : AppColors.primary,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(onPressed: () {}, icon: const Icon(Icons.edit, size: 16), label: const Text('Edit')),
                  TextButton.icon(
                    onPressed: () {}, 
                    icon: Icon(isPaused ? Icons.play_arrow : Icons.pause, size: 16), 
                    label: Text(isPaused ? 'Activate' : 'Pause')
                  ),
                  TextButton.icon(onPressed: () {}, icon: const Icon(Icons.analytics, size: 16), label: const Text('Analytics')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _Metric({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == 'active' ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }
}
