# AASHA MEDIX - Healthcare Platform

A comprehensive healthcare platform built with Flutter for patients and medical professionals.

## Features

- Patient booking and appointment management
- Doctor consultation services
- Diagnostic test booking
- Medicine ordering
- Medical reports and history
- Staff/admin management

## Development Setup

### Prerequisites
- Flutter SDK 3.38.5+
- Android SDK with API 36
- Android device or emulator

### Wireless Debugging Setup

For convenient development without USB cable:

#### Windows (PowerShell)
```powershell
# Enable wireless debugging
.\wireless_debug.ps1 -Setup

# Connect wirelessly (after disconnecting USB)
.\wireless_debug.ps1 -Connect
# or specify IP: .\wireless_debug.ps1 -DeviceIP 192.168.1.100
```

#### Windows (Batch)
```batch
# Enable wireless debugging
wireless_debug_setup.bat
```

#### Manual Setup
1. Connect device via USB
2. Run: `adb tcpip 5555`
3. Disconnect USB cable
4. Run: `adb connect [DEVICE_IP]:5555`
5. Verify: `flutter devices`

### Building and Running

```bash
# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Build release APK
flutter build apk --release

# Build for web
flutter build web
```

## Project Structure

```
lib/
├── screens/          # App screens
├── widgets/          # Reusable widgets
├── services/         # Business logic
├── models/           # Data models
└── utils/           # Utilities

assets/
├── images/          # Logo and images
└── icons/           # App icons

android/             # Android-specific code
ios/                # iOS-specific code
web/                # Web-specific code
```

## Branding

- **Primary Color**: #00942A (Green)
- **Secondary Color**: #E30011 (Red)
- **Logo**: Medical cross with "AASHA MEDIX" text

## Troubleshooting

### Build Issues
- Clear cache: `flutter clean && flutter pub get`
- Update dependencies: `flutter pub upgrade`

### Device Connection
- Check USB debugging is enabled
- Try wireless debugging setup
- Restart ADB: `adb kill-server && adb start-server`

### Performance
- Use `--release` flag for production testing
- Enable Flutter DevTools for profiling

## Contributing

1. Follow Flutter best practices
2. Test on both Android and iOS
3. Ensure accessibility compliance
4. Update documentation

## License

Proprietary - AASHA MEDIX Healthcare Platform
