. .\settings.ps1
$localtime = Get-Date -Format yyyyMMddhhmmss
$logfile = $backendlogfile -replace ".log", "$localtime.log"
Push-Location $masterdockerfolder
# Sometime the Stop-Transcript is not exexucted so that the Start-Transcript cannot start next time
#Stop-Transcript
#Remove-Item -Force $logfolder$backendlogfile
Start-Transcript -path $logfolder$logfile
docker-compose -f docker-compose-dbs.yml -f docker-compose-full.yml up
Stop-Transcript
Copy-Item $logfile $backendlogfile -Force
Pop-Location