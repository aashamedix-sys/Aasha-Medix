@echo off
echo Setting up wireless ADB debugging for AASHA MEDIX development
echo.

REM Check if device is connected via USB
echo Checking for connected devices...
adb devices

echo.
echo To enable wireless debugging:
echo 1. Go to Settings > Developer Options > Wireless debugging on your Android device
echo 2. Enable Wireless debugging
echo 3. Note the IP address and port shown
echo 4. Or use the automated setup below
echo.

REM Enable TCP/IP mode
echo Enabling TCP/IP mode on port 5555...
adb tcpip 5555

echo.
echo Now disconnect the USB cable and run the connect script.
echo Or run: adb connect [DEVICE_IP]:5555
echo.

REM Wait for user to disconnect USB
timeout /t 5 /nobreak > nul

REM Try to detect device IP and connect
echo Attempting to detect device IP and connect...
for /f "tokens=3" %%i in ('adb shell ip route ^| findstr /r "src [0-9]"') do (
    echo Found device IP: %%i
    echo Connecting to %%i:5555...
    adb connect %%i:5555
    goto :connected
)

:connected
echo.
echo Wireless debugging setup complete!
echo You can now use: flutter devices
echo And run: flutter run --device-id [IP]:5555
pause