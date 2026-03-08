// MOCK DATA WARNING — Phase 2 (v2.1)
// The readiness indicators below are HARDCODED. They do not come from Supabase.
// TODO(Phase 4): Replace `_readinessItems` with a Supabase query to a
// `scale_readiness_metrics` or `admin_kpis` table. Until that exists, the
// data on this screen is illustrative only and MUST NOT be presented as real.
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/shared_ui_components.dart';

class ExpansionDashboardScreen extends StatefulWidget {
  const ExpansionDashboardScreen({super.key});

  @override
  State<ExpansionDashboardScreen> createState() => _ExpansionDashboardScreenState();
}

class _ExpansionDashboardScreenState extends State<ExpansionDashboardScreen> {
  // TODO(Phase 4): Replace with Supabase query to admin KPI table
  final List<Map<String, dynamic>> _readinessItems = [
    {'category': 'Quality', 'metric': 'Avg Health Score', 'value': '88/100', 'status': 'READY'},
    {'category': 'Retention', 'metric': 'Repeat User Rate', 'value': '24%', 'status': 'READY'},
    {'category': 'Economics', 'metric': 'Net Margin (Avg)', 'value': '18.2%', 'status': 'READY'},
    {'category': 'Capacity', 'metric': 'Current Load', 'value': '32%', 'status': 'READY'},
    {'category': 'Growth', 'metric': 'K-Factor', 'value': '0.15', 'status': 'PENDING'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scale Readiness', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallStatus(),
            const SizedBox(height: 24),
            const Text('Readiness Indicators', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._readinessItems.map((item) => _buildReadinessCard(item)),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.verified, color: Colors.green, size: 48),
          const SizedBox(height: 12),
          const Text(
            'GO FOR EXPANSION',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 4),
          Text(
            '4 of 5 key indicators met. Minimal risk detected.',
            style: TextStyle(color: Colors.green[800], fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildReadinessCard(Map<String, dynamic> item) {
    final isReady = item['status'] == 'READY';
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isReady ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
          child: Icon(
            isReady ? Icons.check : Icons.hourglass_empty,
            color: isReady ? Colors.green : Colors.orange,
            size: 20,
          ),
        ),
        title: Text(item['metric'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(item['category'], style: const TextStyle(fontSize: 12)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(item['value'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(
              item['status'],
              style: TextStyle(
                color: isReady ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('View Playbook'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Generate Report'),
          ),
        ),
      ],
    );
  }
}
