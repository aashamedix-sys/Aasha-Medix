import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../providers/auth_provider.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'privacy_settings_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.userProfile;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: user),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(46, 125, 50, 0.05),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      (user.name ?? 'U').split(' ').map((e) => e[0]).join(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name ?? 'User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email ?? 'No email',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Profile Options
            _buildProfileSection('Personal Information', [
              _buildProfileItem(
                'Full Name',
                user.name ?? 'Not provided',
                Icons.person,
              ),
              _buildProfileItem(
                'Email',
                user.email ?? 'Not provided',
                Icons.email,
              ),
              _buildProfileItem('Phone', user.phoneNumber, Icons.phone),
              _buildProfileItem(
                'Age',
                user.age?.toString() ?? 'Not provided',
                Icons.calendar_today,
              ),
              _buildProfileItem(
                'Gender',
                user.gender ?? 'Not provided',
                Icons.people,
              ),
            ]),

            _buildProfileSection('Contact & Address', [
              _buildProfileItem(
                'Address',
                user.address ?? 'Not provided',
                Icons.location_on,
              ),
            ]),

            // Medical Information
            _buildProfileSection('Medical Information', [
              _buildProfileItem('Blood Group', 'O+', Icons.bloodtype),
              _buildProfileItem('Allergies', 'None', Icons.warning),
              _buildProfileItem(
                'Chronic Conditions',
                'None',
                Icons.medical_services,
              ),
              _buildProfileItem(
                'Current Medications',
                'None',
                Icons.medication,
              ),
            ]),

            // Emergency Contacts
            _buildProfileSection('Emergency Contacts', [
              _buildProfileItem(
                'Primary Contact',
                '+91 9876543211\nJane Doe (Wife)',
                Icons.contact_emergency,
              ),
              _buildProfileItem(
                'Secondary Contact',
                '+91 9876543212\nMike Doe (Brother)',
                Icons.contact_phone,
              ),
            ]),

            // Recent Activity
            _buildProfileSection('Recent Activity', [
              _buildActivityItem(
                'Blood Test Booked',
                '2 days ago',
                Icons.science,
              ),
              _buildActivityItem(
                'Report Downloaded',
                '5 days ago',
                Icons.download,
              ),
              _buildActivityItem(
                'Appointment Completed',
                '1 week ago',
                Icons.check_circle,
              ),
            ]),

            // Account Actions
            Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildActionButton('Change Password', Icons.lock, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  _buildActionButton('Privacy Settings', Icons.privacy_tip, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacySettingsScreen(),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  _buildActionButton('Help & Support', Icons.help, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpSupportScreen(),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  _buildActionButton('Logout', Icons.logout, () {
                    _showLogoutDialog();
                  }, isDestructive: true),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B5E20),
              ),
            ),
          ),
          Card(child: Column(children: items)),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        label,
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(
            color: isDestructive ? Colors.red : Colors.grey[300]!,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isDestructive ? Colors.red : AppColors.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isDestructive ? Colors.red : AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }

    // Navigation will happen automatically due to auth state change
  }
}
