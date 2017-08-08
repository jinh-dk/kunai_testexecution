. ./settings.ps1
Push-Location $masterdockerfolder


Start-Transcript -path $logfolder$localbuildserverlogfile
docker-compose -f docker-compose-buildserver.yml up


Pop-Location