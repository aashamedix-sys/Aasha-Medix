import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_error.dart';
import '../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _phoneFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  String? _verificationId;
  bool _isOTPSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (!(_phoneFormKey.currentState?.validate() ?? false)) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.signInWithPhone(_phoneController.text.trim(), (
        verificationId,
      ) {
        if (mounted) {
          setState(() {
            _verificationId = verificationId;
            _isOTPSent = true;
          });
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('OTP sent to your phone')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e is AppError ? e.message : AppError.from(e).message),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _verifyOTP() async {
    if (!(_otpFormKey.currentState?.validate() ?? false)) return;
    if (_verificationId == null) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.verifyOTP(
        _verificationId!,
        _otpController.text.trim(),
      );
      // Navigation will happen automatically due to auth state change
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e is AppError ? e.message : AppError.from(e).message),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to AASHA MEDIX',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Login with your phone number to access healthcare services',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (!_isOTPSent) ...[
              Form(
                key: _phoneFormKey,
                child: TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter 10-digit phone number',
                    prefixText: '+91 ',
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: AppValidators.validatePhone,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: authProvider.isLoading ? null : _sendOTP,
                child: authProvider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Send OTP'),
              ),
            ] else ...[
              Form(
                key: _otpFormKey,
                child: TextFormField(
                  controller: _otpController,
                  decoration: const InputDecoration(
                    labelText: 'OTP',
                    hintText: 'Enter 6-digit OTP',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  validator: AppValidators.validateOtp,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: authProvider.isLoading ? null : _verifyOTP,
                child: authProvider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Verify OTP'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isOTPSent = false;
                    _otpController.clear();
                  });
                },
                child: const Text('Change Phone Number'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
