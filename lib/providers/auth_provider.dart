import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../models/patient_model.dart';
import '../utils/app_error.dart';
import 'dart:async';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  StreamSubscription<AuthState>? _authStateSubscription;
  
  User? _user;
  PatientModel? _patientProfile;
  bool _isLoading = false;
  
  // To keep track of phone number during OTP flow
  String? _pendingPhoneNumber;

  User? get user => _user;
  PatientModel? get patientProfile => _patientProfile;
  PatientModel? get userProfile => _patientProfile; // Alias for compatibility
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get userRole {
    if (_user?.email?.startsWith('admin') == true) return 'admin';
    if (_user?.email?.startsWith('nurse') == true) return 'nurse';
    if (_user?.email != null) return 'staff';
    return 'patient'; // Phone login defaults to patient
  }

  AuthProvider() {
    _init();
  }

  void _init() {
    _authStateSubscription = _authService.authStateChanges.listen((data) async {
      _user = data.session?.user;
      if (_user != null && userRole == 'patient') {
        _patientProfile = await _authService.getPatientProfile(_user!.id);
      } else {
        _patientProfile = null;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  // Patient login with phone
  Future<void> signInWithPhone(
    String phoneNumber,
    Function(String) onCodeSent,
  ) async {
    _isLoading = true;
    _pendingPhoneNumber = phoneNumber;
    notifyListeners();
    try {
      await _authService.sendOTP(phoneNumber);
      // Supabase OTP doesn't return a verification ID, so we pass phone back
      onCodeSent(phoneNumber);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Verify OTP for patient
  // Note: the verificationId from UI maps to phone number in Supabase OTP flow
  Future<void> verifyOTP(String phoneFallback, String smsCode) async {
    _isLoading = true;
    notifyListeners();
    try {
      final phone = _pendingPhoneNumber ?? phoneFallback;
      await _authService.verifyOTP(phone, smsCode);
      // The auth state subscription will automatically catch the session change
      // and load the profile.
      _pendingPhoneNumber = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Staff login with email/password
  Future<void> signInWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.loginWithEmail(email, password);
      // Auth state subscription will catch the new session
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
  }

  // Update profile locally (needs service implementation for full update)
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (_user != null && _patientProfile != null) {
      // Intentionally avoiding backend write here to keep it simple, 
      // but notifying listeners if we update model locally.
      // E.g. _patientProfile = PatientModel(...)
      notifyListeners();
    }
  }
}
