@echo off
echo ========================================
echo    RENGSE - Build APK Script
echo ========================================
echo.

cd /d "%~dp0"

echo [1/4] Stopping Gradle daemon...
call flutter pub get
cd android
call gradlew --stop 2>nul
cd ..

echo.
echo [2/4] Cleaning previous build...
call flutter clean

echo.
echo [3/4] Getting dependencies...
call flutter pub get

echo.
echo [4/4] Building APK...
echo.
echo Choose build type:
echo   1. Debug APK (faster, larger size)
echo   2. Release APK (optimized, smaller size)
echo.
set /p choice="Enter choice (1 or 2): "

if "%choice%"=="1" (
    echo.
    echo Building Debug APK...
    call flutter build apk --debug
    set APK_PATH=build\app\outputs\flutter-apk\app-debug.apk
) else (
    echo.
    echo Building Release APK...
    call flutter build apk --release
    set APK_PATH=build\app\outputs\flutter-apk\app-release.apk
)

echo.
if exist "%APK_PATH%" (
    echo ========================================
    echo    BUILD SUCCESSFUL!
    echo ========================================
    echo.
    echo APK Location: %APK_PATH%
    echo.

    REM Copy APK to project root for easy access
    if "%choice%"=="1" (
        copy "%APK_PATH%" "rengse-debug.apk" >nul
        echo Copied to: rengse-debug.apk
    ) else (
        copy "%APK_PATH%" "rengse-release.apk" >nul
        echo Copied to: rengse-release.apk
    )
) else (
    echo ========================================
    echo    BUILD FAILED!
    echo ========================================
    echo.
    echo Please check the error messages above.
    echo.
    echo Common fixes:
    echo   1. Close Android Studio and VS Code
    echo   2. Delete 'build' folder manually
    echo   3. Run this script again
)

echo.
pause
