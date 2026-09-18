@echo off
echo ========================================
echo    RENGSE - Build Release APK
echo ========================================
cd /d "%~dp0"

echo Cleaning...
call flutter clean

echo Getting dependencies...
call flutter pub get

echo Building Release APK...
call flutter build apk --release

if exist "build\app\outputs\flutter-apk\app-release.apk" (
    copy "build\app\outputs\flutter-apk\app-release.apk" "rengse-release.apk" >nul
    echo.
    echo SUCCESS! APK: rengse-release.apk
) else (
    echo.
    echo BUILD FAILED! Check errors above.
)
pause
