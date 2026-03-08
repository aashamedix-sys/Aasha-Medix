import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../services/audit_service.dart';
import '../models/nurse_model.dart';
import '../utils/app_error.dart';

class AdminProvider with ChangeNotifier {
  final AdminService _service = AdminService();
  final AuditService _auditService = AuditService();
  
  List<Map<String, dynamic>> _allBookings = [];
  List<NurseModel> _allNurses = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get allBookings => _allBookings;
  List<NurseModel> get allNurses => _allNurses;
  bool get isLoading => _isLoading;

  Future<void> logLoadData() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _allBookings = await _service.fetchAllBookings();
      _allNurses = await _service.fetchAllNurses();
    } catch(e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _service.updateBookingStatus(bookingId, newStatus);
      // Update local state
      final index = _allBookings.indexWhere((b) => b['id'] == bookingId);
      if (index != -1) {
        _allBookings[index]['status'] = newStatus;
      }
      await _auditService.logAction(
        action: 'BOOKING_STATUS_UPDATED', 
        details: 'Booking ID: $bookingId, New Status: $newStatus'
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> assignNurse(String requestId, String nurseId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _service.assignNurseToRequest(requestId, nurseId);
      await _auditService.logAction(
        action: 'NURSE_ASSIGNED', 
        details: 'Request ID: $requestId, Nurse ID: $nurseId'
      );
      await logLoadData(); // Reload to refresh bookings
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> assignReport(String bookingId, String patientId, String fileUrl) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _service.assignReportToPatient(bookingId, patientId, fileUrl);
      await _auditService.logAction(
        action: 'REPORT_UPLOADED', 
        details: 'Booking ID: $bookingId, Patient ID: $patientId'
      );
      await logLoadData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
