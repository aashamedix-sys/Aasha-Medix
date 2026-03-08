import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/shared_ui_components.dart';

class PlatformHealthDashboard extends StatefulWidget {
  const PlatformHealthDashboard({super.key});

  @override
  State<PlatformHealthDashboard> createState() => _PlatformHealthDashboardState();
}

class _PlatformHealthDashboardState extends State<PlatformHealthDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Governance', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReliabilitySection(),
            const SizedBox(height: 24),
            _buildSectionHeader('Operational Health'),
            _buildHealthGrid(),
            const SizedBox(height: 24),
            _buildSectionHeader('System Stability'),
            _buildStabilityList(),
            const SizedBox(height: 24),
            _buildIncidentAlertBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title.toUpperCase(), 
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey[600], letterSpacing: 1.2)),
    );
  }

  Widget _buildReliabilitySection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall Reliability', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('98.4%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
              Icon(Icons.verified_user_outlined, size: 48, color: Colors.green.withOpacity(0.2)),
            ],
          ),
          const SizedBox(height: 20),
          const LinearProgressIndicator(value: 0.984, backgroundColor: Colors.greenAccent, color: Colors.green, minHeight: 8),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Target: 95.0%', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('30-Day Avg', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _HealthCard(title: 'Active Cities', value: '4', icon: Icons.location_city, color: Colors.blue),
        _HealthCard(title: 'Partner Rating', value: '4.82', icon: Icons.star, color: Colors.amber),
        _HealthCard(title: 'Active Alerts', value: '2', icon: Icons.notifications_active, color: Colors.red),
        _HealthCard(title: 'Revenue (MTD)', value: '₹2.4L', icon: Icons.payments, color: Colors.green),
      ],
    );
  }

  Widget _buildStabilityList() {
    return Column(
      children: [
        _StabilityItem(label: 'API Latency', value: '42ms', status: 'Optimal'),
        _StabilityItem(label: 'Database Load', value: '14%', status: 'Low'),
        _StabilityItem(label: 'Realtime Latency', value: '118ms', status: 'Stable'),
        _StabilityItem(label: 'Backup Status', value: '02:00 AM', status: 'Verified'),
      ],
    );
  }

  Widget _buildIncidentAlertBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: const Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 12),
          Expanded(
            child: Text('2 active P2 incidents require attention in the Suryapet zone.',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          Icon(Icons.chevron_right, color: Colors.red),
        ],
      ),
    );
  }
}

class _HealthCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _HealthCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _StabilityItem extends StatelessWidget {
  final String label;
  final String value;
  final String status;
  const _StabilityItem({required this.label, required this.value, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.blueGrey)),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(4)),
            child: Text(status, style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
