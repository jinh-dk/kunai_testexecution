$codebase = "C:\Users\jinxu\Documents\GitHub\Kunai\frontend"
Push-Location $codebase
# Sometime the Stop-Transcript is not exexucted so that the Start-Transcript cannot start next time
#Stop-Transcript
#Remove-Item -Force C:\Users\jinxu\Documents\GitHub\KunaiLog\Frontend.log
Start-Transcript -path C:\Users\jinxu\Documents\GitHub\KunaiLog\Frontend.log
npm install
npm update
npm start
Stop-Transcript
Pop-Location
