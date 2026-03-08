import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/patient_model.dart';
import 'dart:developer';

class AuthService {
  final SupabaseClient _supabase = SupabaseClientConfig.client;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
  
  User? get currentUser => _supabase.auth.currentUser;

  // Patient login with phone (Supabase OTP)
  Future<void> sendOTP(String phone) async {
    // Supabase expects E.164 format, e.g. +91XXXXXXXXXX
    String formattedPhone = phone.startsWith('+') ? phone : '+91$phone';
    await _supabase.auth.signInWithOtp(
      phone: formattedPhone,
    );
  }

  // Verify OTP for patient
  Future<AuthResponse> verifyOTP(String phone, String otp, {String? acquisitionSource, String? referralCode}) async {
    String formattedPhone = phone.startsWith('+') ? phone : '+91$phone';
    final response = await _supabase.auth.verifyOTP(
      phone: formattedPhone,
      token: otp,
      type: OtpType.sms,
    );
    
    // Auto-create patient profile if it's a new user
    if (response.user != null) {
      await _ensurePatientProfileExists(
        response.user!, 
        formattedPhone, 
        acquisitionSource: acquisitionSource,
        referralCode: referralCode,
      );
    }
    
    return response;
  }

  // Staff login with email/password
  Future<AuthResponse> loginWithEmail(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Patient Profile handling
  Future<void> _ensurePatientProfileExists(User user, String phone, {String? acquisitionSource, String? referralCode}) async {
    try {
      final existingPatient = await _supabase
          .from('patients')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (existingPatient == null) {
        // Generate a random referral code for the new user
        final ownCode = "ASHA${user.id.substring(0, 4).toUpperCase()}";
        
        // Create new patient
        final newPatient = PatientModel(
          id: user.id,
          name: 'New Patient', // Will be updated by user later
          phone: phone,
          address: 'Not Provided',
          createdAt: DateTime.now(),
          acquisitionSource: acquisitionSource,
          ownReferralCode: ownCode,
        );
        await _supabase.from('patients').insert(newPatient.toJson());
        
        // If referred, log the referral
        if (referralCode != null) {
          await _trackReferral(user.id, referralCode);
        }
        
        log("Created new patient profile for ${user.id}");
      }
    } catch (e) {
      log("Error ensuring patient profile: $e");
    }
  }

  Future<void> _trackReferral(String referredId, String code) async {
    try {
      // Find the referrer by their code
      final referrer = await _supabase.from('patients').select('id').eq('own_referral_code', code).maybeSingle();
      if (referrer != null) {
        await _supabase.from('referrals').insert({
          'referrer_id': referrer['id'],
          'referred_id': referredId,
          'referral_code': code,
        });
        log("Tracked referral from ${referrer['id']} to $referredId");
      }
    } catch (e) {
      log("Error tracking referral: $e");
    }
  }

  Future<PatientModel?> getPatientProfile(String userId) async {
    try {
      final res = await _supabase.from('patients').select().eq('id', userId).single();
      return PatientModel.fromJson(res);
    } catch (e) {
      log("Error fetching patient profile: $e");
      return null;
    }
  }
}
