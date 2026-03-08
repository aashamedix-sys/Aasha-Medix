import 'package:flutter/material.dart';

/// A reusable widget that shows a status chip/badge for booking states.
class BookingStatusChip extends StatelessWidget {
  final String status;

  const BookingStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status.toLowerCase());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, color: config.color, size: 14),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getConfig(String status) {
    switch (status) {
      case 'pending':
        return _StatusConfig(label: 'Pending', color: Colors.orange, icon: Icons.schedule);
      case 'booked':
        return _StatusConfig(label: 'Booked', color: Colors.blueGrey, icon: Icons.bookmark_added);
      case 'scheduled':
        return _StatusConfig(label: 'Confirmed', color: Colors.blue, icon: Icons.event_available);
      case 'assigned':
        return _StatusConfig(label: 'Assigned', color: Colors.indigo, icon: Icons.person_pin);
      case 'inprogress':
      case 'in_progress':
        return _StatusConfig(label: 'In Progress', color: Colors.deepOrange, icon: Icons.autorenew);
      case 'completed':
        return _StatusConfig(label: 'Completed', color: Colors.green, icon: Icons.check_circle);
      case 'cancelled':
        return _StatusConfig(label: 'Cancelled', color: Colors.red, icon: Icons.cancel);
      default:
        return _StatusConfig(label: status.toUpperCase(), color: Colors.grey, icon: Icons.info_outline);
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  final IconData icon;

  _StatusConfig({required this.label, required this.color, required this.icon});
}

/// A consistent loading overlay widget for async operations.
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String loadingMessage;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingMessage = 'Processing...',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.white.withOpacity(0.8),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00942A)),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    loadingMessage,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// A widget shown when a network or connection error occurs.
class ConnectionErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ConnectionErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.wifi_off_outlined, size: 48, color: Colors.red.shade700),
            ),
            const SizedBox(height: 24),
            const Text(
              'Connection Error',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00942A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extension to show consistent success/error snackbars across the app.
extension SnackBarExtension on BuildContext {
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
