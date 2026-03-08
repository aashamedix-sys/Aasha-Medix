import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'aasha_dost_screen.dart';
import 'diagnostics_screen.dart';
import 'home_sample_screen.dart';
import 'doctor_list_screen.dart';
import 'reports_screen.dart';
import 'medicine_delivery_screen.dart';
import 'admin_login_screen.dart';
import '../widgets/language_selector.dart';
import '../widgets/app_logo.dart';
import '../l10n/app_localizations.dart';
import '../utils/colors.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../models/booking_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _handleServiceTap(BuildContext context, String service) {
    switch (service) {
      case 'Book Lab Test':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DiagnosticsScreen()),
        );
        break;
      case 'Consult Doctor':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DoctorListScreen()),
        );
        break;
      case 'Home Nursing':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeSampleScreen()),
        );
        break;
      case 'Order Medicines':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MedicineDeliveryScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const AppLogo(size: 32),
            const SizedBox(width: 12),
            Text(
              l10n.appName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          const LanguageSelectorButton(),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.grey),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await bookingProvider.fetchMyBookings();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingBanner(authProvider),
              _buildPrimaryActions(context),
              _buildRecentBooking(context, bookingProvider),
              _buildPopularTests(context),
              _buildHealthPackages(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingBanner(AuthProvider auth) {
    final name = auth.patientProfile?.name ?? 'Guest';
    final hour = DateTime.now().hour;
    String greeting = 'Good Morning';
    if (hour >= 12 && hour < 17) greeting = 'Good Afternoon';
    else if (hour >= 17) greeting = 'Good Evening';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryGreen, Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting,',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'Your Health, Our Priority',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'What are you looking for?'),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _ActionCard(
                title: 'Book Lab Test',
                icon: Icons.science_outlined,
                color: const Color(0xFFE3F2FD),
                iconColor: Colors.blue,
                onTap: () => _handleServiceTap(context, 'Book Lab Test'),
              ),
              _ActionCard(
                title: 'Consult Doctor',
                icon: Icons.personal_video_outlined,
                color: const Color(0xFFF1F8E9),
                iconColor: Colors.green,
                onTap: () => _handleServiceTap(context, 'Consult Doctor'),
              ),
              _ActionCard(
                title: 'Home Nursing',
                icon: Icons.home_repair_service_outlined,
                color: const Color(0xFFFFF3E0),
                iconColor: Colors.orange,
                onTap: () => _handleServiceTap(context, 'Home Nursing'),
              ),
              _ActionCard(
                title: 'Order Medicines',
                icon: Icons.medication_outlined,
                color: const Color(0xFFFCE4EC),
                iconColor: Colors.pink,
                onTap: () => _handleServiceTap(context, 'Order Medicines'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBooking(BuildContext context, BookingProvider provider) {
    if (provider.isLoading) {
      return const SizedBox.shrink();
    }

    final booking = provider.latestBooking;
    if (booking == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'Recent Activity'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.history, color: AppColors.primaryGreen),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.testOrPackage,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${booking.bookingStatus.name.toUpperCase()}',
                        style: TextStyle(
                          color: _getStatusColor(booking.bookingStatus),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReportsScreen()),
                    );
                  },
                  child: const Text('Details'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularTests(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: _SectionHeader(title: 'Popular Health Checks'),
        ),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _TestCard(
                title: 'Diabetes Checkup',
                price: '₹499',
                time: '6 Hours',
                icon: Icons.water_drop_outlined,
                onTap: () => _handleServiceTap(context, 'Book Lab Test'),
              ),
              _TestCard(
                title: 'Full Body Profile',
                price: '₹1499',
                time: '24 Hours',
                icon: Icons.monitor_heart_outlined,
                onTap: () => _handleServiceTap(context, 'Book Lab Test'),
              ),
              _TestCard(
                title: 'Thyroid Profile',
                price: '₹399',
                time: '12 Hours',
                icon: Icons.biotech_outlined,
                onTap: () => _handleServiceTap(context, 'Book Lab Test'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthPackages(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'Featured Health Packages'),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20),
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=500&auto=format'),
                fit: BoxFit.cover,
                opacity: 0.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Senior Citizen Package',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  '60+ Vital tests included with home collection',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _handleServiceTap(context, 'Book Lab Test'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1B5E20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Book Now @ ₹1999'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.completed: return Colors.green;
      case BookingStatus.cancelled: return Colors.red;
      default: return AppColors.primaryGreen;
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF263238),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: iconColor.withOpacity(0.8),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestCard extends StatelessWidget {
  final String title;
  final String price;
  final String time;
  final IconData icon;
  final VoidCallback onTap;

  const _TestCard({
    required this.title,
    required this.price,
    required this.time,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 28),
          const Spacer(),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(price, style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
              Text(time, style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 24,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: const Text('Book', style: TextStyle(fontSize: 10, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
