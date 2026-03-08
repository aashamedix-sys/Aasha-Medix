import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/nursing_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/shared_ui_components.dart';
import '../../utils/validators.dart';

class NurseDashboardScreen extends StatefulWidget {
  const NurseDashboardScreen({super.key});

  @override
  State<NurseDashboardScreen> createState() => _NurseDashboardScreenState();
}

class _NurseDashboardScreenState extends State<NurseDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NursingProvider>().fetchMyNursingRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Visits', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => context.read<NursingProvider>().fetchMyNursingRequests(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<NursingProvider>(
        builder: (context, provider, _) {
          return LoadingOverlay(
            isLoading: provider.isLoading && provider.nursingRequests.isEmpty,
            loadingMessage: 'Loading your visits...',
            child: provider.nursingRequests.isEmpty
                ? _EmptyVisitsState(onRefresh: () => provider.fetchMyNursingRequests())
                : RefreshIndicator(
                    onRefresh: () => provider.fetchMyNursingRequests(),
                    child: ListView.builder(
                      itemCount: provider.nursingRequests.length,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final request = provider.nursingRequests[index];
                        final isCompleted = request.visitStatus == 'completed';

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isCompleted
                                  ? Colors.green.withOpacity(0.3)
                                  : AppColors.primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Care: ${request.careType}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    BookingStatusChip(status: request.visitStatus),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _InfoRow(label: 'Booking ID', value: request.bookingId),
                                if (request.visitNotes?.isNotEmpty == true)
                                  _InfoRow(label: 'Notes', value: request.visitNotes!),
                                if (request.completedAt != null)
                                  _InfoRow(
                                    label: 'Completed',
                                    value: _formatDate(request.completedAt!),
                                  ),
                                if (!isCompleted) ...[
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          icon: const Icon(Icons.phone),
                                          label: const Text('Contact Patient'),
                                          onPressed: () {
                                            // Phone call integration
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.check_circle, color: Colors.white),
                                          label: const Text('Complete Visit',
                                              style: TextStyle(color: Colors.white)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                          ),
                                          onPressed: () =>
                                              _showCompletionDialog(context, request.id, provider),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showCompletionDialog(BuildContext context, String requestId, NursingProvider provider) {
    final notesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.medical_services, color: Colors.green),
            SizedBox(width: 8),
            Text('Mark Visit Complete'),
          ],
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: notesController,
            decoration: const InputDecoration(
              labelText: 'Visit Notes',
              hintText: 'e.g. Vitals taken, wound dressed, patient stable',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            validator: (v) {
              if (v == null || v.trim().length < 5) {
                return 'Please enter at least 5 characters of notes.';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(dialogContext);
              try {
                await provider.completeVisit(requestId, notesController.text.trim());
                if (context.mounted) {
                  context.showSuccessSnackBar('Visit marked as completed!');
                }
              } catch (e) {
                if (context.mounted) {
                  context.showErrorSnackBar(e.toString());
                }
              }
            },
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _EmptyVisitsState extends StatelessWidget {
  final VoidCallback onRefresh;
  const _EmptyVisitsState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medical_services_outlined, size: 72, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('No visits assigned yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('Check back later or contact your admin.',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text('$label:', style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
