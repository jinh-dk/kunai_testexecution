. .\setting.ps1
Push-Location $masterdockerfolder
# Sometime the Stop-Transcript is not exexucted so that the Start-Transcript cannot start next time
#Stop-Transcript
Remove-Item -Force $logfolder$backendlogfile
Start-Transcript -path $logfolder$backendlogfile
docker-compose -f docker-compose-dbs.yml -f docker-compose-full.yml up
Stop-Transcript
Pop-Location