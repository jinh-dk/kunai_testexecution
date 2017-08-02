. .\settings.ps1
Push-Location $masterdockerfolder

Start-Transcript -path $logfolder$localkallithealogfile
docker-compose.exe -f docker-compose-kallithea.yml up

Pop-Location