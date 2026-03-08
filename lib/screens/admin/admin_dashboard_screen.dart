import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/shared_ui_components.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().logLoadData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.list_alt), text: 'All Bookings'),
            Tab(icon: Icon(Icons.medical_services), text: 'Nurses'),
            Tab(icon: Icon(Icons.analytics), text: 'Overview'),
          ],
        ),
      ),
      body: Consumer<AdminProvider>(
        builder: (context, admin, _) {
          return LoadingOverlay(
            isLoading: admin.isLoading && admin.allBookings.isEmpty,
            loadingMessage: 'Loading bookings...',
            child: TabBarView(
              controller: _tabController,
              children: [
                _BookingsTab(admin: admin),
                _NursesTab(admin: admin),
                _OverviewTab(admin: admin),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Bookings Tab ──────────────────────────────────────────────────────────────
class _BookingsTab extends StatelessWidget {
  final AdminProvider admin;
  const _BookingsTab({required this.admin});

  @override
  Widget build(BuildContext context) {
    if (admin.allBookings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No active bookings', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: admin.allBookings.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final booking = admin.allBookings[index];
        final patientName = booking['patients']?['name'] ?? 'Unknown Patient';
        final service = booking['service_type'] ?? 'Unknown';
        final status = booking['status'] ?? 'pending';
        final date = booking['scheduled_time'] ?? 'Date TBD';

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Icon(Icons.person, color: AppColors.primary),
            ),
            title: Text(patientName, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Service: $service'),
                Text('Date: $date'),
                const SizedBox(height: 4),
                BookingStatusChip(status: status),
              ],
            ),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showBookingOptions(context, booking, admin),
            ),
          ),
        );
      },
    );
  }

  void _showBookingOptions(BuildContext context, Map<String, dynamic> booking, AdminProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text('Booking: ${booking['service_type']}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Mark Completed'),
              onTap: () {
                provider.updateBookingStatus(booking['id'], 'completed');
                Navigator.pop(ctx);
                context.showSuccessSnackBar('Booking marked as completed');
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: const Text('Cancel Booking'),
              onTap: () {
                provider.updateBookingStatus(booking['id'], 'cancelled');
                Navigator.pop(ctx);
                context.showSuccessSnackBar('Booking cancelled');
              },
            ),
            if (booking['service_type'] == 'nursing')
              ListTile(
                leading: const Icon(Icons.medical_services, color: Colors.blue),
                title: const Text('Assign Nurse'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showNurseSelection(context, booking['id'], provider);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showNurseSelection(BuildContext context, String bookingId, AdminProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign a Nurse'),
        content: SizedBox(
          width: double.maxFinite,
          child: provider.allNurses.isEmpty
              ? const Text('No available nurses.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.allNurses.length,
                  itemBuilder: (context, index) {
                    final nurse = provider.allNurses[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(nurse.name ?? 'Unknown'),
                      onTap: () {
                        provider.assignNurse(bookingId, nurse.id);
                        Navigator.pop(context);
                        context.showSuccessSnackBar('Nurse ${nurse.name} assigned');
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

// ── Nurses Tab ────────────────────────────────────────────────────────────────
class _NursesTab extends StatelessWidget {
  final AdminProvider admin;
  const _NursesTab({required this.admin});

  @override
  Widget build(BuildContext context) {
    if (admin.allNurses.isEmpty) {
      return const Center(child: Text('No nurses registered.'));
    }
    return ListView.builder(
      itemCount: admin.allNurses.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final nurse = admin.allNurses[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: const Icon(Icons.medical_services, color: Colors.blue),
            ),
            title: Text(nurse.name ?? 'Unknown Nurse', style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(nurse.specialization ?? 'General Nursing'),
            trailing: Chip(
              label: const Text('Active', style: TextStyle(fontSize: 11)),
              backgroundColor: Colors.green.withOpacity(0.1),
              side: BorderSide(color: Colors.green.withOpacity(0.4)),
            ),
          ),
        );
      },
    );
  }
}

// ── Overview Tab ──────────────────────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  final AdminProvider admin;
  const _OverviewTab({required this.admin});

  @override
  Widget build(BuildContext context) {
    final total = admin.allBookings.length;
    final pending = admin.allBookings.where((b) => b['status'] == 'pending').length;
    final completed = admin.allBookings.where((b) => b['status'] == 'completed').length;
    final cancelled = admin.allBookings.where((b) => b['status'] == 'cancelled').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Booking Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatCard(label: 'Total', value: total, color: Colors.indigo),
              const SizedBox(width: 12),
              _StatCard(label: 'Pending', value: pending, color: Colors.orange),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatCard(label: 'Completed', value: completed, color: Colors.green),
              const SizedBox(width: 12),
              _StatCard(label: 'Cancelled', value: cancelled, color: Colors.red),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Nurses', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _StatCard(label: 'Registered', value: admin.allNurses.length, color: Colors.blue),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$value', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}
