$ErrorActionPreference = 'Stop'
$projectRoot = $PSScriptRoot

Set-Location -LiteralPath $projectRoot

# Creates Flutter's web wrapper only when it is not already present.
if (-not (Test-Path -LiteralPath (Join-Path $projectRoot 'web'))) {
    flutter create --platforms=web .
}

flutter pub get
flutter run -d chrome
