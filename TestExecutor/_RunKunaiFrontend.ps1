param (
    [string]$logfile = $null,
    [string]$frontendfolder = $null
)

. .\settings.ps1
# The logfile will use the timestamp of local time. 
# If run this script in another script, it is important, the logfile has the same name accoss over all the scripts. 
# So we need to receive the log file name from outside. 
# If run this script standalone, no need input the logfile name, use the one defined in settings.ps1.
if ($logfile){
    $localfrontendlogfile = $logfile
}

if (-not $frontendfolder){
    Write-Host "No Frontend folder provide, use default master front end folder."
    $frontendfolder = $masterfrontendfolder
}

Push-Location $frontendfolder
Start-Transcript -path $logfolder$localfrontendlogfile
npm install
npm update
npm start

Stop-Transcript
Pop-Location
