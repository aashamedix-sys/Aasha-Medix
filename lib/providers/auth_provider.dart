import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  UserModel? _userProfile;
  bool _isLoading = false;

  User? get user => _user;
  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get userRole => _userProfile?.role;

  AuthProvider() {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    if (user != null) {
      _userProfile = await _authService.getUserProfile(user.uid);
    } else {
      _userProfile = null;
    }
    notifyListeners();
  }

  // Patient login with phone
  Future<void> signInWithPhone(
    String phoneNumber,
    Function(String) onCodeSent,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signInWithPhone(phoneNumber, onCodeSent);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Verify OTP for patient
  Future<void> verifyOTP(String verificationId, String smsCode) async {
    _isLoading = true;
    notifyListeners();
    try {
      UserCredential result = await _authService.verifyOTP(
        verificationId,
        smsCode,
      );
      // Create or update patient profile
      final user = result.user;
      if (user == null) {
        throw Exception('Authentication failed: User not created');
      }
      UserModel patient = UserModel(
        id: user.uid,
        phoneNumber: user.phoneNumber ?? '',
        role: 'patient',
        createdAt: DateTime.now(),
      );
      await _authService.createUserProfile(patient);
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
      UserCredential result = await _authService.signInWithEmail(
        email,
        password,
      );
      final user = result.user;
      if (user == null) {
        throw Exception('Authentication failed: User not created');
      }
      // Check if staff
      UserModel? profile = await _authService.getUserProfile(user.uid);
      if (profile == null || profile.role != 'staff') {
        await _authService.signOut();
        throw Exception('Unauthorized access. Staff credentials required.');
      }
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

  // Update profile
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (_user != null) {
      await _authService.updateUserProfile(_user!.uid, updates);
      _userProfile = await _authService.getUserProfile(_user!.uid);
      notifyListeners();
    }
  }
}
