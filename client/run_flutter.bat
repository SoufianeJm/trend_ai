@echo off
cd /d "C:\Users\TERRA\Desktop\trend_ai\client"
echo Starting Flutter app at %date% %time% > flutter_app.log
flutter run -d windows --verbose >> flutter_app.log 2>&1
