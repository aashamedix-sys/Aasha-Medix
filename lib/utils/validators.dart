/// Central validation utility for AASHA MEDIX.
/// All validators return null if valid, or an error message string if invalid.
class AppValidators {
  // ──────────────────────────────────────────────
  // Patient / Auth
  // ──────────────────────────────────────────────

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required.';
    }
    final digits = value.trim().replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) {
      return 'Enter a valid 10-digit phone number.';
    }
    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP is required.';
    }
    if (value.trim().length != 6 || int.tryParse(value.trim()) == null) {
      return 'Enter a valid 6-digit OTP.';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required.';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters.';
    }
    if (value.trim().length > 100) {
      return 'Name must not exceed 100 characters.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }
    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    return null;
  }

  // ──────────────────────────────────────────────
  // Booking
  // ──────────────────────────────────────────────

  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Delivery address is required.';
    }
    if (value.trim().length < 10) {
      return 'Please enter a more complete address (at least 10 characters).';
    }
    return null;
  }

  static String? validateBookingNotes(String? value) {
    if (value != null && value.trim().length > 500) {
      return 'Notes cannot exceed 500 characters.';
    }
    return null; // Notes are optional
  }

  static String? validateCareType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a care type.';
    }
    return null;
  }

  // ──────────────────────────────────────────────
  // General
  // ──────────────────────────────────────────────

  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  static String? validatePositiveAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required.';
    }
    final amount = double.tryParse(value.trim());
    if (amount == null || amount <= 0) {
      return 'Please enter a valid positive amount.';
    }
    return null;
  }
}
