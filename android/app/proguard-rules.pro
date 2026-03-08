# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /usr/local/Cellar/android-sdk/24.3.3/tools/proguard/proguard-android.txt

# Flutter specifically
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Supabase
-keep class io.supabase.** { *; }

# Razorpay  
-keep class com.razorpay.** { *; }
-keep interface com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**

# OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**

# Suppress warnings for Bouncycastle
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**

# Keep annotations
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
