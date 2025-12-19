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
  static const String notificationChannelDescription = 'Medical app notifications';
}