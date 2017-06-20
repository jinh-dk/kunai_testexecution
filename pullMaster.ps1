Push-Location C:\Users\jinxu\Documents\GitHub\Kunai
Start-Transcript C:\Users\jinxu\Documents\GitHub\KunaiLog\PullMaster.log
git pull --rebase
dotnet restore
#invoke-expression 'cmd /c start powershell -Command { .\build.ps1}'  #;Read-Host 
.\build.ps1
Stop-Transcript
Pop-Location