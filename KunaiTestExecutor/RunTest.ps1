.\settings.ps1

$testfwkfolder = "C:\Users\jinxu\Documents\GitHub\kunai\dev\itest\test\Publishing.IntegrationTests.Framework"
$testfwkproj = "Publishing.IntegrationTests.Framework.csproj"
#$testreportfolder = "C:\users\jinxu\Documents\GitHub\kunai\test\Log"
#$testreportname = "integrationTest.xml"
$testcasefolder_api = "C:\Users\jinxu\Documents\GitHub\kunai\dev\itest\test\Publishing.Api.IntegrationTest"
$testcaseproj_api = "Publishing.Api.IntegrationTest.csproj"


Write-Host "Stop ALL running docker containers, and node processes."
& .\StopAllPowershellProcesses.ps1
Write-host "Download the lastest artifacts, and rebuild the docker images, and restart containers."
& .\PrepareTest.ps1 -reloadkatana $true

#TODO: Need find a better way to replace hardcode waiting. 


Write-Host "Build the latest tests in DEV envionrment"
Push-Location $testfwkfolder
dotnet build $testfwkproj
Pop-Location

Write-Host "Exeucte all stable testcase, and write the result to an XML file"
Remove-Item -Force $testreportfolder$testreportname
Push-Location $testcasefolder_api
dotnet build $testcaseproj_api
dotnet xunit -notrait "Status=Unstable" -verbose -parallel none -xml $testreportfolder$testreportname
Pop-Location

Write-Host "Parse the test report, and send the Error message to Slack channel"
& .\ProcessIntegrationResult.ps1
Write-Host "Stop ALL running docker containers, and node processes."
.\StopAllPowershellProcesses.ps1
Start-Sleep -s 60


Write-Host "Test converage report and server logs are uploaded to Google Drive"
#Update the test coverage, and upload to google drive to share
# The two python script depending on hardcode file path.
Set-ExecutionPolicy Unrestricted
.\GoogleSpreadSheet\Scripts\activate

#Todo : Git the lastest file
python.exe C:\Users\jinxu\Documents\GitHub\ownScript\python\CreateTestcaseOverview\CreateTestOverview.py
python.exe C:\Users\jinxu\Documents\GitHub\ownScript\python\CreateTestcaseOverview\UploadLogToGDrive.py
deactivate
Set-ExecutionPolicy RemoteSigned
