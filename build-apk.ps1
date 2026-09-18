# RENGSE - Build APK PowerShell Script
# Run this in Windows PowerShell (not Git Bash)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   RENGSE - Build APK Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot

# Stop any running Gradle daemons
Write-Host "[1/5] Stopping Gradle daemons..." -ForegroundColor Yellow
Set-Location android
& .\gradlew.bat --stop 2>$null
Set-Location ..

# Kill any Java processes that might lock files
Write-Host "[2/5] Cleaning up processes..." -ForegroundColor Yellow
Get-Process -Name "java" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Clean build folder
Write-Host "[3/5] Cleaning build folders..." -ForegroundColor Yellow
if (Test-Path "build") { Remove-Item -Recurse -Force "build" }
if (Test-Path "android\.gradle") { Remove-Item -Recurse -Force "android\.gradle" }
if (Test-Path "android\app\build") { Remove-Item -Recurse -Force "android\app\build" }

# Flutter clean and get
Write-Host "[4/5] Flutter clean and get dependencies..." -ForegroundColor Yellow
& flutter clean
& flutter pub get

# Build APK
Write-Host "[5/5] Building Release APK..." -ForegroundColor Yellow
Write-Host ""

& flutter build apk --release

# Check result
$apkPath = "build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apkPath) {
    Copy-Item $apkPath "rengse-release.apk" -Force
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "   BUILD SUCCESSFUL!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "APK saved to: rengse-release.apk" -ForegroundColor Green
    Write-Host "Size: $([math]::Round((Get-Item 'rengse-release.apk').Length / 1MB, 2)) MB" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "   BUILD FAILED!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Try running this script as Administrator" -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to exit"
