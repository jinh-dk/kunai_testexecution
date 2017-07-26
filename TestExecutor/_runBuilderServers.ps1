. .\settings.ps1
Push-Location $masterdockerfolder


Start-Transcript -path $logfolder$localbuildserverlogfile
docker-compose.exe -f docker-compose-buildserver.yml up


Pop-Location