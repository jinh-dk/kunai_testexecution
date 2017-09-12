param (
    [string]$testcasepath = $null,
    [bool]$skippreparation = $false,
    [bool]$skiptestenvironment = $false,
    [bool]$localdebugmode = $false,
    [bool]$reloadkatana = $true,
    [bool]$reloadkatanabase = $false,
    [bool]$reloadbuildserver = $false
)

. .\settings.ps1
. .\CheckServiceRunningFunc.ps1

Write-Host "Start from "$testcasepath
if (-not $testcasepath) {
    Write-Host "No Testcase path provided, use default path"
    $testcasepath = $testcasefolder_api
}

if ($localdebugmode) 
{
    Write-Host "Run Test in Debug mode "
}

Write-Host "Stop ALL running docker containers, and node processes."
& .\StopAllPowershellProcesses.ps1

if (-not $skippreparation) {
    Write-host "Download the lastest artifacts, and rebuild the docker images, and restart containers."
    & .\PrepareTest.ps1 -reloadkatana $reloadkatana -reloadkatanabase $reloadkatanabase -reloadbuildserver $reloadbuildserver   
}

if (-not $skiptestenvironment) {
    Write-host "Run Docker Based Test Environment. Log to $localbackendlogfile and $localfrontendlogfile"    
    & .\RunKunai.ps1 -localbackendlogfile $localbackendlogfile -localfrontendlogfile $localfrontendlogfile
}

#TODO: Need find a better way to replace hardcode waiting. 

Write-Host "Build the latest tests in DEV envionrment"
Push-Location $testfwkfolder
dotnet restore
dotnet build $testfwkproj
Pop-Location

Push-Location $masterdockerfolder
$isServerReady = CheckServiceRunning -Service docker_server_1
$isApiReady = CheckServiceRunning -Service docker_api_1
Pop-Location

if ($isServerReady -and $isApiReady) 
{

    Write-Host "Exeucte all stable testcase, and write the result to an XML file"
    Remove-Item -Force $testresultfolder$testresultname

    & .\ExecuteTest.ps1 -testcasepath $testcasepath

    Write-Host "Parse the test report, and send the Error message to Slack channel"
    & .\ProcessIntegrationResult.ps1 -localdebugmode $localdebugmode 


    if (-not $localdebugmode){
        Write-Host "Stop ALL running docker containers, and node processes."
        .\StopAllPowershellProcesses.ps1
    }
    #Start-Sleep -s 60

    ## The copy has to happen after stop all powershell process, otherwise the content is not flushed into file yet. 
    Push-Location $logfolder
    $d = Get-Date -Format yyyyMMdd
    docker cp $dockerserver$serverlogpath/log-$d.txt log-$d-server.txt
    docker cp $dockerapi$apilogpath/log-$d.txt log-$d-api.txt
    Pop-Location

    Write-Host "Test converage report and server logs are uploaded to Google Drive"
    #Update the test coverage, and upload to google drive to share
    # The two python script depending on hardcode file path.
    Write-Host "Copy local log file to remote logfile, $localfrontendlogfile, and $localbackendlogfile"
    Copy-Item $logfolder$localfrontendlogfile $logfolder$frontendlogfile -Force
    Copy-Item $logfolder$localbackendlogfile $logfolder$backendlogfile -Force
    Set-ExecutionPolicy Unrestricted
    Invoke-WebRequest -OutFile CreateTestOverview.py -Uri https://raw.githubusercontent.com/jinxuunity/ownScript/master/python/CreateTestcaseOverview/CreateTestOverview.py
    Invoke-WebRequest -OutFile UploadLogToGDrive.py -Uri https://raw.githubusercontent.com/jinxuunity/ownScript/master/python/CreateTestcaseOverview/UploadLogToGDrive.py
    .\GoogleSpreadSheet\Scripts\activate
    python.exe CreateTestOverview.py
    python.exe UploadLogToGDrive.py $logfolder$backendlogfile $backendlogfileid
    python.exe UploadLogToGDrive.py $logfolder$frontendlogfile $frontendlogfileid

    deactivate
    Set-ExecutionPolicy RemoteSigned
} 
else 
{
    Write-Host -ForegroundColor Red ( 'The docker envirnment is not available. Test is not running.')
    if (-not $localdebugmode){
        Write-Host "Stop ALL running docker containers, and node processes."
        .\StopAllPowershellProcesses.ps1
    }
    Set-ExecutionPolicy Unrestricted
    .\slack\Scripts\activate
    #pip install slackclient            
    python.exe .\SendErrorToSlack.py "The docker envirnment is not available. Test is not running." $ownslackChannel
    deactivate
    Set-ExecutionPolicy RemoteSigned  
}

.\CopyLogFileToOwnCloud.ps1


