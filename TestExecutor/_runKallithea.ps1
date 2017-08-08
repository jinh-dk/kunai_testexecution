. .\settings.ps1
Push-Location $masterdockerfolder

Start-Transcript -path $logfolder$localkallithealogfile
docker-compose.exe -f docker-compose-dbs.yml down kallithea
docker-compose.exe -f docker-compose-dbs.yml up --force-recreate kallithea

Pop-Location