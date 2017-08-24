param (
    [string]$logfile = $null
)

. .\settings.ps1

# The logfile will use the timestamp of local time. 
# If run this script in another script, it is important that the logfile has the same name accoss over all the scripts. 
# So we need to receive the log file name from outside. 
# If run this script standalone, no need input the logfile name, use the one defined in settings.ps1.
if ($logfile){    
    $localbackendlogfile = $logfile
}

Push-Location $masterdockerfolder
# Sometime the Stop-Transcript is not exexucted so that the Start-Transcript cannot start next time
#Stop-Transcript
#Remove-Item -Force $logfolder$backendlogfile
Start-Transcript -path $logfolder$localbackendlogfile
#docker-compose -f docker-compose-buildserver.yml -f docker-compose-dbs.yml -f docker-compose-full.yml up
docker-compose -f docker-compose-dbs.yml -f docker-compose-full.yml up
#Stop-Transcript
Pop-Location