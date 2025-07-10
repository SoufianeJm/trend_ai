# Flutter App Log Monitor Script
# This script provides easy commands to monitor your Flutter app running in the background

Write-Host "=== Flutter App Log Monitor ===" -ForegroundColor Green
Write-Host ""

# Check if the Flutter job is running
$job = Get-Job -Name "FlutterApp" -ErrorAction SilentlyContinue

if ($job) {
    Write-Host "Flutter App Status: $($job.State)" -ForegroundColor Yellow
    Write-Host "Job ID: $($job.Id)" -ForegroundColor Cyan
    Write-Host ""
    
    if ($job.State -eq "Running") {
        Write-Host "Available Commands:" -ForegroundColor Green
        Write-Host "1. Show recent logs (last 20 lines):" -ForegroundColor White
        Write-Host "   Get-Content flutter_app.log -Tail 20" -ForegroundColor Gray
        Write-Host ""
        Write-Host "2. Monitor logs in real-time:" -ForegroundColor White
        Write-Host "   Get-Content flutter_app.log -Wait -Tail 10" -ForegroundColor Gray
        Write-Host ""
        Write-Host "3. Check job status:" -ForegroundColor White
        Write-Host "   Get-Job -Name 'FlutterApp'" -ForegroundColor Gray
        Write-Host ""
        Write-Host "4. Stop the Flutter app:" -ForegroundColor White
        Write-Host "   Stop-Job -Name 'FlutterApp'; Remove-Job -Name 'FlutterApp'" -ForegroundColor Gray
        Write-Host ""
        Write-Host "5. Restart the Flutter app:" -ForegroundColor White
        Write-Host "   Stop-Job -Name 'FlutterApp'; Remove-Job -Name 'FlutterApp'; Start-Job -ScriptBlock { Set-Location 'C:\Users\TERRA\Desktop\trend_ai\client'; flutter run --verbose 2>&1 | Tee-Object -FilePath 'flutter_app.log' } -Name 'FlutterApp'" -ForegroundColor Gray
        Write-Host ""
        
        # Show recent logs
        Write-Host "Recent logs (last 10 lines):" -ForegroundColor Yellow
        Write-Host "================================" -ForegroundColor Yellow
        if (Test-Path "flutter_app.log") {
            Get-Content "flutter_app.log" -Tail 10 | ForEach-Object { Write-Host $_ -ForegroundColor White }
        } else {
            Write-Host "Log file not found yet..." -ForegroundColor Red
        }
    } else {
        Write-Host "Flutter app is not running. Current state: $($job.State)" -ForegroundColor Red
    }
} else {
    Write-Host "No Flutter job found. App may not be running." -ForegroundColor Red
}
