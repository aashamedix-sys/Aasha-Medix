import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:open_filex/open_filex.dart';
import '../models/report_model.dart';
import '../utils/colors.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // Sample report data - in real app this would come from API
  final List<ReportModel> _reports = [
    ReportModel(
      id: '1',
      bookingId: 'B001',
      userId: '1',
      reportUrl: 'https://example.com/report1.pdf',
      uploadDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ReportModel(
      id: '2',
      bookingId: 'B002',
      userId: '1',
      reportUrl: 'https://example.com/report2.pdf',
      uploadDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ReportModel(
      id: '3',
      bookingId: 'B003',
      userId: '1',
      reportUrl: 'https://example.com/report3.pdf',
      uploadDate: DateTime.now().subtract(const Duration(days: 7)),
    ),
    ReportModel(
      id: '4',
      bookingId: 'B004',
      userId: '1',
      reportUrl: 'https://example.com/report4.pdf',
      uploadDate: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  // Filter state
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isFilterApplied = false;

  @override
  Widget build(BuildContext context) {
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
      body: _filteredReports.isEmpty
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
              itemCount: _filteredReports.length,
              itemBuilder: (context, index) {
                final report = _filteredReports[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
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
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Generated: ${_formatDate(report.uploadDate)}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
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
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _downloadReport(ReportModel report) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Downloading report...'),
          backgroundColor: AppColors.primary,
        ),
      );

      // Get the downloads directory
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Unable to access storage');
      }

      final downloadsDir = Directory('${directory.path}/Download');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      // Download the PDF
      final response = await http.get(Uri.parse(report.reportUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download PDF');
      }

      // Save the file
      final fileName = 'report_${report.bookingId}.pdf';
      final filePath = '${downloadsDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Open the file
      final result = await OpenFilex.open(filePath);
      if (result.type != ResultType.done) {
        // If can't open, at least show success
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Report downloaded to: $filePath'),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: 'Open',
                onPressed: () => OpenFilex.open(filePath),
              ),
            ),
          );
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Report downloaded and opened successfully'),
              backgroundColor: Colors.green,
            ),
          );
        });
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      });
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
