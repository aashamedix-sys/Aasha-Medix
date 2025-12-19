import 'package:flutter/material.dart';
import 'aasha_dost_screen.dart';
import 'diagnostics_screen.dart';
import 'home_sample_screen.dart';
import 'doctor_consult_screen.dart';
import 'reports_screen.dart';
import 'medicine_delivery_screen.dart';
import 'lead_capture_screen.dart';
import 'admin_login_screen.dart';
import '../widgets/language_selector.dart';
import '../widgets/app_logo.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showComingSoonDialog(BuildContext context, String feature) {
    if (feature == 'AASHA DOST') {
      // Navigate to AASHA DOST screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AashaDostScreen()),
      );
      return;
    }

    if (feature == 'Order Medicines') {
      // Navigate to Medicine Delivery screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MedicineDeliveryScreen()),
      );
      return;
    }

    if (feature == 'Book Appointment') {
      // Navigate to Lead Capture screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LeadCaptureScreen()),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            '$feature - Coming Soon',
            style: const TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '$feature feature will be available soon!',
            style: const TextStyle(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2E7D32),
              ),
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  void _handleServiceTap(BuildContext context, String service) {
    switch (service) {
      case 'Diagnostics':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DiagnosticsScreen()),
        );
        break;
      case 'Home Sample':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeSampleScreen()),
        );
        break;
      case 'Doctor Consult':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DoctorConsultScreen()),
        );
        break;
      case 'Reports':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReportsScreen()),
        );
        break;
      case 'Medicine Delivery':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MedicineDeliveryScreen(),
          ),
        );
        break;
      default:
        _showComingSoonDialog(context, service);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const AppLogo(size: 32),
            const SizedBox(width: 12),
            Text(
              l10n.appName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 22,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF2E7D32),
            ),
            onPressed: () => _showComingSoonDialog(context, 'Notifications'),
          ),
          const LanguageSelectorButton(),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xFF2E7D32)),
            onPressed: () => _showComingSoonDialog(context, 'Profile'),
          ),
          IconButton(
            icon: const Icon(
              Icons.admin_panel_settings_outlined,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminLoginScreen(),
                ),
              );
            },
            tooltip: 'Staff Access',
          ),
        ],
      ),
      body: SafeArea(
        child: HomeContent(
          onFeatureTap: _showComingSoonDialog,
          onServiceTap: _handleServiceTap,
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final Function(BuildContext, String) onFeatureTap;
  final Function(BuildContext, String) onServiceTap;

  const HomeContent({
    super.key,
    required this.onFeatureTap,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WelcomeBanner(),
          ServicesSection(onServiceTap: onServiceTap),
          const SizedBox(height: 20),
          QuickActionsSection(onFeatureTap: onFeatureTap),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Diagnostics, Doctors & Delivery',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Every Test, Every Life Matters',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.health_and_safety,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}

class ServicesSection extends StatelessWidget {
  final Function(BuildContext, String) onServiceTap;

  const ServicesSection({super.key, required this.onServiceTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Text(
            'Our Services',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive grid: 2 columns on small screens, 3 on larger screens
            final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
                children: [
                  ServiceCard(
                    icon: Icons.science,
                    title: 'Diagnostics',
                    subtitle: 'Lab Tests',
                    color: const Color(0xFF1976D2),
                    onTap: () => onServiceTap(context, 'Diagnostics'),
                  ),
                  ServiceCard(
                    icon: Icons.home,
                    title: 'Home Sample Collection',
                    subtitle: 'Doorstep Service',
                    color: const Color(0xFFE91E63),
                    onTap: () => onServiceTap(context, 'Home Sample'),
                  ),
                  ServiceCard(
                    icon: Icons.medical_services,
                    title: 'Doctor Consultation',
                    subtitle: 'Online & Offline',
                    color: const Color(0xFFFF6F00),
                    onTap: () => onServiceTap(context, 'Doctor Consult'),
                  ),
                  ServiceCard(
                    icon: Icons.description,
                    title: 'View & Download Reports',
                    subtitle: 'Digital Access',
                    color: const Color(0xFF7B1FA2),
                    onTap: () => onServiceTap(context, 'Reports'),
                  ),
                  ServiceCard(
                    icon: Icons.local_pharmacy,
                    title: 'Medicine Delivery',
                    subtitle: 'Home Delivery',
                    color: const Color(0xFF009688),
                    onTap: () => onServiceTap(context, 'Medicine Delivery'),
                  ),
                  ServiceCard(
                    icon: Icons.local_shipping,
                    title: 'Ambulance Services',
                    subtitle: 'Coming Soon',
                    color: Colors.grey,
                    onTap: null, // Disabled
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class QuickActionsSection extends StatelessWidget {
  final Function(BuildContext, String) onFeatureTap;

  const QuickActionsSection({super.key, required this.onFeatureTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 12),
          QuickActionButton(
            icon: Icons.calendar_today,
            text: 'Book Appointment',
            onTap: () => onFeatureTap(context, 'Book Appointment'),
          ),
          const SizedBox(height: 8),
          QuickActionButton(
            icon: Icons.smart_toy,
            text: 'Ask AASHA DOST',
            onTap: () => onFeatureTap(context, 'AASHA DOST'),
          ),
          const SizedBox(height: 8),
          QuickActionButton(
            icon: Icons.local_pharmacy,
            text: 'Order Medicines',
            onTap: () => onFeatureTap(context, 'Order Medicines'),
          ),
          const SizedBox(height: 24),
          // Trust Signals Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _TrustSignalItem(
                      icon: Icons.verified,
                      text: 'Certified Labs',
                    ),
                    _TrustSignalItem(
                      icon: Icons.security,
                      text: 'Fast & Secure',
                    ),
                    _TrustSignalItem(
                      icon: Icons.location_on,
                      text: 'Suryapet & Hyderabad',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustSignalItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TrustSignalItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF2E7D32), size: 24),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1B5E20),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _isPressed = false;
  bool _isHovered = false;

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      // Show coming soon message for disabled services
      if (widget.title == 'Ambulance Services') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Ambulance services launching soon in Suryapet 🚑',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: const Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.title} - Feature coming soon!'),
            duration: const Duration(seconds: 2),
            backgroundColor: widget.color,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onTap == null;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _handleTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed && !isDisabled
              ? 0.95
              : (_isHovered && !isDisabled ? 1.02 : 1.0),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: _isPressed && !isDisabled ? 0.8 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (isDisabled ? Colors.grey : widget.color).withValues(
                      alpha: _isHovered && !isDisabled ? 0.25 : 0.15,
                    ),
                    blurRadius: _isHovered && !isDisabled ? 16 : 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isDisabled)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Coming Soon',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  SizedBox(height: isDisabled ? 8.0 : 0.0),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (isDisabled ? Colors.grey[100]! : widget.color)
                          .withValues(
                            alpha: _isHovered && !isDisabled ? 0.15 : 0.1,
                          ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 32,
                      color: isDisabled ? Colors.grey : widget.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDisabled ? Colors.grey : const Color(0xFF1B5E20),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDisabled ? Colors.grey[400] : Colors.grey[600],
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF2E7D32), size: 24),
              const SizedBox(width: 16),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
