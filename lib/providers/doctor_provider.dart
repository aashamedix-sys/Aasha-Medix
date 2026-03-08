import 'package:flutter/material.dart';
import '../services/doctor_service.dart';
import '../models/doctor_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/app_error.dart';

class DoctorProvider with ChangeNotifier {
  final DoctorService _service = DoctorService();
  List<DoctorModel> _doctors = [];
  bool _isLoading = false;

  List<DoctorModel> get doctors => _doctors;
  bool get isLoading => _isLoading;

  Future<void> fetchDoctors() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _doctors = await _service.getAvailableDoctors();
      _isLoading = false;
      notifyListeners();
    } catch(e) {
      _isLoading = false;
      notifyListeners();
      throw AppError.from(e);
    }
  }

  // Helper method context: Doctor bookings actually go through BookingProvider,
  // where serviceType = doctor and testOrPackage = doctor.specialization / doctor.id
}
