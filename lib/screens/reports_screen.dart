import 'package:flutter/material.dart';
import 'dart:io';
import '../models/booking_model.dart';
import '../models/report_model.dart';
import '../providers/booking_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/utils/colors.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // TODO: Fetch from Supabase via ReportsProvider
  final List<ReportModel> _reports = [];

  // Filter state
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isFilterApplied = false;

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final BookingModel? latestBooking = bookingProvider.latestBooking;
    final bool hasBooking = latestBooking != null;
    final bool hasReports = _filteredReports.isNotEmpty;
    final int listItems = _filteredReports.length + (hasBooking ? 1 : 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reports'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: !hasBooking && !hasReports
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No reports available',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your test reports will appear here once ready',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listItems,
              itemBuilder: (context, index) {
                if (index == 0 && latestBooking != null) {
                  return _buildBookingCard(latestBooking);
                }

                final reportIndex = index - (hasBooking ? 1 : 0);
                final report = _filteredReports[reportIndex];
                return _buildReportCard(report);
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _downloadReport(ReportModel report) async {
    // TODO: Implement actual secure Supabase Storage download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download feature requires Supabase integration'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildReportCard(ReportModel report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(46, 125, 50, 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.description,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking #${report.bookingId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Medical Report',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(46, 125, 50, 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Available',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Text(
                  'Generated: ${_formatDate(report.uploadDate)}',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadReport(report),
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Download'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _shareReport(report),
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Share'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(BookingModel booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(25, 118, 210, 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Latest Booking',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.testOrPackage,
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _bookingStatusColor(
                      booking.bookingStatus,
                    ).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _formatBookingStatus(booking.bookingStatus),
                    style: TextStyle(
                      color: _bookingStatusColor(booking.bookingStatus),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(
                    _formatServiceType(booking.serviceType),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: const Color.fromRGBO(46, 125, 50, 0.12),
                ),
                Chip(
                  label: Text(
                    'Payment: ${_formatPaymentStatus(booking.paymentStatus)}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: const Color.fromRGBO(244, 143, 177, 0.2),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Text(
                  '${_formatDate(booking.bookingDate)} at ${booking.bookingTime}',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showBookingDetails(booking),
                icon: const Icon(Icons.visibility, size: 18),
                label: const Text('View Booking Details'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDetails(BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking #${booking.bookingId}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Service', _formatServiceType(booking.serviceType)),
            _detailRow('Test/Package', booking.testOrPackage),
            _detailRow('Date', _formatDate(booking.bookingDate)),
            _detailRow('Time', booking.bookingTime),
            _detailRow('Status', _formatBookingStatus(booking.bookingStatus)),
            _detailRow('Payment', _formatPaymentStatus(booking.paymentStatus)),
            _detailRow(
              'Created',
              '${_formatDate(booking.createdAt)} at ${booking.createdAt.hour.toString().padLeft(2, '0')}:${booking.createdAt.minute.toString().padLeft(2, '0')}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _formatServiceType(ServiceType type) {
    switch (type) {
      case ServiceType.diagnostics:
        return 'Diagnostics Visit';
      case ServiceType.doctor:
        return 'Doctor Consultation';
      case ServiceType.homeSample:
        return 'Home Sample Collection';
      case ServiceType.nursing:
        return 'Home Nursing';
      case ServiceType.pharmacy:
        return 'Pharmacy Order';
    }
  }

  String _formatBookingStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.booked:
        return 'Booked';
      case BookingStatus.scheduled:
        return 'Confirmed';
      case BookingStatus.assigned:
        return 'Assigned';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _formatPaymentStatus(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }

  Color _bookingStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.grey;
      case BookingStatus.booked:
        return Colors.blueGrey;
      case BookingStatus.scheduled:
        return Colors.blue;
      case BookingStatus.assigned:
        return Colors.indigo;
      case BookingStatus.inProgress:
        return Colors.orange;
      case BookingStatus.completed:
        return Colors.teal;
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }

  void _shareReport(ReportModel report) async {
    try {
      final shareText =
          'Medical Report for Booking #${report.bookingId}\n'
          'Report Link: ${report.reportUrl}\n'
          'Generated on: ${report.uploadDate.toString().split(' ')[0]}\n'
          'Shared from AASHA MEDIX';

      await Share.share(
        shareText,
        subject: 'Medical Report - Booking #${report.bookingId}',
      );
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Share failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  List<ReportModel> get _filteredReports {
    if (!_isFilterApplied || (_startDate == null && _endDate == null)) {
      return _reports;
    }

    return _reports.where((report) {
      bool matchesStartDate =
          _startDate == null ||
          report.uploadDate.isAfter(
            _startDate!.subtract(const Duration(days: 1)),
          );
      bool matchesEndDate =
          _endDate == null ||
          report.uploadDate.isBefore(_endDate!.add(const Duration(days: 1)));

      return matchesStartDate && matchesEndDate;
    }).toList();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Filter Reports'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Start Date'),
                subtitle: Text(
                  _startDate != null
                      ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                      : 'Not selected',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => _startDate = picked);
                  }
                },
              ),
              ListTile(
                title: const Text('End Date'),
                subtitle: Text(
                  _endDate != null
                      ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                      : 'Not selected',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => _endDate = picked);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _startDate = null;
                  _endDate = null;
                  _isFilterApplied = false;
                });
                Navigator.pop(context);
                this.setState(() {});
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                this.setState(() => _isFilterApplied = true);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
