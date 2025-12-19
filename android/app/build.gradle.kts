plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.aasha_medix"
    compileSdk = 36  // Updated to API 36 for latest plugin compatibility
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    kotlin {
        compilerOptions {
            // Fix Kotlin daemon cache issues
            freeCompilerArgs.addAll(listOf(
                "-Xskip-metadata-version-check",
                "-Xallow-result-return-type"
            ))
        }
    }

    defaultConfig {
        // Unique Application ID for AASHA MEDIX healthcare app
        applicationId = "com.aashamedix.healthcare"
        // Minimum SDK version for Android 8.0+ compatibility
        minSdk = 26
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
