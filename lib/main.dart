import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'core/supabase_client.dart';
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/doctor_provider.dart';
import 'providers/nursing_provider.dart';
import 'providers/reports_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/medicine_provider.dart';
import 'providers/admin_provider.dart';
import 'providers/diagnostics_provider.dart';
import 'screens/main_navigation.dart';
import 'screens/splash_screen.dart';
import 'utils/colors.dart';
import 'services/monitoring_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background message handler
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SupabaseClientConfig.initialize();
  await MonitoringService.initialize();

  // Catch async errors not handled by Flutter framework
  PlatformDispatcher.instance.onError = (error, stack) {
    MonitoringService.recordError(error, stack, context: 'PlatformDispatcher');
    return true;
  };
  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => NursingProvider()),
        ChangeNotifierProvider(create: (_) => ReportsProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => DiagnosticsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AASHA MEDIX',
        theme: _buildAppTheme(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: _isInitialized
            ? const MainNavigation()
            : SplashScreen(
                onInitializationComplete: () {
                  setState(() {
                    _isInitialized = true;
                  });
                },
              ),
      ),
    );
  }
}

ThemeData _buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.surface,
    fontFamily: 'Roboto',
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF2E7D32);
        }
        if (states.contains(WidgetState.disabled)) {
          return const Color(0xFFBDBDBD);
        }
        return const Color(0xFF9E9E9E);
      }),
    ),
    tooltipTheme: const TooltipThemeData(
      decoration: BoxDecoration(
        color: Color(0xFF616161),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      textStyle: TextStyle(color: Colors.white, fontSize: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      waitDuration: Duration(milliseconds: 500),
    ),
    badgeTheme: const BadgeThemeData(
      backgroundColor: Color(0xFFD32F2F),
      textColor: Colors.white,
      smallSize: 6,
      largeSize: 16,
      padding: EdgeInsets.symmetric(horizontal: 4),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: Color(0xFF2E7D32),
      unselectedLabelColor: Color(0xFF9E9E9E),
      indicatorColor: Color(0xFF2E7D32),
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1B5E20),
        letterSpacing: -0.5,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1B5E20),
        letterSpacing: -0.25,
        height: 1.2,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1B5E20),
        letterSpacing: 0,
        height: 1.3,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1B5E20),
        letterSpacing: 0,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1B5E20),
        letterSpacing: 0.15,
        height: 1.3,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1B5E20),
        letterSpacing: 0.15,
        height: 1.4,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1B5E20),
        letterSpacing: 0.15,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1B5E20),
        letterSpacing: 0.15,
        height: 1.4,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1B5E20),
        letterSpacing: 0.1,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Color(0xFF424242),
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Color(0xFF616161),
        letterSpacing: 0.25,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Color(0xFF757575),
        letterSpacing: 0.4,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.4,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.4,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.4,
      ),
    ),
  );
}
