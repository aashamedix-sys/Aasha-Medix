import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/shared_ui_components.dart';

class AutomationDashboardScreen extends StatefulWidget {
  const AutomationDashboardScreen({super.key});

  @override
  State<AutomationDashboardScreen> createState() => _AutomationDashboardScreenState();
}

class _AutomationDashboardScreenState extends State<AutomationDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Automation Layer', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAIAssistantSummary(),
            const SizedBox(height: 24),
            _buildSectionHeader('📈 Demand Forecasting (Next 24h)'),
            _buildForecastCard(),
            const SizedBox(height: 24),
            _buildSectionHeader('🛡️ Operational Anomaly Alerts'),
            _buildAnomalyList(),
            const SizedBox(height: 24),
            _buildSectionHeader('🤖 Routing Optimizations'),
            _buildRoutingRecommendations(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAIAssistantSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text('AI Assistant Overview', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Operational health is stable. Predicted peak in Nalgonda between 4 PM - 6 PM today. One report delay detected for Suryapet Main Lab.',
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ForecastItem(label: 'Nursing (Nalgonda)', time: '16:00 - 18:00', status: 'PEAK', color: Colors.orange),
            const Divider(),
            _ForecastItem(label: 'Diagnostics (Suryapet)', time: '08:00 - 10:00', status: 'NORMAL', color: Colors.green),
            const Divider(),
            _ForecastItem(label: 'Doctors (Regional)', time: '11:00 - 13:00', status: 'LOW', color: Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildAnomalyList() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _AnomalyCard(type: 'DELAYED_REPORT', detail: 'Suryapet Main Lab - B-1024 (>24h)', severity: 'CRITICAL'),
        _AnomalyCard(type: 'LOW_RATING', detail: 'Staff #N-402 received 2.0 stars in Nalgonda', severity: 'WARNING'),
      ],
    );
  }

  Widget _buildRoutingRecommendations() {
    return Column(
      children: [
        _RoutingCard(provider: 'Nalgonda Diagnostics', score: 94.2, reason: 'Lowest TAT in zone'),
        _RoutingCard(provider: 'Central Pharma', score: 91.5, reason: '100% Delivery Success'),
      ],
    );
  }
}

class _ForecastItem extends StatelessWidget {
  final String label;
  final String time;
  final String status;
  final Color color;
  const _ForecastItem({required this.label, required this.time, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
            child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _AnomalyCard extends StatelessWidget {
  final String type;
  final String detail;
  final String severity;
  const _AnomalyCard({required this.type, required this.detail, required this.severity});

  @override
  Widget build(BuildContext context) {
    final color = severity == 'CRITICAL' ? Colors.red : Colors.orange;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(severity == 'CRITICAL' ? Icons.error_outline : Icons.warning_amber_rounded, color: color),
        title: Text(type, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
        subtitle: Text(detail, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, size: 16),
      ),
    );
  }
}

class _RoutingCard extends StatelessWidget {
  final String provider;
  final double score;
  final String reason;
  const _RoutingCard({required this.provider, required this.score, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 4,
              backgroundColor: Colors.grey[200],
              color: AppColors.primary,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(provider, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(reason, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const Spacer(),
            Text('${score.toStringAsFixed(1)}%', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}
