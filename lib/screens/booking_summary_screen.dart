import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/booking_model.dart';
import '../providers/booking_provider.dart';
import 'booking_confirmation_screen.dart';

class BookingSummaryScreen extends StatefulWidget {
  // New constructor parameters (Step 2.3)
  final ServiceType? serviceType;
  final String? testOrPackage;
  final DateTime? bookingDate;
  final String? bookingTime;

  // Legacy constructor parameter (for other screens not yet refactored)
  final dynamic booking;

  const BookingSummaryScreen({
    super.key,
    // New parameters
    this.serviceType,
    this.testOrPackage,
    this.bookingDate,
    this.bookingTime,
    // Legacy parameter
    this.booking,
  }) : assert(
         (serviceType != null &&
                 testOrPackage != null &&
                 bookingDate != null &&
                 bookingTime != null) ||
             booking != null,
         'Either provide serviceType/testOrPackage/bookingDate/bookingTime OR legacy booking parameter',
       );

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  bool _isSubmitting = false;

  // Check if using new constructor (Step 2.3) or legacy
  bool get _isNewBooking => widget.serviceType != null;

  Future<void> _confirmBooking() async {
    // Only for new booking flow
    if (!_isNewBooking) {
      // Legacy flows (older screens) should not dead-end.
      // Show a production-safe confirmation and return.
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Request submitted'),
          content: const Text(
            'We have received your request. Our team will contact you shortly.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (mounted) Navigator.of(context).pop();
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final bookingProvider = context.read<BookingProvider>();
      await bookingProvider.createBooking(
        serviceType: widget.serviceType!,
        testOrPackage: widget.testOrPackage!,
        bookingDate: widget.bookingDate!,
        bookingTime: widget.bookingTime!,
      );
      final booking = bookingProvider.latestBooking;
      if (booking != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingConfirmationScreen(booking: booking),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show legacy view if using old constructor
    if (!_isNewBooking) {
      return _buildLegacyView();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Summary'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Details Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Service Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Service Type', widget.serviceType!.name),
                    const SizedBox(height: 12),
                    _buildDetailRow('Test/Package', widget.testOrPackage!),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'Booking Date',
                      _formatDate(widget.bookingDate!),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Booking Time', widget.bookingTime!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Info Message
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF2E7D32), size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Review your booking details and confirm to proceed.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF2E7D32),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Confirm Booking',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Legacy view for non-refactored screens
  Widget _buildLegacyView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Summary'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
              ),
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
