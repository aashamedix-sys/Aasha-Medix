import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/shared_ui_components.dart';

class PilotLearningDashboard extends StatefulWidget {
  const PilotLearningDashboard({super.key});

  @override
  State<PilotLearningDashboard> createState() => _PilotLearningDashboardState();
}

class _PilotLearningDashboardState extends State<PilotLearningDashboard> {
  // Mock data for the learning dashboard
  final Map<String, dynamic> _learningData = {
    'acquisition': {
      'WhatsApp': 45,
      'Referral': 30,
      'Clinic': 15,
      'Doctor': 10,
    },
    'efficiency': {
      'avg_assignment': '42 mins',
      'avg_completion': '3.2 hrs',
      'lag_report': '18 hrs',
    },
    'retention': {
      'repeat_rate': '22%',
      'diversity_rate': '12%',
    },
    'economics': {
      'avg_margin': '₹240',
      'margin_pct': '18%',
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Engine', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('📈 Patient Acquisition'),
            _buildAcquisitionChart(),
            const SizedBox(height: 24),
            _buildSectionHeader('⏱️ Operational Efficiency'),
            _buildEfficiencyStats(),
            const SizedBox(height: 24),
            _buildSectionHeader('♻️ Retention & Loyalty'),
            _buildRetentionStats(),
            const SizedBox(height: 24),
            _buildSectionHeader('💰 Unit Economics'),
            _buildEconomicsStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAcquisitionChart() {
    final sources = _learningData['acquisition'] as Map<String, int>;
    return Card(
      elevation: 2,
      child: Column(
        children: sources.entries.map((e) {
          return ListTile(
            title: Text(e.key),
            trailing: Text('${e.value}%', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: LinearProgressIndicator(
              value: e.value / 100,
              backgroundColor: Colors.grey[200],
              color: AppColors.primary,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEfficiencyStats() {
    return _buildStatGrid([
      {'label': 'Assignment', 'value': _learningData['efficiency']['avg_assignment'], 'icon': Icons.assignment_ind},
      {'label': 'Completion', 'value': _learningData['efficiency']['avg_completion'], 'icon': Icons.check_circle},
      {'label': 'Report Lag', 'value': _learningData['efficiency']['lag_report'], 'icon': Icons.description},
    ]);
  }

  Widget _buildRetentionStats() {
    return _buildStatGrid([
      {'label': 'Repeat Rate', 'value': _learningData['retention']['repeat_rate'], 'icon': Icons.forward_to_inbox},
      {'label': 'Cross-Service', 'value': _learningData['retention']['diversity_rate'], 'icon': Icons.grid_view},
    ]);
  }

  Widget _buildEconomicsStats() {
    return _buildStatGrid([
      {'label': 'Avg Margin', 'value': _learningData['economics']['avg_margin'], 'icon': Icons.payments},
      {'label': 'Margin %', 'value': _learningData['economics']['margin_pct'], 'icon': Icons.trending_up},
    ], color: Colors.green);
  }

  Widget _buildStatGrid(List<Map<String, dynamic>> items, {Color color = AppColors.primary}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(item['icon'], color: color.withOpacity(0.7), size: 20),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['label'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    Text(item['value'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
