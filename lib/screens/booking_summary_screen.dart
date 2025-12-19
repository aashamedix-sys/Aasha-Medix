import 'package:flutter/material.dart';
import '../models/booking_summary_model.dart';
import '../services/booking_automation_service.dart';
import 'package:flutter/services.dart';

class BookingSummaryScreen extends StatefulWidget {
  final BookingSummaryModel booking;

  const BookingSummaryScreen({super.key, required this.booking});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  bool _isSubmitting = false;
  bool _hasSubmitted = false;

  Future<void> _confirmBooking() async {
    if (_hasSubmitted) return; // Prevent double submission

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Prepare automation payload
      final payload = widget.booking.toAutomationPayload();

      // Send booking to Make.com webhook
      final success = await BookingAutomationService.sendBookingToWebhook(
        payload,
      );

      if (success) {
        // Show success confirmation
        if (mounted) {
          _showSuccessDialog();
        }
      } else {
        // Show error message
        if (mounted) {
          _showErrorDialog();
        }
      }
    } catch (e) {
      debugPrint('Error in booking confirmation: $e');
      if (mounted) {
        _showErrorDialog();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _hasSubmitted = true;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Booking Confirmed! 🎉',
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.booking.whatsappMessage,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
                const Divider(height: 24),
                const Text(
                  'Confirmation sent & saved in system',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
                Navigator.of(context).pop(); // Go back to home
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2E7D32),
              ),
              child: const Text('Done'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                // Copy WhatsApp message to clipboard
                Clipboard.setData(
                  ClipboardData(text: widget.booking.whatsappMessage),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message copied to clipboard')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
              child: const Text('Copy Message'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Booking Error'),
          content: const Text(
            'Unable to process your booking. Please check your internet connection and try again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _hasSubmitted = false; // Allow retry
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
              ),
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x332E7D32)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF2E7D32),
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Booking Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        Text(
                          'Review your booking details below',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Booking Details Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Booking ID', widget.booking.bookingId),
                    const Divider(),
                    _buildDetailRow(
                      'Service Type',
                      widget.booking.serviceTypeDisplay,
                    ),
                    const Divider(),
                    _buildDetailRow('Patient Name', widget.booking.patientName),
                    const Divider(),
                    _buildDetailRow(
                      'Mobile Number',
                      widget.booking.phoneNumber,
                    ),

                    if (widget.booking.items.isNotEmpty) ...[
                      const Divider(),
                      _buildDetailRow('Items', widget.booking.items.join(', ')),
                    ],

                    if (widget.booking.address != null) ...[
                      const Divider(),
                      _buildDetailRow('Address', widget.booking.address!),
                    ],

                    if (widget.booking.date != null) ...[
                      const Divider(),
                      _buildDetailRow(
                        'Preferred Date',
                        '${widget.booking.date!.day}/${widget.booking.date!.month}/${widget.booking.date!.year}',
                      ),
                    ],

                    if (widget.booking.time != null) ...[
                      const Divider(),
                      _buildDetailRow(
                        'Preferred Time',
                        widget.booking.time!.format(context),
                      ),
                    ],

                    const Divider(),
                    _buildDetailRow(
                      'Total Amount',
                      '₹${widget.booking.amount.toStringAsFixed(0)}',
                      isAmount: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Automation Status Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.green.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Ready for Automation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your booking will be automatically processed:',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text('• WhatsApp confirmation message'),
                    Text('• CRM system update'),
                    Text('• Team notification'),
                    Text('• Follow-up scheduling'),
                  ],
                ),
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSubmitting
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Processing...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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

            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Your booking is now confirmed and automated',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAmount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isAmount ? FontWeight.bold : FontWeight.normal,
                color: isAmount ? const Color(0xFF2E7D32) : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
