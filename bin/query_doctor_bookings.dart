import 'package:supabase_flutter/supabase_flutter.dart';
import 'lib/core/env_config.dart';

void main() async {
  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );
  
  final client = Supabase.instance.client;
  
  try {
    // Attempt to select 1 row just to see the structure
    final res = await client.from('doctor_bookings').select().limit(1);
    print('SUCCESS: \$res');
  } catch (e) {
    print('ERROR: \$e');
  }
}
