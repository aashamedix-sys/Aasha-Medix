import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/nursing_service.dart';
import '../services/audit_service.dart';
import '../models/nursing_request_model.dart';
import '../providers/booking_provider.dart';
import '../utils/app_error.dart';

class NursingProvider with ChangeNotifier {
  final NursingService _service = NursingService();
  final AuditService _auditService = AuditService();
  List<NursingRequestModel> _nursingRequests = [];
  bool _isLoading = false;

  List<NursingRequestModel> get nursingRequests => _nursingRequests;
  bool get isLoading => _isLoading;

  Future<void> requestNurseVisit(String bookingId, String careType) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final newId = await _service.createNursingRequest(bookingId, careType);
      
      // Optionally fetch the latest list or create a local model to prepend
      final newRequest = NursingRequestModel(
        id: newId,
        bookingId: bookingId,
        careType: careType,
      );
      _nursingRequests.insert(0, newRequest);
      
      _isLoading = false;
      notifyListeners();
    } catch(e) {
      _isLoading = false;
      notifyListeners();
      throw AppError.from(e);
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
