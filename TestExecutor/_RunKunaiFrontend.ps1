. .\settings.ps1
Push-Location $masterfrontendfolder
$localtime = Get-Date -Format yyyyMMddhhmmss
$logfile = $frontendlogfile -replace ".log", "$localtime.log"
# Sometime the Stop-Transcript is not exexucted so that the Start-Transcript cannot start next time
#Stop-Transcript
#Remove-Item -Force C:\Users\jinxu\Documents\GitHub\KunaiLog\Frontend.log
Start-Transcript -path $logfolder$logfile
npm install
npm update
npm start
Stop-Transcript
Copy-Item $logfile $frontendlogfile -Force
Pop-Location
