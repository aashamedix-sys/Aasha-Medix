class AppConstants {
  static const String appName = 'AASHA MEDIX';
  static const String appVersion = '1.0.0';

  // API URLs (will be updated when backend is ready)
  static const String baseUrl = 'https://api.aashamedix.com';

  // Firebase collection names
  static const String usersCollection = 'users';
  static const String testsCollection = 'tests';
  static const String bookingsCollection = 'bookings';
  static const String reportsCollection = 'reports';

  // Payment
  // static const String razorpayKeyId = 'YOUR_RAZORPAY_KEY_ID'; // Disabled for pilot

  // Notification channels
  static const String notificationChannelId = 'aasha_medix_channel';
  static const String notificationChannelName = 'AASHA MEDIX';
  static const String notificationChannelDescription =
      'Medical app notifications';

  // Backend Sync (Step 2.4A: Google Sheets)
  // Make.com webhook for patient data collection
  static const String googleSheetsWebhookUrl =
      'https://hook.eu2.make.com/781nmlxgteqkuh0g1zft2ktrwrddesbc';

  // Retry configuration for backend sync
  static const int syncMaxRetries = 3;
  static const Duration syncRetryInitialDelay = Duration(seconds: 5);
  static const int syncRetryBackoffMultiplier = 5;
  static const Duration syncHttpTimeout = Duration(seconds: 10);
}
