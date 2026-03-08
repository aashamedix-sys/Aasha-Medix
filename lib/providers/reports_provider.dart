import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/reports_service.dart';
import '../models/lab_report_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../utils/app_error.dart';
import 'dart:io';

class ReportsProvider with ChangeNotifier {
  final ReportsService _service = ReportsService();
  List<LabReportModel> _reports = [];
  bool _isLoading = false;

  List<LabReportModel> get reports => _reports;
  bool get isLoading => _isLoading;

  Future<void> fetchMyReports() async {
    final User? currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      _reports = await _service.getMyReports(currentUser.id);
      _isLoading = false;
      notifyListeners();
    } catch(e) {
      _isLoading = false;
      notifyListeners();
      throw AppError.from(e);
    }
  }

  Future<String?> downloadReport(LabReportModel report) async {
    try {
      // 1. Get secure signed URL
      // Assuming report.reportUrl contains the Supabase Storage object path 
      // (e.g., patient_id/report_name.pdf)
      final String signedUrl = await _service.getSecureDownloadUrl(report.reportUrl);

      // 2. Determine local storage path
      final directory = await getExternalStorageDirectory();
      if (directory == null) throw Exception('Unable to access storage');
      
      final downloadsDir = Directory('${directory.path}/Download');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }
      
      final fileName = 'report_${report.bookingId}.pdf';
      final filePath = '${downloadsDir.path}/$fileName';
      
      // 3. Download the file
      final response = await http.get(Uri.parse(signedUrl));
      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        throw Exception('Failed to download PDF. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw AppError.from(e);
    }
  }
}
