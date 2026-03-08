import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/nursing_service.dart';
import '../services/audit_service.dart';
import '../models/nursing_request_model.dart';
import '../models/nurse_model.dart';
import '../providers/booking_provider.dart';
import '../utils/app_error.dart';

class NursingProvider with ChangeNotifier {
  final NursingService _service = NursingService();
  final AuditService _auditService = AuditService();
  List<NursingRequestModel> _nursingRequests = [];
  List<NurseModel> _nurses = [];
  bool _isLoading = false;

  List<NursingRequestModel> get nursingRequests => _nursingRequests;
  List<NurseModel> get nurses => _nurses;
  bool get isLoading => _isLoading;

  Future<void> fetchNurses() async {
    _isLoading = true;
    notifyListeners();
    try {
      _nurses = await _service.getAvailableNurses();
      _isLoading = false;
      notifyListeners();
    } catch(e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> requestNurseVisit({
    required String careType,
    required DateTime scheduledDate,
    required String scheduledTime,
    String? address,
    String? notes,
    double? totalAmount,
  }) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final newId = await _service.bookNursingVisit(
        careType: careType,
        scheduledDate: scheduledDate,
        scheduledTime: scheduledTime,
        address: address,
        notes: notes,
        totalAmount: totalAmount,
      );
      
      // Optionally fetch the latest list or create a local model to prepend
      await fetchMyNursingRequests();
      
      _isLoading = false;
      notifyListeners();
      return newId;
    } catch(e) {
      _isLoading = false;
      notifyListeners();
      throw AppError.from(e);
    }
  }

  Future<void> fetchRequestsForNurse(String nurseId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _nursingRequests = await _service.getRequestsForNurse(nurseId);
      _isLoading = false;
      notifyListeners();
    } catch(e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyNursingRequests() async {
    final User? currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) return;

    _isLoading = true;
    notifyListeners();
    
    try {
      _nursingRequests = await _service.getMyNursingRequests(currentUser.id);
      _isLoading = false;
      notifyListeners();
    } catch(e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeVisit(String requestId, String notes) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _service.markVisitCompleted(requestId, notes);
      
      // Update local state
      final index = _nursingRequests.indexWhere((r) => r.id == requestId);
      if (index != -1) {
        final req = _nursingRequests[index];
        _nursingRequests[index] = NursingRequestModel(
          id: req.id,
          bookingId: req.bookingId,
          assignedNurseId: req.assignedNurseId,
          careType: req.careType,
          visitNotes: notes,
          visitStatus: 'completed',
          completedAt: DateTime.now(),
        );
      }
      
      await _auditService.logAction(
        action: 'NURSE_VISIT_COMPLETED',
        details: 'Request ID: $requestId'
      );

      _isLoading = false;
      notifyListeners();
    } catch(e) {
      _isLoading = false;
      notifyListeners();
      throw AppError.from(e);
    }
  }
}
