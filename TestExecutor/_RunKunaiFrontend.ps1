. .\settings.ps1
Push-Location $masterfrontendfolder

# Sometime the Stop-Transcript is not exexucted so that the Start-Transcript cannot start next time
#Stop-Transcript
#Remove-Item -Force C:\Users\jinxu\Documents\GitHub\KunaiLog\Frontend.log
Start-Transcript -path $logfolder$localfrontendlogfile
npm install
npm update
npm start
Stop-Transcript
Pop-Location
