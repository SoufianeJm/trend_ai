# Flutter Background Runner Script
$logFile = "flutter_app.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Clear previous log and add header
"=== Flutter App Started at $timestamp ===" | Out-File -FilePath $logFile -Encoding UTF8

# Start Flutter app in background with logging
Start-Process -FilePath "flutter" -ArgumentList "run" -NoNewWindow -RedirectStandardOutput "flutter_output.log" -RedirectStandardError "flutter_error.log"

Write-Host "Flutter app started in background"
Write-Host "Output log: flutter_output.log"
Write-Host "Error log: flutter_error.log"
Write-Host "Combined log: flutter_app.log"
Write-Host ""
Write-Host "To monitor logs in real-time, use:"
Write-Host "  Get-Content flutter_app.log -Wait"
Write-Host "  Get-Content flutter_output.log -Wait"
Write-Host "  Get-Content flutter_error.log -Wait"
