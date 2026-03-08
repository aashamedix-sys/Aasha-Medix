import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/shared_ui_components.dart';

class PartnerDashboardScreen extends StatefulWidget {
  final String partnerType; // 'lab', 'pharmacy', 'doctor', 'nurse'
  const PartnerDashboardScreen({super.key, required this.partnerType});

  @override
  State<PartnerDashboardScreen> createState() => _PartnerDashboardScreenState();
}

class _PartnerDashboardScreenState extends State<PartnerDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.partnerType.toUpperCase()} Portal', style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
            onPressed: () => _showEarnings(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickStats(),
            const SizedBox(height: 24),
            Text('Pending Assignments', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildAssignmentsList(),
            const SizedBox(height: 24),
            Text('Performance Snapshot', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildPerformanceCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _QuickStatCard(
          title: 'Active',
          value: '3',
          icon: Icons.pending_actions,
          color: Colors.orange,
        ),
        const SizedBox(width: 12),
        _QuickStatCard(
          title: 'Completed',
          value: '124',
          icon: Icons.check_circle_outline,
          color: Colors.green,
        ),
        const SizedBox(width: 12),
        _QuickStatCard(
          title: 'Earnings',
          value: '₹12.4k',
          icon: Icons.payments_outlined,
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildAssignmentsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text('New Patient Booking #${1024 + index}', 
                        style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                const Text('Service: Full Body Checkup'),
                Text('Scheduled: Today, 1${index + 1}:00 AM'),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('ACCEPT'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPerformanceCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _PerformanceRow(label: 'Avg Turnaround', value: '14.2 hrs', icon: Icons.timer),
            const Divider(),
            _PerformanceRow(label: 'Customer Rating', value: '4.8 / 5.0', icon: Icons.star, color: Colors.amber),
            const Divider(),
            _PerformanceRow(label: 'Service Success', value: '98.5%', icon: Icons.trending_up, color: Colors.green),
          ],
        ),
      ),
    );
  }

  void _showEarnings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Earnings Breakdown', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _EarningItem(label: 'Gross Service Value', value: '₹14,500'),
            _EarningItem(label: 'Platform Commission (15%)', value: '-₹2,175', color: Colors.red),
            const Divider(),
            _EarningItem(label: 'Net Payables', value: '₹12,325', isBold: true),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('PROCEED TO SETTLEMENT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _QuickStatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

class _PerformanceRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;
  const _PerformanceRow({required this.label, required this.value, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color ?? Colors.grey[600]),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.black87)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _EarningItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isBold;
  const _EarningItem({required this.label, required this.value, this.color, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
