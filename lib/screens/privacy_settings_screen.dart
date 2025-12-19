import 'package:flutter/material.dart';
import '../utils/colors.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _profileVisible = true;
  bool _shareDataWithDoctors = true;
  bool _receiveMarketingEmails = false;
  bool _allowAnalytics = true;
  bool _biometricLogin = true;
  String _dataRetentionPeriod = '2 years';

  final List<String> _retentionOptions = [
    '6 months',
    '1 year',
    '2 years',
    '5 years',
    'Indefinite',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
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
                    'Privacy & Security',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Control your privacy settings and data sharing preferences.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Privacy Settings
            _buildSection('Privacy Controls', [
              _buildSwitchTile(
                'Profile Visibility',
                'Make your profile visible to healthcare providers',
                _profileVisible,
                (value) => setState(() => _profileVisible = value),
              ),
              _buildSwitchTile(
                'Share Data with Doctors',
                'Allow doctors to access your medical history',
                _shareDataWithDoctors,
                (value) => setState(() => _shareDataWithDoctors = value),
              ),
              _buildSwitchTile(
                'Marketing Communications',
                'Receive promotional emails and offers',
                _receiveMarketingEmails,
                (value) => setState(() => _receiveMarketingEmails = value),
              ),
            ]),

            // Security Settings
            _buildSection('Security', [
              _buildSwitchTile(
                'Biometric Login',
                'Use fingerprint or face recognition to login',
                _biometricLogin,
                (value) => setState(() => _biometricLogin = value),
              ),
              _buildSwitchTile(
                'Analytics & Usage Data',
                'Help improve our app by sharing anonymous usage data',
                _allowAnalytics,
                (value) => setState(() => _allowAnalytics = value),
              ),
            ]),

            // Data Management
            _buildSection('Data Management', [
              ListTile(
                title: const Text('Data Retention Period'),
                subtitle: const Text('How long we keep your data'),
                trailing: DropdownButton<String>(
                  value: _dataRetentionPeriod,
                  items: _retentionOptions.map((option) {
                    return DropdownMenuItem(value: option, child: Text(option));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _dataRetentionPeriod = value);
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Download My Data'),
                subtitle: const Text('Get a copy of all your data'),
                trailing: const Icon(Icons.download),
                onTap: _downloadData,
              ),
              ListTile(
                title: const Text('Delete My Account'),
                subtitle: const Text(
                  'Permanently delete your account and data',
                ),
                trailing: const Icon(Icons.delete_forever, color: Colors.red),
                onTap: _deleteAccount,
              ),
            ]),

            const SizedBox(height: 32),

            // Save Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Settings',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
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

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
    );
  }

  void _downloadData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Data'),
        content: const Text(
          'We will prepare your data and send it to your registered email address. This may take up to 24 hours.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data download request submitted!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Request Download'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action cannot be undone. All your data, medical records, and account information will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion request submitted!'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy settings saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }
}
