/// Environment configuration for AASHA MEDIX.
///
/// Usage:
///   flutter run --dart-define=ENV=production
///   flutter build apk --dart-define=ENV=production \
///     --dart-define=SUPABASE_URL=https://xxx.supabase.co \
///     --dart-define=SUPABASE_ANON_KEY=your_key \
///     --dart-define=RAZORPAY_KEY=rzp_live_xxx

enum AppEnvironment { development, staging, production }

class EnvConfig {
  // Read environment from --dart-define at build time
  static const String _env = String.fromEnvironment('ENV', defaultValue: 'development');

  static const String _supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co', // Replace before release
  );

  static const String _supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key-here', // Replace before release
  );

  static const String _razorpayKey = String.fromEnvironment(
    'RAZORPAY_KEY',
    defaultValue: 'rzp_test_placeholder', // Replace with rzp_live_xxx in production
  );

  // ── Environment detection ──────────────────────────────────────────────────

  static AppEnvironment get environment {
    switch (_env) {
      case 'production':
        return AppEnvironment.production;
      case 'staging':
        return AppEnvironment.staging;
      default:
        return AppEnvironment.development;
    }
  }

  static bool get isProduction => environment == AppEnvironment.production;
  static bool get isStaging => environment == AppEnvironment.staging;
  static bool get isDevelopment => environment == AppEnvironment.development;

  // ── Credentials ───────────────────────────────────────────────────────────

  static String get supabaseUrl => _supabaseUrl;
  static String get supabaseAnonKey => _supabaseAnonKey;
  static String get razorpayKey => _razorpayKey;

  // ── Behavior flags per environment ────────────────────────────────────────

  /// Show debug banners and verbose logs only in non-production
  static bool get showDebugBanner => !isProduction;

  /// Enable detailed logging only in dev/staging
  static bool get verboseLogging => !isProduction;

  /// Send analytics events only in production
  static bool get analyticsEnabled => isProduction;

  // ── Supabase Edge Function base URL ───────────────────────────────────────
  static String get edgeFunctionsBaseUrl => '$supabaseUrl/functions/v1';

  /// AASHA DOST AI Edge Function endpoint
  /// Phase 5: Replace placeholder with live AI-connected function
  static String get aashaDostAiUrl => '$edgeFunctionsBaseUrl/aasha-dost-ai';

  // ── App metadata ──────────────────────────────────────────────────────────
  static const String appName = 'AASHA MEDIX';
  static const String appVersion = '2.1.0';
  static const String buildNumber = '1';
  static const String supportEmail = 'support@aashamedix.com';
  static const String privacyPolicyUrl = 'https://aashamedix.com/privacy';
  static const String termsUrl = 'https://aashamedix.com/terms';
}
