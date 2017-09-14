param (
    [string]$logfile = $null,
    [string]$dockerfolder = $null
)

. .\settings.ps1

if (-not $dockerfolder)
{
    Write-Host "No destionation folder provide, use master docker folder"
    $dockerfolder = $masterdockerfolder
}

# The logfile will use the timestamp of local time. 
# If run this script in another script, it is important that the logfile has the same name accoss over all the scripts. 
# So we need to receive the log file name from outside. 
# If run this script standalone, no need input the logfile name, use the one defined in settings.ps1.
if ($logfile){    
    $localbackendlogfile = $logfile
}

Push-Location $dockerfolder
Start-Transcript -path $logfolder$localbackendlogfile
docker-compose.exe -f docker-compose-buildserver.yml -f docker-compose-dbs.yml -f docker-compose-full.yml up
Stop-Transcript
Pop-Location