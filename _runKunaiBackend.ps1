Push-Location C:\Users\jinxu\Documents\GitHub\Kunai\docker
# Sometime the Stop-Transcript is not exexucted so that the Start-Transcript cannot start next time
#Stop-Transcript
Remove-Item -Force C:\Users\jinxu\Documents\GitHub\KunaiLog\Backend.log
Start-Transcript -path C:\Users\jinxu\Documents\GitHub\KunaiLog\Backend.log
docker-compose -f docker-compose-dbs.yml -f docker-compose-full.yml up
Stop-Transcript
Pop-Location