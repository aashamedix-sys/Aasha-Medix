import 'package:supabase_flutter/supabase_flutter.dart';
import 'env_config.dart';

class SupabaseClientConfig {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
      // Enable realtime features for live booking updates
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
