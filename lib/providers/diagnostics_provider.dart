import 'package:flutter/material.dart';
import '../models/diagnostics_models.dart';
import '../services/diagnostics_service.dart';
import '../utils/app_error.dart';

class DiagnosticsProvider extends ChangeNotifier {
  final DiagnosticsService _service = DiagnosticsService();
  
  List<TestItem> _tests = [];
  List<HealthPackage> _packages = [];
  bool _isLoading = false;
  AppError? _error;

  List<TestItem> get tests => _tests;
  List<HealthPackage> get packages => _packages;
  bool get isLoading => _isLoading;
  AppError? get error => _error;

  Future<void> fetchDiagnostics() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.fetchTests(),
        _service.fetchPackages(),
      ]);

      _tests = results[0] as List<TestItem>;
      _packages = results[1] as List<HealthPackage>;
    } catch (e) {
      _error = AppError.from(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
