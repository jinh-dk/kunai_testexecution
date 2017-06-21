﻿. .\settings.ps1

Write-Host "Stop ALL running docker containers, and node processes."
& .\StopAllPowershellProcesses.ps1
Write-host "Download the lastest artifacts, and rebuild the docker images, and restart containers."
& .\PrepareTest.ps1 -reloadkatana $true

#TODO: Need find a better way to replace hardcode waiting. 

Write-Host "Build the latest tests in DEV envionrment"
Push-Location $testfwkfolder
dotnet restore
dotnet build $testfwkproj
Pop-Location

Write-Host "Exeucte all stable testcase, and write the result to an XML file"
Remove-Item -Force $testresultfolder$testresultname
Push-Location $testcasefolder_api
dotnet restore
dotnet build $testcaseproj_api
dotnet xunit -notrait "Status=Unstable" -verbose -parallel none -xml $testresultfolder$testresultname

Pop-Location

Write-Host "Parse the test report, and send the Error message to Slack channel"
& .\ProcessIntegrationResult.ps1
Write-Host "Stop ALL running docker containers, and node processes."
.\StopAllPowershellProcesses.ps1
#Start-Sleep -s 60


Write-Host "Test converage report and server logs are uploaded to Google Drive"
#Update the test coverage, and upload to google drive to share
# The two python script depending on hardcode file path.
Set-ExecutionPolicy Unrestricted
.\GoogleSpreadSheet\Scripts\activate

curl.exe -O https://raw.githubusercontent.com/jinxuunity/ownScript/master/python/CreateTestcaseOverview/CreateTestOverview.py
curl.exe -O https://raw.githubusercontent.com/jinxuunity/ownScript/master/python/CreateTestcaseOverview/UploadLogToGDrive.py
python.exe CreateTestOverview.py
python.exe UploadLogToGDrive.py $logfolder$backendlogfile $backendlogfileid
python.exe UploadLogToGDrive.py $logfolder$frontendlogfile $frontendlogfileid

deactivate
Set-ExecutionPolicy RemoteSigned