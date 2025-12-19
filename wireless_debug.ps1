param(
    [string]$DeviceIP = "",
    [switch]$Setup,
    [switch]$Connect,
    [switch]$Help
)

$ADB_PATH = "C:\Users\aasha\AppData\Local\Android\sdk\platform-tools\adb.exe"

function Write-Header {
    Write-Host "=== AASHA MEDIX Wireless ADB Debugging ===" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Help {
    Write-Header
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  .\wireless_debug.ps1 -Setup          # Enable wireless debugging"
    Write-Host "  .\wireless_debug.ps1 -Connect        # Connect to device wirelessly"
    Write-Host "  .\wireless_debug.ps1 -DeviceIP 192.168.1.100  # Connect to specific IP"
    Write-Host "  .\wireless_debug.ps1 -Help           # Show this help"
    Write-Host ""
    Write-Host "Prerequisites:" -ForegroundColor Yellow
    Write-Host "  1. Enable Developer Options on Android device"
    Write-Host "  2. Enable Wireless debugging in Developer Options"
    Write-Host "  3. Connect device via USB first for initial setup"
    Write-Host ""
}

function Enable-Wireless {
    Write-Host "Enabling wireless debugging..." -ForegroundColor Green

    # Enable TCP/IP mode
    & $ADB_PATH tcpip 5555

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ TCP/IP mode enabled on port 5555" -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Yellow
        Write-Host "  1. Disconnect USB cable from device"
        Write-Host "  2. Run this script with -Connect parameter"
        Write-Host "  3. Or manually run: adb connect [DEVICE_IP]:5555"
    } else {
        Write-Host "✗ Failed to enable TCP/IP mode" -ForegroundColor Red
    }
}

function Connect-Wireless {
    Write-Host "Connecting to device wirelessly..." -ForegroundColor Green

    if ($DeviceIP) {
        Write-Host "Connecting to $DeviceIP`:5555..." -ForegroundColor Yellow
        & $ADB_PATH connect "$DeviceIP`:5555"
    } else {
        # Try to auto-detect device IP
        Write-Host "Attempting to auto-detect device IP..." -ForegroundColor Yellow

        $ipRoute = & $ADB_PATH shell ip route 2>$null
        if ($ipRoute) {
            $ipMatch = $ipRoute | Select-String -Pattern "src (\d+\.\d+\.\d+\.\d+)" | ForEach-Object { $_.Matches.Groups[1].Value }
            if ($ipMatch) {
                Write-Host "Detected device IP: $ipMatch" -ForegroundColor Green
                & $ADB_PATH connect "$ipMatch`:5555"
            } else {
                Write-Host "✗ Could not detect device IP" -ForegroundColor Red
                Write-Host "Please specify IP manually: .\wireless_debug.ps1 -DeviceIP 192.168.1.100" -ForegroundColor Yellow
            }
        } else {
            Write-Host "✗ No device connected or ADB not working" -ForegroundColor Red
        }
    }
}

function Get-Devices {
    Write-Host "Current ADB devices:" -ForegroundColor Yellow
    & $ADB_PATH devices
    Write-Host ""
}

# Main logic
if ($Help) {
    Show-Help
    exit
}

Write-Header

if ($Setup) {
    Get-Devices
    Enable-Wireless
} elseif ($Connect -or $DeviceIP) {
    Connect-Wireless
    Start-Sleep -Seconds 2
    Get-Devices

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✓ Wireless connection successful!" -ForegroundColor Green
        Write-Host "You can now use Flutter with wireless debugging:" -ForegroundColor Cyan
        Write-Host "  flutter devices"
        Write-Host "  flutter run --device-id $DeviceIP`:5555" -ForegroundColor White
    }
} else {
    Show-Help
}