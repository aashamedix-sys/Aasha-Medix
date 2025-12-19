import 'package:flutter/material.dart';
import '../utils/colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.primary.withValues(alpha: 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How can we help you?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find answers to common questions or contact our support team.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Actions
            _buildSection('Quick Actions', [
              _buildActionTile(
                'Call Support',
                'Speak directly with our support team',
                Icons.phone,
                () => _callSupport(context),
              ),
              _buildActionTile(
                'Live Chat',
                'Chat with our AI assistant',
                Icons.chat,
                () => _startLiveChat(context),
              ),
              _buildActionTile(
                'Emergency',
                'For medical emergencies',
                Icons.emergency,
                () => _emergencyCall(context),
              ),
            ]),

            // FAQ Section
            _buildSection('Frequently Asked Questions', [
              _buildExpandableTile(
                'How do I book a test?',
                'Go to the Services tab, browse available tests, and tap "Book Now" on any test card.',
              ),
              _buildExpandableTile(
                'How do I view my reports?',
                'Navigate to the Reports tab to view, download, and share your medical reports.',
              ),
              _buildExpandableTile(
                'What payment methods are accepted?',
                'We accept all major credit/debit cards, UPI, and net banking.',
              ),
              _buildExpandableTile(
                'How do I reschedule an appointment?',
                'Go to your bookings in the Profile section and select the appointment to reschedule.',
              ),
              _buildExpandableTile(
                'What should I do for home collection?',
                'Ensure someone is available at home during the selected time slot. Keep your ID ready.',
              ),
            ]),

            // Contact Information
            _buildSection('Contact Information', [
              ListTile(
                leading: const Icon(Icons.phone, color: AppColors.primary),
                title: const Text('Phone Support'),
                subtitle: const Text('+91 1800-XXX-XXXX'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _callSupport(context),
              ),
              ListTile(
                leading: const Icon(Icons.email, color: AppColors.primary),
                title: const Text('Email Support'),
                subtitle: const Text('support@aashamedix.com'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _emailSupport(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                ),
                title: const Text('Visit Our Office'),
                subtitle: const Text('123 Medical Street, Health City'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _openLocation(context),
              ),
            ]),

            // App Information
            _buildSection('App Information', [
              ListTile(
                leading: const Icon(Icons.info, color: AppColors.primary),
                title: const Text('App Version'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(
                  Icons.privacy_tip,
                  color: AppColors.primary,
                ),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _openPrivacyPolicy(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.description,
                  color: AppColors.primary,
                ),
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _openTermsOfService(context),
              ),
            ]),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildExpandableTile(String title, String content) {
    return ExpansionTile(
      title: Text(title),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            content,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
        ),
      ],
    );
  }

  void _callSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calling support...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _startLiveChat(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting live chat...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _emergencyCall(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Call'),
        content: const Text(
          'For medical emergencies, please call 108 (India) or your local emergency number immediately.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _emailSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening email client...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _openLocation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening location...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _openPrivacyPolicy(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening privacy policy...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _openTermsOfService(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening terms of service...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
