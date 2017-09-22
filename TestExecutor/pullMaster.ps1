. .\settings.ps1
Push-Location $masterfolder
Start-Transcript $logfolder$updatemasterlogfile
git pull --rebase
git submodule update --recursive
dotnet restore
#invoke-expression 'cmd /c start powershell -Command { .\build.ps1}'  #;Read-Host 
.\build.ps1
Stop-Transcript
Pop-Location